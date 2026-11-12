
import 'parking_area.dart';

class CampusLocation {
  final String id;
  final String name;
  final double x;
  final double y;

  const CampusLocation({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
  });
}

class CampusParkingLocation {
  final ParkingArea parking;
  final double x;
  final double y;

  const CampusParkingLocation({
    required this.parking,
    required this.x,
    required this.y,
  });

  String get code => parking.code;
  String get name => parking.name;
  String get location => parking.location;
  int get available => parking.available;
  int get capacity => parking.capacity;
  double get occupancy => parking.occupancy;
}

// Model yang digunakan di CampusMapData.
class CampusParking extends CampusParkingLocation {
  CampusParking({
    required String id,
    required String name,
    required double x,
    required double y,
    required int available,
    required int capacity,
  }) : super(
          parking: ParkingArea(
            id,
            name,
            name,
            available,
            capacity,
          ),
          x: x,
          y: y,
        );

  String get id => parking.code;
}

class ParkingRecommendation {
  final CampusParkingLocation parking;
  final double distance;

  const ParkingRecommendation({
    required this.parking,
    required this.distance,
  });
}
