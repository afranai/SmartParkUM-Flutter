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
  static const Color green = Color(0xFF43B66D);
  static const Color darkGreen = Color(0xFF24864A);
  static const Color paleGreen = Color(0xFFE4F5E9);
  static const Color background = Color(0xFFEAEAEA);

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

    // Contoh: B11 atau B12 akan diarahkan ke Gedung B.
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
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 28),
      decoration: const BoxDecoration(
        color: green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: green,
                      fontSize: 43,
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
          const SizedBox(height: 27),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(23),
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
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        today == 'Sabtu' || today == 'Minggu'
                            ? 'Selamat beristirahat!'
                            : '$greeting, semangat kuliah!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    '👩🏻',
                    style: TextStyle(fontSize: 31),
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
        border: Border.all(color: const Color(0xFFE0E0E0)),
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
      margin: const EdgeInsets.fromLTRB(17, 20, 17, 0),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: paleGreen,
                  border: Border.all(color: green),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  today,
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (schedules.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kamu belum menambahkan jadwal kuliah hari ini.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          else
            ...schedules.map(buildScheduleCard),

          InkWell(
            onTap: addSchedule,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tambahkan Jadwal Perkuliahanmu!',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    width: 39,
                    height: 39,
                    decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 27,
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
                size: 19,
              ),
              label: const Text(
                'Lihat Semua Jadwal',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 12,
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
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: paleGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.two_wheeler,
                  color: green,
                  size: 42,
                ),
              ),
              const SizedBox(width: 13),
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
                    const SizedBox(height: 7),
                    const Text(
                      'Area parkir tersedia',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
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
                width: 68,
                height: 78,
                decoration: BoxDecoration(
                  color: lowAvailability
                      ? const Color(0xFFFFEEEE)
                      : const Color(0xFFFFF5DF),
                  border: Border.all(
                    color: lowAvailability
                        ? Colors.red.shade200
                        : Colors.orange.shade300,
                  ),
                  borderRadius: BorderRadius.circular(13),
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
                        fontSize: 25,
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
          const SizedBox(height: 11),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: () => openParkingDetail(parking),
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(fontSize: 11),
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

    // Rekomendasi menggunakan gedung dari mata kuliah pertama hari ini.
    final destination = findDestination(schedules.first.building);

    if (destination == null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        padding: const EdgeInsets.all(17),
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
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Area Parkir Terdekat',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Rekomendasi untuk ${schedules.first.building}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
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
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}