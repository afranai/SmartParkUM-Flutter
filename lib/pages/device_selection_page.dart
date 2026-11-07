
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'landing_page.dart';

class DeviceSelectionPage extends StatelessWidget {
  const DeviceSelectionPage({super.key});

  void openDevice(BuildContext context, bool isMobile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DevicePreviewPage(isMobile: isMobile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pale,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 36,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 950),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.local_parking_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'SMARTPARK UM',
                    style: TextStyle(
                      color: green,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Explore SmartPark',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ink,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Pilih perangkat yang ingin kamu gunakan '
                    'untuk menjelajahi sistem SmartPark UM.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: muted,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 38),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 600;

                      final mobileCard = _deviceCard(
                        context,
                        isMobile: true,
                      );

                      final desktopCard = _deviceCard(
                        context,
                        isMobile: false,
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: mobileCard),
                            const SizedBox(width: 24),
                            Expanded(child: desktopCard),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          mobileCard,
                          const SizedBox(height: 20),
                          desktopCard,
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'SMARTPARK UM • PARKIR LEBIH MUDAH',
                    style: TextStyle(
                      color: muted,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _deviceCard(
    BuildContext context, {
    required bool isMobile,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => openDevice(context, isMobile),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: green.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: _deviceIllustration(isMobile),
            ),

            const SizedBox(height: 20),

            Text(
              isMobile ? 'Smartphone' : 'Desktop',
              style: const TextStyle(
                color: ink,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              isMobile
                  ? 'Jelajahi SmartPark melalui tampilan HP.'
                  : 'Jelajahi SmartPark melalui tampilan laptop.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: muted,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => openDevice(context, isMobile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  isMobile ? 'Pilih Smartphone' : 'Pilih Desktop',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deviceIllustration(bool isMobile) {
  if (isMobile) {
    return Container(
      width: 82,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFF202A25),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4E8),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Container(
              width: 35,
              height: 7,
              margin: const EdgeInsets.only(top: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF202A25),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.local_parking_rounded,
              color: green,
              size: 34,
            ),
            const SizedBox(height: 7),
            Container(
              height: 6,
              width: 38,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const Spacer(),
            Container(
              height: 5,
              width: 22,
              margin: const EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return SizedBox(
    width: 190,
    height: 150,
    child: Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFF202A25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4E8),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Center(
                child: Icon(
                  Icons.local_parking_rounded,
                  color: green,
                  size: 48,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 10,
          width: 210,
          decoration: BoxDecoration(
            color: const Color(0xFFB8C1BB),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          height: 5,
          width: 55,
          decoration: BoxDecoration(
            color: const Color(0xFF8E9B92),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    ),
  );
}
}

class DevicePreviewPage extends StatelessWidget {
  final bool isMobile;

  const DevicePreviewPage({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EDE9),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'SmartPark UM',
                    style: TextStyle(
                      color: ink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    isMobile ? 'Smartphone Preview' : 'Desktop Preview',
                    style: const TextStyle(
                      color: muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    final width = math.min(
                      390.0,
                      constraints.maxWidth - 32,
                    );

                    final height = math.min(
                      820.0,
                      constraints.maxHeight - 24,
                    );

                    return Center(
                      child: Container(
                        width: width,
                        height: height,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF202A25),
                          borderRadius: BorderRadius.circular(42),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 25,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(34),
                          child: Column(
                            children: [
                              Container(
                                height: 23,
                                color: Colors.white,
                                alignment: Alignment.center,
                                child: Container(
                                  width: 65,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: LandingPage(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final width = math.min(
                    1150.0,
                    constraints.maxWidth - 48,
                  );

                  final height = math.min(
                    760.0,
                    constraints.maxHeight - 48,
                  );

                  return Center(
                    child: Container(
                      width: width,
                      height: height,
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: const Color(0xFF202A25),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Column(
                          children: [
                            Container(
                              height: 28,
                              color: const Color(0xFFF0F2F0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  _dot(const Color(0xFFE77770)),
                                  _dot(const Color(0xFFE9C36B)),
                                  _dot(const Color(0xFF7DBB83)),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Container(
                                      height: 17,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'smartpark.um',
                                        style: TextStyle(
                                          color: muted,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: LandingPage(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'SMARTPARK UM • DEMO PREVIEW',
                style: TextStyle(
                  color: muted,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
