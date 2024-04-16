import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_polywidget/flutter_map_polywidget.dart';
import 'package:fosm/enums.dart';
import 'package:fosm/math_utils.dart';
import 'package:fosm/settings.dart';
import 'package:fosm/styles.dart';
import 'package:fosm/tags.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dialogs.dart';
import 'globals.dart';
import 'overpass.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    required this.onGPSPermissionsGranted,
  });

  final Function() onGPSPermissionsGranted;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  late final AnimatedMapController _mapController =
      AnimatedMapController(vsync: this, curve: Curves.easeInOut, duration: const Duration(milliseconds: 500), mapController: MapController());
  final List<WMSEntry> wmsServers = WMSEntry.defaultEntries();
  WMSEntry currentWMSLayer = WMSEntry.osmDe();

  InteractiveFlags mapInteractiveFlags = InteractiveFlags.mobile; //flags enabling the current map controls

  //built map objects
  Map<int, Marker> nodes = {};
  Map<int, Polyline> ways = {};
  Map<int, Polygon> closedWays = {};

  String currentKey = "shop";
  String currentValue = "any";

  Position? gpsPosition;

  OSMNode? lastClickedNode;

  Duration? lastQueryDuration;
  bool isQueryRunning = false;
  bool hasAutoQueriedCurrentBbox = false;

  final Color boxSelectionColor = Colors.green;
  bool isBoxSelectionMode = false;
  bool isDragging = false;

  //corners of selection bbox
  LatLng? nw;
  LatLng? se;

  @override
  void initState() {
    super.initState();

    _fetchPosition();
  }

  Future<Position?> _fetchPosition() async {
    Position? p;
    await _determinePosition().then((value) {
      debugPrint("got position ${value.toString()}");
      setState(() {
        gpsPosition = value;
      });
      p = value;
    }, onError: (e) {
      debugPrint("failed fetching position: ${e.toString()}");
      // Styles.showSnack(context, "GPS-Position konnte nicht ermittelt werden (${e.toString()})!");
    });
    return p;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SafeArea(
              child: AppBar(
            flexibleSpace: _buildKevValueMenu(),
          ))),
      body: Stack(
        children: [
          _buildMap(),
          Positioned(top: 0, left: 0, right: 0, child: _buildToolbar()),
          Positioned(bottom: 48, right: 32, child: _buildSearchButton()),
          //full screen border during box selection mode
          IgnorePointer(
            child: Container(
              foregroundDecoration:
                  isBoxSelectionMode ? BoxDecoration(border: Border.all(color: boxSelectionColor.withOpacity(0.5), width: 3)) : null,
            ),
          ),
          //selection mode hint
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isBoxSelectionMode
                    ? _buildRoundedBar([
                        Center(
                          child: Text(
                            "Ziehe mit dem Finger einen Bereich auf!",
                            style: Styles.huge.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ])
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          //search indicator
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: isQueryRunning
                ? Center(
                    child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white70),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [SizedBox(width: 50, height: 50, child: CircularProgressIndicator()), Text("Suche läuft...")],
                    ),
                  ))
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController.mapController,
      options: MapOptions(
        onMapReady: () {
          debugPrint("map ready");
        },
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        interactionOptions: InteractionOptions(flags: mapInteractiveFlags.getFlags(), enableMultiFingerGestureRace: false),
        initialCenter: const LatLng(52.45, 13.52),
        initialZoom: 9.2,
        applyPointerTranslucencyToLayers: true,
        onPointerDown: (tapPosition, point) {
          //set first selection bbox corner
          if (isBoxSelectionMode && nw == null) {
            debugPrint("starting selection at ${point.toString()}");
            isDragging = true;
            setState(() {
              nw = point;
              se = null;
            });
          }
        },
        onPointerUp: (event, point) {
          //set second selection bbox corner
          if (isBoxSelectionMode && isDragging && nw != null) {
            debugPrint("box selection done!");

            isDragging = false;
            setState(() {
              se = point;
              isBoxSelectionMode = false;
              mapInteractiveFlags = InteractiveFlags.getPlatformDefault();
            });

            //autostart query using drawn bbox
            _queryCurrentBbox();
            setState(() {
              hasAutoQueriedCurrentBbox = true; //toggle vis of refresh button
            });
          }
        },
      ),
      children: [
        TileLayer(
      tileDisplay: const TileDisplay.fadeIn(),
      urlTemplate: currentWMSLayer.url,
      userAgentPackageName: 'com.gerlo.app',
    ),
        PolygonLayer(polygons: closedWays.values.toList()),
        PolylineLayer(polylines: ways.values.toList()),
        MarkerLayer(markers: nodes.values.toList()),

        CurrentLocationLayer(
            style: LocationMarkerStyle(
                marker: Container(
                  decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.white),
                  child: const Icon(
                    Icons.circle,
                    size: 18,
                    color: Colors.green,
                  ),
                ),
                accuracyCircleColor: Colors.green.withOpacity(0.4),
                headingSectorColor: Colors.green.shade900.withOpacity(0.6))),
        //gps pos including compass

        PolyWidgetLayer(
          polyWidgets: _buildSelectionOverlay(),
        ),

        //info overlay for last clicked node else empty
        MarkerLayer(
            markers: lastClickedNode != null
                ? [
                    Marker(
                        width: 300,
                        height: 300,
                        point: lastClickedNode!.latLng,
                        child: NodeInfoWidget(
                          size: const Size.square(300),
                          node: lastClickedNode!,
                          onClose: () {
                            setState(() {
                              lastClickedNode = null;
                            });
                          },
                        )),
                  ]
                : []),

        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              currentWMSLayer.attribution ?? "",
              onTap: () => launchUrl(Uri.parse(currentWMSLayer.attributionLink ?? "")),
            ),
          ],
        ),
      ],
    );
  }


  List<Widget> _buildSelectionOverlay() {
    bool isBboxPresent = nw != null && se != null;
    if (!isBboxPresent) {
      return [];
    }
    LatLng center = LatLng((nw!.latitude + se!.latitude) / 2, (nw!.longitude + se!.longitude) / 2);

    double w = MathUtils.haversineDistance(nw!.latitude, nw!.latitude, nw!.longitude, se!.longitude);
    double h = MathUtils.haversineDistance(nw!.latitude, se!.latitude, nw!.longitude, nw!.longitude);

    return [
      PolyWidget(
          center: center,
          widthInMeters: w.round(),
          heightInMeters: h.round(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                constraints: BoxConstraints.tight(const Size.fromWidth(100)),
                decoration: BoxDecoration(
                    border: isDragging ? null : Border.all(color: boxSelectionColor.withOpacity(0.4), width: 3),
                    color: boxSelectionColor.withOpacity(0.2)),
                child: constraints.minWidth < 100 || constraints.minHeight < 100
                    ? const SizedBox.shrink()
                    : Stack(
                        children: [
                          Positioned(
                              top: 8,
                              left: 8,
                              right: 8,
                              child: Center(
                                  child: _buildRoundedBar([
                                Text(
                                  "${w.round()} m",
                                  style: Styles.big.copyWith(color: Colors.white),
                                )
                              ]))),
                          Positioned(
                            top: 8,
                            right: 8,
                            bottom: 8,
                            child: Transform.rotate(
                              angle: MathUtils.toRadians(90).toDouble(),
                              child: Center(
                                  child: _buildRoundedBar([
                                Text(
                                  "${h.round()} m",
                                  style: Styles.big.copyWith(color: Colors.white),
                                )
                              ])),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ))
    ];
  }

  void _queryCurrentBbox() {
    if (nw != null && se != null) {
      setState(() {
        isQueryRunning = true;
      });
      _clearObjects();

      Future<QueryResult> query = Overpass.getKVInBounds(nodeKey: currentKey, nodeValue: currentValue, nw: nw!, se: se!);
      _onQueryStarted(query);
    }
  }

  Widget _buildSearchButton() {
    return FloatingActionButton(
      tooltip: "An aktueller Position suchen",
      heroTag: "searchHere",
      shape: const CircleBorder(),
      onPressed: () async {
        debugPrint("search pressed");
        setState(() {
          isQueryRunning = true;
        });

        Position? pos = await _fetchPosition();
        if (pos != null) {
          debugPrint("searching at pos ${pos.latitude}, ${pos.longitude}");

          _clearObjects();

          Future<QueryResult> query = Overpass.getKVInRadius(
              nodeKey: currentKey,
              nodeValue: currentValue,
              pos: LatLng(pos.latitude, pos.longitude),
              radius: Globals().preferences.searchRadius);
          _onQueryStarted(query, zoomToResult: true);
        } else {
          setState(() {
            isQueryRunning = false;
          });
        }
      },
      child: const Icon(Icons.gps_fixed),
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        FloatingActionButton.small(
            tooltip: "Bereich wählen",
            heroTag: "selectArea",
            onPressed: () {
              if (se != null) {
                setState(() {
                  hasAutoQueriedCurrentBbox = false;
                  nw = null;
                  se = null;
                });
              } else {
                setState(() {
                  isBoxSelectionMode = true;
                  mapInteractiveFlags = InteractiveFlags.disable;
                  nw = null;
                  se = null;
                });
              }
            },
            child: Stack(
              children: [
                const SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                        child: Icon(
                      Icons.crop_free,
                    ))),
                se != null
                    ? const Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.red,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            )),
        hasAutoQueriedCurrentBbox && !isQueryRunning
            ? FloatingActionButton.small(
                tooltip: "Erneut Gebiet abfragen",
                heroTag: "queryBbox",
                onPressed: () {
                  _queryCurrentBbox();
                },
                child: const Icon(
                  Icons.refresh,
                ),
              )
            : const SizedBox.shrink(),
        const Spacer(),
        nodes.length > 0 || ways.length > 0
            ? FloatingActionButton.small(
                tooltip: "Objekte löschen",
                heroTag: "clearObjects",
                onPressed: () {
                  _clearObjects();
                },
                child: const Icon(
                  Icons.clear,
                ),
              )
            : const SizedBox.shrink(),
        FloatingActionButton.small(
          tooltip: "Layer ändern",
          heroTag: "changeLayer",
          onPressed: () {
            _showWMSDialog((selected) {
              setState(() {
                currentWMSLayer = selected;
              });
            },);
          },
          child: const Icon(
            Icons.layers,
          ),
        ),
        FloatingActionButton.small(
          tooltip: "Einstellungen",
          heroTag: "settings",
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const SettingsRoute(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInCubic;

                  final tween = Tween(begin: begin, end: end);
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: curve,
                  );

                  return SlideTransition(
                    position: tween.animate(curvedAnimation),
                    child: child,
                  );
                },
              ),
            ).then(
              (value) {
                debugPrint("settings route result: $value");
              },
            );
          },
          child: const Icon(
            Icons.settings,
          ),
        ),
      ],
    );
  }

  void _clearObjects() {
    setState(() {
      nodes.clear();
      ways.clear();
      closedWays.clear();
      lastClickedNode = null;
    });
  }

  Container _buildRoundedBar(List<Widget> children, {Widget? title}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black38),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          title ?? const SizedBox.shrink(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildKevValueMenu() {
    double barWidth = MediaQuery.of(context).size.width / 2 - 20;

    TagKeys key = TagKeys.values.firstWhere(
      (element) {
        return element.name == currentKey;
      },
      orElse: () => TagKeys.any,
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.85),
      ),
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownMenu(
            width: barWidth,
            trailingIcon: const Icon(
              size: 20,
              Icons.expand_more,
              color: Colors.white,
            ),
            selectedTrailingIcon: const Icon(
              size: 20,
              Icons.expand_less,
              color: Colors.white,
            ),
            label: const Text("Key"),
            menuHeight: 500,
            initialSelection: TagKeys.shop,
            dropdownMenuEntries: List.generate(
              TagKeys.values.length,
              (index) {
                return DropdownMenuEntry(
                  value: TagKeys.values[index],
                  label: TagKeys.values[index].name,
                );
              },
            ),
            onSelected: (value) {
              if (value != null) {
                debugPrint("selected key '$value'");
                setState(() {
                  currentKey = value.name;
                  currentValue = "";
                });
              }
            },
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  "=",
                  style: Styles.huge.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          DropdownMenu(
            width: barWidth,
            trailingIcon: const Icon(
              size: 20,
              Icons.expand_more,
              color: Colors.white,
            ),
            selectedTrailingIcon: const Icon(
              size: 20,
              Icons.expand_less,
              color: Colors.white,
            ),
            label: const Text("Value"),
            menuHeight: 500,
            initialSelection: "*",
            dropdownMenuEntries: [const DropdownMenuEntry(value: "*", label: "any")] +
                List.generate(
                  key.vals.length,
                  (indexInner) {
                    return DropdownMenuEntry(
                      value: key.vals[indexInner],
                      label: key.vals[indexInner],
                    );
                  },
                ),
            onSelected: (value) {
              if (value != null) {
                debugPrint("selected value '$value'");
                setState(() {
                  currentValue = value;
                });
              }
            },
          )
        ],
      ),
    );
  }

  void _onQueryStarted(Future<QueryResult> query, {bool zoomToResult = false}) {
    ScaffoldMessengerState mess = ScaffoldMessenger.of(context);
    DateTime time = DateTime.now();
    query.timeout(const Duration(seconds: 10));
    query.then((result) async {
      setState(() {
        lastQueryDuration = DateTime.now().difference(time);
      });
      int c = result.outputNodes.length + result.outputWays.length;
      debugPrint("query took ${lastQueryDuration!.inMilliseconds} ms! ($c objects)");

      //todo? wenn result > 25k Objekte -> fehler zeigen/skippen?

      // wenn result > x objekte, erst per dialog fragen!
      if (c > 500) {
        bool? yes = await showSimpleDialog(context,
            title: "Warnung", message: "Deine Anfrage enthält $c Objekte.\nWirklich mit der Darstellung fortfahren?");
        if (yes == null || !yes) {
          setState(() {
            isQueryRunning = false;
          });
          return;
        }
      }

      if (c == 0) {
        mess.showSnackBar(Styles.createSnack("Keine Objekte gefunden"));
      }

      if (zoomToResult) {
        _zoomToFitQueryObjects(result);
      }

      _drawGeometry(result);
      setState(() {
        isQueryRunning = false;
      });
    }, onError: (e) {
      debugPrint("error during query: ${e.toString()}");
      mess.showSnackBar(Styles.createSnack("Fehler bei Verarbeitung der Anfrage (${e.runtimeType})"));

      setState(() {
        isQueryRunning = false;
      });
    });
  }

  Future<void> _drawGeometry(QueryResult result, {bool drawIcons = true}) async {
    for (OSMWay way in result.outputWays) {
      if (way.isClosed()) {
        setState(() {
          closedWays[way.id] = way.createPolygon();
        });
      } else {
        setState(() {
          ways[way.id] = way.createPolyline();
        });
      }
      await Future.delayed(const Duration(microseconds: 800));
    }

    for (OSMNode node in result.outputNodes) {
      setState(() {
        nodes[node.id] = drawIcons && node.tags.isNotEmpty
            ? node.createIconMarker(
                onTap: (node) {
                  _onNodeTapped(node);
                },
              )
            : node.createEditorMarker();
      });
      await Future.delayed(const Duration(microseconds: 800));
    }
  }

  void _onNodeTapped(OSMNode node) {
    debugPrint("map node tapped listener called for ${node.id}");
    setState(() {
      lastClickedNode = node;
    });
    _moveToLatLng(node.latLng);
  }

  void _showWMSDialog(void Function(WMSEntry selected) onSelected) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WMSDialog(
                botOffsetFactor: 0.3,
                leftOffsetFactor: 0.6,
                wmsServers: wmsServers,
                onWMSSelected: (WMSEntry selected) {
                  debugPrint("setting wms to ${selected.displayName}...");

                  onSelected(selected);

                },
                onWMSAdded: (WMSEntry entry) {
                  setState(() {
                    wmsServers.insert(wmsServers.length - 1, entry); //vor add entry option einfügen
                    //todo? mit shared prefs speichern + laden
                  });
                });
          },
        );
      },
    );
  }

  _moveToLatLng(LatLng latLng) {
    _mapController.animateTo(dest: latLng, curve: Curves.easeInCubic);
  }

  _zoomToFit({required List<LatLng> latlngs, double padding = 16.0}) {
    _mapController.animatedFitCamera(
        cameraFit: CameraFit.coordinates(coordinates: latlngs, padding: EdgeInsets.all(padding)), curve: Curves.easeInCubic);
  }

  _zoomToFitQueryObjects(QueryResult query) {
    List<LatLng> list = [];

    for (OSMNode m in query.outputNodes) {
      list.add(m.latLng);
    }

    for (OSMWay l in query.outputWays) {
      list.addAll(l.getNodeLatLngs());
    }

    if (list.length > 1) {
      _zoomToFit(latlngs: list, padding: 40);

      //move directly to latlng if only 1 result
    } else if (list.isNotEmpty) {
      _moveToLatLng(list.first);
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    ScaffoldMessengerState mess = ScaffoldMessenger.of(context);
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        mess.showSnackBar(Styles.createSnack("GPS-Berechtigungen sind erforderlich!"));
        return Future.error('Location permissions are denied');
      } else {
        debugPrint("permission were just granted!");
        //force route restart
        widget.onGPSPermissionsGranted();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      mess.showSnackBar(Styles.createSnack("GPS-Berechtigungen wurden explizit nicht erteilt. Bitte prüfe deine Einstellungen!"));

      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // permissions are granted
    return await Geolocator.getCurrentPosition();
  }
}

