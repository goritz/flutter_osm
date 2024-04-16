import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fosm/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:xml/xml.dart';

import 'map.dart';
import 'map_style.dart';

class OSMNode {
  late final int id;
  late final LatLng latLng;
  final Map<String, String> tags = {};

  OSMNode(XmlElement xmlElement) {
    String? sid = xmlElement.getAttribute("id");
    if (sid == null) {
      throw OverpassIDError();
    }
    id = int.tryParse(sid) ?? -1;
    if (id == -1) {
      throw OverpassIDError();
    }

    String? slat = xmlElement.getAttribute("lat");
    String? slng = xmlElement.getAttribute("lon");
    if (slat == null || slng == null) {
      throw OverpassLatLngError();
    }
    double lat = double.tryParse(slat) ?? double.nan;
    double lng = double.tryParse(slng) ?? double.nan;
    if (lat.isNaN || lng.isNaN) {
      throw OverpassLatLngError();
    }
    latLng = LatLng(lat, lng);

    Iterable<XmlElement> tagsE = xmlElement.findElements("tag");
    for (XmlElement tag in tagsE) {
      String? sk = tag.getAttribute("k");
      String? sv = tag.getAttribute("v");
      if (sk == null || sv == null) {
        debugPrint("failed to parse tag ${tag.toString()} of node $id");
        continue;
      }
      tags[sk] = sv;
    }
  }

  @override
  String toString() {
    return 'OSMNode{$id, $latLng, tags: $tags}';
  }

  Marker createEditorMarker() {
    Color color = MapStyles.getNodeColor(tags);
    return Marker(
        point: latLng,
        width: 8,
        height: 8,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: color)),
        ));
  }

  Marker createIconMarker({required void Function(OSMNode node) onTap}) {
    Icon icon = MapStyles.getNodeIcon(tags);
    return Marker(
        point: latLng,
        child: IconMarker(
          icon: icon,
          onTap: onTap,
          node: this,
        ));
  }
}

class OSMRefNode {
  final int id;
  final LatLng latLng;

  OSMRefNode(this.id, this.latLng);

  @override
  String toString() {
    return 'OSMRefNodes{id: $id, latLng: $latLng}';
  }
}

class OSMWay {
  late final int id;

  late final double minLat;
  late final double minLon;
  late final double maxLat;
  late final double maxLon;

  final List<OSMRefNode> nodes = [];
  final Map<String, String> tags = {};

  OSMWay(XmlElement xmlElement) {
    String? sid = xmlElement.getAttribute("id");
    if (sid == null) {
      throw OverpassIDError();
    }
    id = int.tryParse(sid) ?? -1;
    if (id == -1) {
      throw OverpassIDError();
    }

    XmlElement? bounds = xmlElement.getElement("bounds");
    if (bounds != null) {
      String? sMinLat = bounds.getAttribute("minlat");
      String? sMinLon = bounds.getAttribute("minlon");
      String? sMaxLat = bounds.getAttribute("maxlat");
      String? sMaxLon = bounds.getAttribute("maxlon");

      if (sMinLat == null || sMinLon == null || sMaxLat == null || sMaxLon == null) {
        throw OverpassLatLngError();
      }

      minLat = double.tryParse(sMinLat) ?? double.nan;
      minLon = double.tryParse(sMinLon) ?? double.nan;
      maxLat = double.tryParse(sMaxLat) ?? double.nan;
      maxLon = double.tryParse(sMaxLon) ?? double.nan;
      if (minLat.isNaN || minLon.isNaN || maxLat.isNaN || maxLon.isNaN) {
        throw OverpassLatLngError();
      }
    }

    Iterable<XmlElement> nds = xmlElement.findElements("nd");
    for (XmlElement nd in nds) {
      String? sref = nd.getAttribute("ref");
      String? slat = nd.getAttribute("lat");
      String? slng = nd.getAttribute("lon");
      if (slat == null || slng == null || sref == null) {
        throw OverpassLatLngError();
      }
      int ref = int.tryParse(sref) ?? -1;
      double lat = double.tryParse(slat) ?? double.nan;
      double lng = double.tryParse(slng) ?? double.nan;
      if (lat.isNaN || lng.isNaN || ref == -1) {
        throw OverpassLatLngError();
      }
      nodes.add(OSMRefNode(ref, LatLng(lat, lng)));
    }

    Iterable<XmlElement> tagsE = xmlElement.findElements("tag");
    for (XmlElement tag in tagsE) {
      String? sk = tag.getAttribute("k");
      String? sv = tag.getAttribute("v");
      if (sk == null || sv == null) {
        debugPrint("failed to parse tag ${tag.toString()} of node $id");
        continue;
      }

      tags[sk] = sv;
    }
  }

