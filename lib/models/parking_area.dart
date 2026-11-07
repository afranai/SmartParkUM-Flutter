class ParkingArea {
  final String code;
  final String name;
  final String location;
  final int available;
  final int capacity;

  const ParkingArea(
    this.code,
    this.name,
    this.location,
    this.available,
    this.capacity,
  );

  double get occupancy => (capacity - available) / capacity;
}
