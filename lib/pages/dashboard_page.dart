
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../data/parking_data.dart';
import '../models/app_data.dart';
import '../widgets/app_widgets.dart';

class DashboardPage extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const DashboardPage({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            appLogo(43),
            const Spacer(),
            CircleAvatar(
              backgroundColor: const Color(0xFFE2F2E7),
              child: Text(
                AppData.name.isNotEmpty
                    ? AppData.name[0].toUpperCase()
                    : 'N',
                style: const TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),

        Text(
          'Halo, ${AppData.name}! 👋',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Temukan parkir yang sesuai dengan tujuan kuliahmu. '
          'Cek ketersediaan sebelum berangkat!',
          style: TextStyle(
            color: muted,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Area Parkir Tersedia',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Pilih area parkir untuk melihat informasi selengkapnya.',
          style: TextStyle(
            color: muted,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 14),

        ...parkingAreas.map(
          (parking) => parkingTile(context, parking),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 30,
              ),

              const SizedBox(height: 8),

              const Text(
                'Rekomendasi Parkir',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Masukkan jadwal kuliah, jam, dan ruangan tujuan '
                'untuk mendapatkan tiga pilihan area parkir.',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.5,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 14),

              whiteButton(
                'Cari Top 3 Rekomendasi',
                () => onNavigate(1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
