import 'dart:math';

import '../models/campus_location.dart';
import '../data/campus_map_data.dart';

class ParkingRecommendationService {
  // Menghitung jarak antara dua titik pada denah
  static double calculateDistance(
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    final dx = x2 - x1;
    final dy = y2 - y1;

    return sqrt(dx * dx + dy * dy);
  }

  // Mengambil tiga rekomendasi parkir terdekat
  static List<ParkingRecommendation> recommendParking(
    String destinationId,
  ) {
    final destination = CampusMapData.destinations.firstWhere(
      (item) => item.id == destinationId,
    );

    // Hanya mengambil area parkir yang masih tersedia
    final availableParking = CampusMapData.parkingAreas
        .where((parking) => parking.available > 0)
        .toList();

    // Menghitung jarak setiap area parkir
    final recommendations = availableParking.map((parking) {
      final distance = calculateDistance(
        destination.x,
        destination.y,
        parking.x,
        parking.y,
      );

      return ParkingRecommendation(
        parking: parking,
        distance: distance,
      );
    }).toList();

    // Mengurutkan dari jarak paling dekat
    recommendations.sort(
      (a, b) => a.distance.compareTo(b.distance),
    );

    // Mengambil maksimal tiga rekomendasi
    return recommendations.take(3).toList();
  }
}