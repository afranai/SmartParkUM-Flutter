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
  // Warna hijau butek/sage yang senada dengan halaman lainnya
  static const Color green = Color(0xFF69B363);
  static const Color darkGreen = Color(0xFF4E8D49);
  static const Color paleGreen = Color(0xFFE4F2E8);
  static const Color background = Color(0xFFF8F9FA);

  int selectedCamera = 1;

  // Fungsi untuk mendapatkan URL gambar berdasarkan kamera yang dipilih secara aman
  String getCameraImageUrl() {
    if (selectedCamera == 1) {
      return 'https://images.unsplash.com/photo-1590674899484-d5640e854abe?q=80&w=1000&auto=format&fit=crop';
    } else if (selectedCamera == 2) {
      return 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=1000&auto=format&fit=crop';
    } else {
      return 'https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?q=80&w=1000&auto=format&fit=crop';
    }
  }

  @override
  Widget build(BuildContext context) {
    final parking = widget.parking;
    final lowAvailability = parking.available <= 5;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Area Parkir',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // Nama dan Lokasi Parkir
            Text(
              parking.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              parking.location,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),

            // Bagian Monitoring Kamera Parkir
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: green.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.videocam,
                            color: darkGreen,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Monitoring Kamera Parkir',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade300),
                        ),
                        child: Text(
                          'SIMULASI',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Tampilan Gambar CCTV Simulasi
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.black12,
                      child: Image.network(
                        getCameraImageUrl(),
                        key: ValueKey<int>(selectedCamera),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(color: green),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tombol Pilihan Kamera (Kamera 1, 2, 3 dengan beda angle)
                  Row(
                    children: [1, 2, 3].map((camNum) {
                      final isSelected = selectedCamera == camNum;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: camNum < 3 ? 8.0 : 0.0,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedCamera = camNum;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? green
                                  : Colors.white.withOpacity(0.8),
                              foregroundColor:
                                  isSelected ? Colors.white : darkGreen,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected
                                      ? green
                                      : green.withOpacity(0.4),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Text(
                              'Kamera $camNum',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Bagian Informasi Ketersediaan Parkir
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: green.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Ketersediaan Parkir',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // Kapasitas Total
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: green.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'P',
                                style: TextStyle(
                                  color: green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${parking.capacity}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Kapasitas',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Terisi
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: green.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.two_wheeler,
                                color: green,
                                size: 22,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${parking.capacity - parking.available}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Terisi',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Slot Kosong
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: lowAvailability
                                ? const Color(0xFFFFEEEE)
                                : paleGreen,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: lowAvailability
                                  ? Colors.red.shade200
                                  : green,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                lowAvailability
                                    ? Icons.error_outline
                                    : Icons.check_circle,
                                color: lowAvailability
                                    ? Colors.red
                                    : darkGreen,
                                size: 22,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${parking.available}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: lowAvailability
                                      ? Colors.red
                                      : darkGreen,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Slot Kosong',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}