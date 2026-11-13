import '../models/parking_area.dart';
import 'package:flutter/material.dart';
import '../models/app_data.dart';
import '../models/campus_location.dart';
import '../data/campus_map_data.dart';
import '../services/parking_recommendation_service.dart';
import 'schedule_page.dart';
import 'parking_detail_page.dart';

class DashboardPage extends StatefulWidget {
  final ValueChanged<int> onNavigate;

  const DashboardPage({
    super.key,
    required this.onNavigate,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Warna hijau butek/sage yang senada dengan halaman sebelumnya
  static const Color green = Color(0xFF69B363);
  static const Color darkGreen = Color(0xFF4E8D49);
  static const Color paleGreen = Color(0xFFE4F2E8);
  static const Color background = Color(0xFFF8F9FA);

  final List<String> days = const [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
  ];

  String get today {
    final weekday = DateTime.now().weekday;

    if (weekday >= 1 && weekday <= 5) {
      return days[weekday - 1];
    }

    return weekday == 6 ? 'Sabtu' : 'Minggu';
  }

  List<ClassSchedule> get todaySchedules {
    final result = AppData.schedules
        .where((schedule) => schedule.day == today)
        .toList();

    result.sort((a, b) => a.time.compareTo(b.time));
    return result;
  }

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 11) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  // Mencocokkan gedung yang diketik pengguna dengan data denah.
  CampusLocation? findDestination(String building) {
    final input = building.toLowerCase().trim();

    if (input.isEmpty) return null;

    for (final destination in CampusMapData.destinations) {
      if (input == destination.name.toLowerCase() ||
          input.contains(destination.name.toLowerCase()) ||
          destination.name.toLowerCase().contains(input)) {
        return destination;
      }
    }

    final firstLetter = input.replaceAll(
      RegExp(r'[^a-z]'),
      '',
    );

    if (firstLetter.isNotEmpty) {
      final letter = firstLetter[0];

      for (final destination in CampusMapData.destinations) {
        final destinationName = destination.name.toLowerCase();

        if (destinationName == 'gedung $letter') {
          return destination;
        }
      }
    }

    return null;
  }

  Future<void> addSchedule() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const SchedulePage(),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  void openAllSchedules() {
    widget.onNavigate(2);
  }

  void openParkingDetail(ParkingArea parking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParkingDetailPage(parking: parking),
      ),
    );
  }

  Widget buildHeader() {
    final firstName = AppData.name.trim().isEmpty
        ? 'Mahasiswa'
        : AppData.name.trim().split(' ').first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 32),
      decoration: const BoxDecoration(
        color: green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: green,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SmartPark',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Universitas Negeri Malang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, $firstName! 👋',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        today == 'Sabtu' || today == 'Minggu'
                            ? 'Selamat beristirahat!'
                            : '$greeting, semangat kuliah!',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text(
                    '👩🏻',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScheduleCard(ClassSchedule schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: green.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: paleGreen,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.access_time,
              color: green,
              size: 22,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.time,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  schedule.subject,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  schedule.faculty,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Column(
            children: [
              const Icon(
                Icons.location_city,
                color: green,
                size: 23,
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 65,
                child: Text(
                  schedule.building,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildScheduleSection() {
    final schedules = todaySchedules;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Hijau butek transparan yang senada dengan header
        color: green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: green.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Jadwal Kuliah Hari Ini',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: darkGreen,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  border: Border.all(color: green),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  today,
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (schedules.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kamu belum menambahkan jadwal kuliah hari ini.',
                  style: TextStyle(
                    color: darkGreen.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            ...schedules.map(buildScheduleCard),

          InkWell(
            onTap: addSchedule,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                border: Border.all(color: green.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tambahkan Jadwal Perkuliahanmu!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: darkGreen,
                      ),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: openAllSchedules,
              icon: const Icon(
                Icons.calendar_month,
                color: darkGreen,
                size: 18,
              ),
              label: const Text(
                'Lihat Semua Jadwal',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildParkingCard(ParkingRecommendation recommendation) {
    final parking = recommendation.parking.parking;
    final lowAvailability = parking.available <= 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: paleGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.two_wheeler,
                  color: green,
                  size: 38,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parking.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Area parkir tersedia',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Jarak: ${recommendation.distance.toStringAsFixed(2)} unit',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 64,
                height: 72,
                decoration: BoxDecoration(
                  color: lowAvailability
                      ? const Color(0xFFFFEEEE)
                      : const Color(0xFFFFF5DF),
                  border: Border.all(
                    color: lowAvailability
                        ? Colors.red.shade200
                        : Colors.orange.shade300,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${parking.available}',
                      style: TextStyle(
                        color: lowAvailability
                            ? Colors.red
                            : Colors.orange.shade800,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'kosong',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => openParkingDetail(parking),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildParkingSection() {
    final schedules = todaySchedules;

    if (schedules.isEmpty) {
      return const SizedBox.shrink();
    }

    final destination = findDestination(schedules.first.building);

    if (destination == null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'Gedung tujuan belum cocok dengan data denah kampus. '
          'Periksa kembali nama gedung pada jadwal kuliah.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      );
    }

    final recommendations =
        ParkingRecommendationService.recommendParking(destination.id);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Area Parkir Terdekat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rekomendasi untuk ${schedules.first.building}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          if (recommendations.isEmpty)
            const Text('Belum ada area parkir yang tersedia.')
          else
            ...recommendations.map(buildParkingCard),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: RefreshIndicator(
          color: green,
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              buildHeader(),
              buildScheduleSection(),
              buildParkingSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}