  @override
  String toString() {
    return 'OSMWay{id: $id, tags: $tags,closed: ${isClosed()}, nodes: ${nodes.length}';
  }

  List<LatLng> getNodeLatLngs() {
    List<LatLng> list = [];
    for (OSMRefNode ref in nodes) {
      list.add(ref.latLng);
    }
    return list;
  }

  //fixme ways können auch closed sein aber trotzdem keine fläche! -> bei ringförmigen straßen
  bool isClosed() {
    if (nodes.length < 3) {
      return false;
    }
    return nodes.first.latLng == nodes.last.latLng;
  }

  Polyline createPolyline() {
    return Polyline(points: getNodeLatLngs(), strokeWidth: 2, color: MapStyles.getElementColor(tags));
  }

  Polygon createPolygon() {
    Color color = MapStyles.getElementColor(tags);
    return Polygon(points: getNodeLatLngs(), isFilled: true, borderStrokeWidth: 2, color: color.withOpacity(0.5), borderColor: color);
  }
}

class QueryResult {
  List<OSMNode> outputNodes = [];
  List<OSMWay> outputWays = [];

  QueryResult({required this.outputNodes, required this.outputWays});

  @override
  String toString() {
    return 'QueryResult{outputNodes: ${outputNodes.length}, outputWays: ${outputWays.length}}';
  }
}

class Overpass {
  static Future<QueryResult> getKVInRadius({
    required String nodeKey,
    required String nodeValue,
    required LatLng pos,
    double radius = 5000,
  }) {

    if(nodeValue=="*"||nodeValue=="any"){
      nodeValue="";
    }

    String s = "node++[$nodeKey${nodeValue.isNotEmpty? "=$nodeValue" : ""}]++";
    if (nodeKey == "any") {
      s = "nwr";
    }
    return _queryOverpass(query: "data=$s(around:$radius,${pos.latitude},${pos.longitude});out geom;");
  }

  static Future<QueryResult> getKVInBounds({required String nodeKey, String? nodeValue, required LatLng nw, required LatLng se}) {
    if (nodeKey.trim().isEmpty || nodeKey == "*" || nodeKey == "any") {
      return getAllInBounds(nw: nw, se: se);
    }
    if(nodeValue==null||nodeValue=="*"||nodeValue=="any"){
      nodeValue="";
    }

    String s = "node++[$nodeKey${nodeValue.isNotEmpty? "=$nodeValue" : ""}]++";

    if (nodeKey == "any") {
      s = "nwr";
    }

    return _queryOverpass(query: "data=$s(${se.latitude},${nw.longitude},${nw.latitude},${se.longitude});out;");
  }

  static Future<QueryResult> getAllInBounds({required LatLng nw, required LatLng se}) {
    return _queryOverpass(query: "data=nwr(${se.latitude},${nw.longitude},${nw.latitude},${se.longitude});out geom;");
  }

  static Future<QueryResult> _queryOverpass({required String query}) async {
    debugPrint("Running overpass query '$query'");

    http.Response resp = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: query,
    );

    List<OSMNode> outputNodes = [];
    List<OSMWay> outputWays = [];

    XmlDocument doc = XmlDocument.parse(utf8.decode(resp.bodyBytes));

    Iterable<XmlElement> ways = doc.rootElement.findElements("way");
    debugPrint("FOUND ${ways.length} ways!");
    for (XmlElement w in ways) {
      outputWays.add(OSMWay(w));
    }

    Iterable<XmlElement> nodes = doc.rootElement.findElements("node");
    debugPrint("FOUND ${nodes.length} nodes!");
    for (XmlElement n in nodes) {
      outputNodes.add(OSMNode(n));
    }

    return QueryResult(outputNodes: outputNodes, outputWays: outputWays);
  }
}
