import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapMarkerModel {
  final String id;
  final double latitude;
  final double longitude;
  final Color borderColor;
  final double radius;
  final String? carName;
  final String? description;

  MapMarkerModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.borderColor,
    this.radius = 50.0,
    this.carName,
    this.description,
  });

  Position get position => Position(longitude, latitude);

  int colorToInt(Color color) {
    return ((color.a * 255).toInt() << 24) |
        ((color.r * 255).toInt() << 16) |
        ((color.g * 255).toInt() << 8) |
        (color.b * 255).toInt();
  }

  Map<String, dynamic> toCircleAnnotationOptions() {
    return {
      'circleRadius': radius,
      'circleColor': colorToInt(borderColor),
      'circleStrokeWidth': 3.0,
      'circleStrokeColor': colorToInt(borderColor),
      'circleOpacity': 0.3,
      'circleStrokeOpacity': 1.0,
    };
  }
}
