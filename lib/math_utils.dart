import 'dart:math';

import 'package:latlong2/latlong.dart';

class MathUtils {
  static double R = 6371008;

  static double haversineDistance(
    double lat1,
    double lat2,
    double lon1,
    double lon2,
  ) {
    double deltaLat = toRadians(lat2 - lat1).toDouble();
    double deltaLng = toRadians(lon2 - lon1).toDouble();
    double a = sin(deltaLat / 2) * sin(deltaLat / 2) + cos(toRadians(lat1)) * cos(toRadians(lat2)) * sin(deltaLng / 2) * sin(deltaLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static num toRadians(num degrees) => degrees / 180.0 * pi;

  static num toDegrees(num rad) => rad * (180.0 / pi);
}
