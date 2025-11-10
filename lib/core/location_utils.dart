import 'dart:math';

/// Privacy utility to randomize coordinates
/// This helps protect user privacy by showing approximate location instead of exact spot
class LocationUtils {
  /// Randomizes coordinates within a radius (in meters)
  /// Default radius is 100 meters - enough to show general area but not exact location
  static Map<String, double> randomizeCoordinates({
    required double latitude,
    required double longitude,
    double radiusInMeters = 100.0,
  }) {
    final random = Random();

    // Earth's radius in meters
    const earthRadius = 6371000.0;

    // Generate random angle (0 to 360 degrees)
    final randomAngle = random.nextDouble() * 2 * pi;

    // Generate random distance within radius
    final randomDistance = random.nextDouble() * radiusInMeters;

    // Calculate offset in degrees
    final latOffset =
        (randomDistance * cos(randomAngle)) / earthRadius * (180 / pi);
    final lngOffset =
        (randomDistance * sin(randomAngle)) /
        (earthRadius * cos(latitude * pi / 180)) *
        (180 / pi);

    return {
      'latitude': latitude + latOffset,
      'longitude': longitude + lngOffset,
    };
  }
}
