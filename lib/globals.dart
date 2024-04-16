import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  static final Globals _singleton = Globals._internal();

  late final Preferences preferences;

  late final PackageInfo packageInfo;

  factory Globals() {
    return _singleton;
  }

  Globals._internal() {
    debugPrint("building global singleton");
    initialize();

    preferences = Preferences();
    preferences._loadPreferences().then(
      (value) {
        debugPrint("loaded preferences");
      },
    );
  }

  initialize() async {
    packageInfo = await PackageInfo.fromPlatform();
    debugPrint("loaded package info");
  }
}

class Preferences {
  late final SharedPreferences _prefs;

  double _searchRadius = 500.0; //meters
  String _lastOpenedVersion = "1.0.0";

  bool _deleteOldQueryData = true;
  bool _mobileDataWarning = true;

  SharedPreferences get prefs => _prefs;

  String get lastOpenedVersion => _lastOpenedVersion;

  set lastOpenedVersion(String value) {
    _lastOpenedVersion = value;
    _prefs.setString("lastOpenedVersion", value);
  }

  bool get mobileDataWarning => _mobileDataWarning;

  set mobileDataWarning(bool value) {
    _mobileDataWarning = value;
    _prefs.setBool("mobileDataWarning", value);
  }

  ///kilometers
  double get searchRadius => _searchRadius;

  set searchRadius(double value) {
    _searchRadius = value;
    _prefs.setDouble("searchRadius", value);
  }

  bool get deleteOldQueryData => _deleteOldQueryData;

  set deleteOldQueryData(bool value) {
    _deleteOldQueryData = value;
    _prefs.setBool("deleteOldQueryData", value);
  }

  Future<void> _loadPreferences() async {
    debugPrint("loading preferences...");
    _prefs = await SharedPreferences.getInstance();

    _lastOpenedVersion = _prefs.getString("lastOpenedVersion") ?? _lastOpenedVersion;
    _mobileDataWarning = _prefs.getBool("mobileDataWarning") ?? _mobileDataWarning;
    _searchRadius = _prefs.getDouble("searchRadius") ?? _searchRadius;
    _deleteOldQueryData = _prefs.getBool("deleteOldQueryData") ?? _deleteOldQueryData;

    debugPrint("prefs were loaded...");
  }
}
