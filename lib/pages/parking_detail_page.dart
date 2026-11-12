
import 'package:flutter/material.dart';
import '../models/parking_area.dart';

class ParkingDetailPage extends StatefulWidget {
  final ParkingArea parking;

  const ParkingDetailPage({
    super.key,
    required this.parking,
  });

  @override
  State<ParkingDetailPage> createState() => _ParkingDetailPageState();
}

class _ParkingDetailPageState extends State<ParkingDetailPage> {
  static const green = Color(0xFF43B66D);
  static const darkGreen = Color(0xFF24864A);

  int selectedCamera = 0;

  final cameraImages = [
    'https://images.unsplash.com/photo-1590674899484-d5640e854abe?w=1000',
    'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=1000',
    'https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?w=1000',
  ];

  @override
  Widget build(BuildContext context) {
    final parking = widget.parking;
    final occupied = parking.capacity - parking.available;
    final percentage = parking.occupancy.clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: const Text(
          'Detail Area Parkir',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(17),
        children: [
          Text(
            parking.name,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            parking.location,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 17),

          // Tampilan kamera utama.
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.videocam,
                      color: green,
                    ),
                    const SizedBox(width: 7),
                    const Expanded(
                      child: Text(
                        'Monitoring Kamera Parkir',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3D8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'SIMULASI',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      cameraImages[selectedCamera],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFE4F5E9),
                          child: const Center(
                            child: Icon(
                              Icons.videocam_off_outlined,
                              size: 50,
                              color: green,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(3, (index) {
                    final selected = selectedCamera == index;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == 2 ? 0 : 7,
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => selectedCamera = index);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: selected
                                ? green
                                : Colors.white,
                            foregroundColor: selected
                                ? Colors.white
                                : darkGreen,
                            side: const BorderSide(color: green),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Kamera ${index + 1}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Statistik parkir.
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Ketersediaan Parkir',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    statCard(
                      'Kapasitas',
                      '${parking.capacity}',
                      Icons.local_parking,
                    ),
                    const SizedBox(width: 9),
                    statCard(
                      'Terisi',
                      '$occupied',
                      Icons.two_wheeler,
                    ),
                    const SizedBox(width: 9),
                    statCard(
                      'Slot Kosong',
                      '${parking.available}',
                      Icons.check_circle_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Persentase Keterisian',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '${(percentage * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 12,
                    backgroundColor: const Color(0xFFE5E5E5),
                    color: percentage >= 0.8
                        ? Colors.redAccent
                        : green,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Informasi slot pada halaman ini masih menggunakan data simulasi.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF6ED),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: green, size: 21),
            const SizedBox(height: 7),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
