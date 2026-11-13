import 'package:flutter/material.dart';

import '../models/app_data.dart';
import 'schedule_page.dart';

class AllSchedulesPage extends StatefulWidget {
  const AllSchedulesPage({super.key});

  @override
  State<AllSchedulesPage> createState() => _AllSchedulesPageState();
}

class _AllSchedulesPageState extends State<AllSchedulesPage> {
  // Warna hijau butek/sage yang senada dengan halaman lainnya
  static const green = Color(0xFF69B363);
  static const darkGreen = Color(0xFF4E8D49);
  static const background = Color(0xFFF8F9FA);

  final days = const [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
  ];

  List<ClassSchedule> schedulesForDay(String day) {
    final result = AppData.schedules
        .where((schedule) => schedule.day == day)
        .toList();

    result.sort((a, b) => a.time.compareTo(b.time));
    return result;
  }

  Future<void> editSchedule(ClassSchedule schedule) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => SchedulePage(schedule: schedule),
      ),
    );
  }

  Future<void> deleteSchedule(ClassSchedule schedule) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Mata Kuliah?'),
        content: Text(
          'Jadwal ${schedule.subject} akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      AppData.schedules.remove(schedule);
      AppData.notifyScheduleChanged();
    }
  }

  Widget buildScheduleCard(ClassSchedule schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: green.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE4F2E8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.access_time,
              color: green,
              size: 21,
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
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  schedule.subject,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  schedule.faculty,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  schedule.building,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit mata kuliah',
            onPressed: () => editSchedule(schedule),
            icon: const Icon(
              Icons.edit_outlined,
              color: darkGreen,
              size: 20,
            ),
          ),
          IconButton(
            tooltip: 'Hapus mata kuliah',
            onPressed: () => deleteSchedule(schedule),
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDayCard(String day) {
    final schedules = schedulesForDay(day);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        // Kotak hari diubah menjadi hijau butek transparan yang senada
        color: green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: green.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: darkGreen,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: green),
                ),
                child: Text(
                  '${schedules.length} Mata Kuliah',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (schedules.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Belum ada jadwal kuliah.',
                style: TextStyle(
                  color: darkGreen.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            ...schedules.map(buildScheduleCard),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppData.scheduleVersion,
      builder: (context, version, child) {
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    20, 22, 20, 24,
                  ),
                  decoration: const BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal Kuliah',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Lihat dan kelola jadwal perkuliahanmu.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ...days.map(buildDayCard),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}