class NodeInfoWidget extends StatelessWidget {
  const NodeInfoWidget({
    super.key,
    required this.node,
    required this.onClose,
    required this.size,
  });

  final Size size;
  final OSMNode node;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, String>> tags = node.tags.entries.toList();
    tags.sort(
      (a, b) {
        return a.key.compareTo(b.key);
      },
    );
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.85), width: 2)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                SizedBox(width: size.width * 0.75, child: Text(node.tags["name"] != null ? "${node.tags["name"]}" : "Tags")),
                const Spacer(),
                Styles.buildIconButton(
                  iconData: Icons.close,
                  onPressed: () {
                    onClose();
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: _buildTagItem("OSM ID", "${node.id}"),
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1)),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  var entry = tags[index];
                  return _buildTagItem(entry.key, entry.value);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildTagItem(String key, String value) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      width: size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: Styles.normal.copyWith(color: Colors.black.withOpacity(0.5)),
            textAlign: TextAlign.start,
          ),
          const Spacer(),
          Container(
            constraints: BoxConstraints(maxWidth: size.width * 0.6),
            child: Text(
              value,
              style: Styles.normal.copyWith(height: 1,color: Colors.black),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class IconMarker extends StatelessWidget {
  const IconMarker({
    super.key,
    required this.icon,
    required this.onTap,
    required this.node,
  });

  final OSMNode node;
  final void Function(OSMNode node) onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("tapped on icon marker :$this");
        onTap(node);
      },
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.black,
        shape: const CircleBorder(),
        child: Container(
            decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(color: icon.color ?? Colors.white)), color: Colors.white70),
            child: icon),
      ),
    );
  }
}
