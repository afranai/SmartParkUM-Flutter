import '../models/campus_location.dart';
import 'parking_data.dart' as parking_data;

class CampusMapData {
  // Koordinat gedung tujuan.
  static const List<CampusLocation> destinations = [
    CampusLocation(
      id: 'gedung_b',
      name: 'Gedung B',
      x: 10,
      y: 10,
    ),
    CampusLocation(
      id: 'gedung_d',
      name: 'Gedung D',
      x: 30,
      y: 10,
    ),
    CampusLocation(
      id: 'gedung_c',
      name: 'Gedung C',
      x: 20,
      y: 30,
    ),
  ];

  // Koordinat parkiran di denah kampus.
  static final List<CampusParkingLocation> parkingAreas = [
    CampusParkingLocation(
      parking: parking_data.parkingAreas[0],
      x: 8,
      y: 12,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[1],
      x: 28,
      y: 12,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[2],
      x: 18,
      y: 28,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[3],
      x: 22,
      y: 38,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[4],
      x: 15,
      y: 35,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[5],
      x: 12,
      y: 45,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[6],
      x: 35,
      y: 40,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[7],
      x: 40,
      y: 20,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[8],
      x: 42,
      y: 25,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[9],
      x: 45,
      y: 18,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[10],
      x: 16,
      y: 30,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[11],
      x: 38,
      y: 8,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[12],
      x: 32,
      y: 5,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[13],
      x: 36,
      y: 12,
    ),
    CampusParkingLocation(
      parking: parking_data.parkingAreas[14],
      x: 25,
      y: 15,
    ),
  ];
}