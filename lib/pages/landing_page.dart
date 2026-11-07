
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import '../widgets/app_widgets.dart';
import 'auth_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void nextPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: PageView(
              controller: controller,
              children: [
                _intro(),
                _onboard(context, 1),
                _onboard(context, 2),
                _onboard(context, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _intro() {
    return Container(
      color: green,
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          appLogo(112),

          const SizedBox(height: 24),

          Text(
            'SmartPark',
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: yellow,
            ),
          ),

          const Text(
            'UNIVERSITAS NEGERI MALANG',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),

          const Spacer(),

          whiteButton(
            'Jelajahi Sekarang',
            nextPage,
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _onboard(BuildContext context, int page) {
    final titles = [
      '',
      'Parkir Menjadi Lebih Mudah',
      'Cek Sebelum Berangkat',
      'Temukan Tempat Parkirmu!',
    ];

    final descriptions = [
      '',
      'Temukan lokasi parkir terdekat tanpa harus berkeliling mencari tempat kosong.',
      'Lihat ketersediaan tempat parkir di kampus melalui informasi area parkir dan CCTV.',
      'Pilih area parkir yang tersedia dan temukan lokasi parkir tujuanmu dengan mudah.',
    ];

    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            color: green,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: previousPage,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),

                const Spacer(),

                _illustration(page),

                const Spacer(),
              ],
            ),
          ),
        ),

        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(28, 22, 28, 26),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    3,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 6),
                      height: 6,
                      width: i == page - 1 ? 25 : 7,
                      decoration: BoxDecoration(
                        color: i == page - 1
                            ? green
                            : const Color(0xFFDCE5DE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  titles[page],
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  descriptions[page],
                  style: const TextStyle(
                    color: muted,
                    height: 1.6,
                  ),
                ),

                const Spacer(),

                primaryButton(
                  page == 3 ? 'Mulai Sekarang' : 'Lanjutkan',
                  () {
                    if (page < 3) {
                      nextPage();
                    } else {
                      go(context, const AuthPage());
                    }
                  },
                ),

                if (page == 3)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        go(context, const AuthPage());
                      },
                      child: const Text(
                        'Sudah punya akun? Masuk',
                        style: TextStyle(color: darkGreen),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _illustration(int page) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              appLogo(30),
              const SizedBox(width: 8),
              const Text(
                'SmartPark UM',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (page == 1) ...[
            const Icon(
              Icons.local_parking,
              size: 65,
              color: green,
            ),

            const Text(
              'Parkir lebih praktis',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 12),

            _miniBar('Area B11', '35 kendaraan'),
          ] else if (page == 2) ...[
            Container(
              height: 95,
              decoration: BoxDecoration(
                color: const Color(0xFFE4F2E8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Icon(
                  Icons.videocam_rounded,
                  size: 55,
                  color: darkGreen,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: List.generate(
                3,
                (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEFE1),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                        child: Text(
                          'CAM ${index + 1}',
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            const Icon(
              Icons.map_rounded,
              size: 65,
              color: green,
            ),

            const Text(
              'Halo, Naila!',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),

            _miniBar(
              'B20 Fakultas Teknik',
              '12 slot kosong',
            ),

            _miniBar(
              'D19 Fakultas Teknik',
              '8 slot kosong',
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniBar(String title, String subtitle) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: pale,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 9,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}
