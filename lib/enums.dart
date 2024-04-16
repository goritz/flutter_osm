import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

enum InteractiveFlags {
  desktop,
  mobile,
  disable;

  const InteractiveFlags();

  static InteractiveFlags getPlatformDefault() {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return InteractiveFlags.desktop;
    } else {
      return InteractiveFlags.mobile;
    }
  }

//TODO? setting für fling animation
  int getFlags() {
    switch (this) {
      case desktop:
        return InteractiveFlag.drag
            //| InteractiveFlag.flingAnimation
            ;
      case mobile:
        return InteractiveFlag.drag |
            InteractiveFlag.flingAnimation |
            InteractiveFlag.pinchMove |
            InteractiveFlag.pinchZoom |
            // InteractiveFlag.rotate |
            InteractiveFlag.doubleTapZoom;
      case disable:
        return InteractiveFlag.none;
    }
  }
}

/// Helper-Klasse für auswählbare WMS-Dienste
class WMSEntry {
  String url;
  String displayName;
  String? attribution;
  String? attributionLink;
  bool editable;

  double opacity = 1.0;

  //TODO zusätzliche wms entries usw aus config/pref lesen!
  //TODO wms subdomains unterstützen:
  // TileLayer(
  //     urlTemplate:
  //     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  //     subdomains: ['a', 'b', 'c']),

  WMSEntry.custom({required this.url, required this.displayName, this.editable = true});

  WMSEntry.local(
      {this.url = "http://localhost:8080/styles/test-style/{z}/{x}/{y}.png",
      this.displayName = "Lokaler Tileserver (Offline)",
      this.attribution = "TileServer GL | Datengrundlage: ©OpenStreetMap Contributors",
      this.attributionLink = "https://www.openstreetmap.org/copyright",
      this.editable = false});

  WMSEntry.osmDe(
      {this.url = "https://tile.openstreetmap.de/{z}/{x}/{y}.png",
      this.displayName = "OpenStreetMap Deutschland",
      this.attribution = "©OpenStreetMap Contributors",
      this.attributionLink = "https://www.openstreetmap.org/copyright",
      this.editable = false});

  WMSEntry.osmOrg(
      {this.url = "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      this.displayName = "OpenStreetMap Tileprovider",
      this.attribution = "©OpenStreetMap Contributors",
      this.attributionLink = "https://www.openstreetmap.org/copyright",
      this.editable = false});

  WMSEntry.top(
      {this.url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web/default/WEBMERCATOR/{z}/{y}/{x}.png",
      this.displayName = "TopPlusOpen",
      this.attribution = "©Bundesamt für Kartographie und Geodäsie (2024)",
      this.attributionLink = "https://sgx.geodatenzentrum.de/web_public/gdz/datenquellen/Datenquellen_TopPlusOpen.html",
      this.editable = false});

  WMSEntry.sgxTopGrau(
      {this.url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_grau/default/WEBMERCATOR/{z}/{y}/{x}.png",
      this.displayName = "TopPlusOpen Graustufen",
      this.attribution = "©Bundesamt für Kartographie und Geodäsie (2024)",
      this.attributionLink = "https://sgx.geodatenzentrum.de/web_public/gdz/datenquellen/Datenquellen_TopPlusOpen.html",
      this.editable = false});

  WMSEntry.sgxTopLight(
      {this.url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light/default/WEBMERCATOR/{z}/{y}/{x}.png",
      this.displayName = "TopPlusOpen Light",
      this.attribution = "©Bundesamt für Kartographie und Geodäsie (2024)",
      this.attributionLink = "https://sgx.geodatenzentrum.de/web_public/gdz/datenquellen/Datenquellen_TopPlusOpen.html",
      this.editable = false});

  WMSEntry.sgxTopLightGrau(
      {this.url = "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web_light_grau/default/WEBMERCATOR/{z}/{y}/{x}.png",
      this.displayName = "TopPlusOpen Light Grau",
      this.attribution = "©Bundesamt für Kartographie und Geodäsie (2024)",
      this.attributionLink = "https://sgx.geodatenzentrum.de/web_public/gdz/datenquellen/Datenquellen_TopPlusOpen.html",
      this.editable = false});

  WMSEntry.orm(
      {this.url = "https://a.tiles.openrailwaymap.org/standard/{z}/{x}/{y}.png",
      this.displayName = "OpenRailwayMap",
      this.attribution = "©OpenStreetMap Contributors",
      this.attributionLink = "https://www.openstreetmap.org/copyright",
      this.editable = false});

  WMSEntry.esriWorldImagery(
      {this.url = "https://server.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
      this.displayName = "Esri World Imagery",
      this.attribution = "Esri, Maxar, Earthstar Geographics, and the GIS User Community",
      this.attributionLink = "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer",
      this.editable = false});

  WMSEntry.osmGps(
      {this.url = "https://a.gps-tile.openstreetmap.org/lines/{z}/{x}/{y}.png",
      this.displayName = "OpenStreetMap GPS-Tracks",
      this.attribution = "©OpenStreetMap Contributors",
      this.attributionLink = "https://www.openstreetmap.org/copyright",
      this.editable = false});

  WMSEntry.customTemplate({this.url = "", this.displayName = "Eigenen Tileprovider hinzufügen...", this.editable = true});

  @override
  bool operator ==(Object other) => identical(this, other) || other is WMSEntry && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() {
    return 'WMSEntry{url: $url, displayName: $displayName, attribution: $attribution, attributionLink: $attributionLink, editable: $editable}';
  }

  static List<WMSEntry> defaultEntries() {
    return [
      // WMSEntry.customTemplate(), //edit funktion raus
      WMSEntry.osmDe(),
      WMSEntry.local(),
      WMSEntry.osmOrg(),
      WMSEntry.osmGps(),
      WMSEntry.orm(),
      WMSEntry.top(),
      WMSEntry.sgxTopGrau(),
      WMSEntry.sgxTopLight(),
      WMSEntry.sgxTopLightGrau(),
      WMSEntry.esriWorldImagery()
    ];
  }
}
