
import 'package:flutter/material.dart';
import '../models/app_data.dart';

class SchedulePage extends StatefulWidget {
  final ClassSchedule? schedule;

  const SchedulePage({
    super.key,
    this.schedule,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  static const Color green = Color(0xFF43B66D);

  final subjectController = TextEditingController();
  final buildingController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  String day = 'Senin';
  String faculty = 'Fakultas Teknik (FT)';

  final days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
  ];

  final faculties = [
    'Fakultas Ilmu Pendidikan (FIP)',
    'Fakultas Sastra (FS)',
    'Fakultas Matematika dan Ilmu Pengetahuan Alam (FMIPA)',
    'Fakultas Ekonomi dan Bisnis (FEB)',
    'Fakultas Teknik (FT)',
    'Fakultas Ilmu Keolahragaan (FIK)',
    'Fakultas Ilmu Sosial (FIS)',
    'Fakultas Pendidikan Psikologi (FPPsi / Psikologi)',
    'Fakultas Kedokteran (FK)',
    'Fakultas Vokasi',
  ];

  bool get isEditing => widget.schedule != null;

  @override
  void initState() {
    super.initState();

    final existing = widget.schedule;

    if (existing != null) {
      subjectController.text = existing.subject;
      buildingController.text = existing.building;
      day = days.contains(existing.day) ? existing.day : 'Senin';
      faculty = faculties.contains(existing.faculty)
          ? existing.faculty
          : 'Fakultas Teknik (FT)';

      final parts = existing.time.split('-');

      if (parts.length == 2) {
        startTimeController.text = parts[0].trim();
        endTimeController.text = parts[1].trim();
      }
    }
  }

  @override
  void dispose() {
    subjectController.dispose();
    buildingController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  InputDecoration decoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: green),
      filled: true,
      fillColor: const Color(0xFFF5F8F5),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: green, width: 1.5),
      ),
    );
  }

  Widget label(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget dropdownField({
    required String title,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label(title),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: decoration('Pilih $title', icon),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Memeriksa format jam HH.MM.
  int? convertTimeToMinutes(String value) {
    final match = RegExp(r'^([01]\d|2[0-3])\.([0-5]\d)$')
        .firstMatch(value.trim());

    if (match == null) return null;

    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);

    return hour * 60 + minute;
  }

  void saveSchedule() {
    final subject = subjectController.text.trim();
    final building = buildingController.text.trim();
    final start = startTimeController.text.trim();
    final end = endTimeController.text.trim();

    if (subject.isEmpty ||
        building.isEmpty ||
        start.isEmpty ||
        end.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi semua informasi mata kuliah.'),
        ),
      );
      return;
    }

    final startMinutes = convertTimeToMinutes(start);
    final endMinutes = convertTimeToMinutes(end);

    if (startMinutes == null || endMinutes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Format jam harus HH.MM, contoh 07.35 atau 13.10.',
          ),
        ),
      );
      return;
    }

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jam selesai harus setelah jam mulai.'),
        ),
      );
      return;
    }

    final updatedSchedule = ClassSchedule(
      subject: subject,
      day: day,
      time: '$start - $end',
      faculty: faculty,
      building: building,
    );

    if (isEditing) {
      final index = AppData.schedules.indexOf(widget.schedule!);

      if (index != -1) {
        AppData.schedules[index] = updatedSchedule;
      }
    } else {
      AppData.schedules.add(updatedSchedule);
    }

    AppData.notifyScheduleChanged();

    Navigator.pop(context, true);
  }

  Widget timeInput({
    required String title,
    required TextEditingController controller,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label(title),
          TextField(
            controller: controller,
            keyboardType: TextInputType.datetime,
            maxLength: 5,
            style: const TextStyle(fontSize: 13),
            decoration: decoration(
              'Contoh: 07.35',
              Icons.access_time,
            ).copyWith(
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: Text(
          isEditing ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.edit_calendar_outlined,
                  color: Colors.white,
                  size: 35,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isEditing
                        ? 'Perbarui informasi mata kuliahmu.'
                        : 'Lengkapi informasi mata kuliah yang ingin ditambahkan.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Mata Kuliah',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                label('Nama Mata Kuliah'),
                TextField(
                  controller: subjectController,
                  style: const TextStyle(fontSize: 13),
                  decoration: decoration(
                    'Contoh: Mobile Computing',
                    Icons.menu_book_outlined,
                  ),
                ),
                const SizedBox(height: 16),

                dropdownField(
                  title: 'Hari Kuliah',
                  value: day,
                  items: days,
                  icon: Icons.calendar_today_outlined,
                  onChanged: (value) {
                    if (value != null) setState(() => day = value);
                  },
                ),
                const SizedBox(height: 16),

                label('Jam Kuliah'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    timeInput(
                      title: 'Jam Mulai',
                      controller: startTimeController,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 42,
                        left: 9,
                        right: 9,
                      ),
                      child: Text(
                        '-',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    timeInput(
                      title: 'Jam Selesai',
                      controller: endTimeController,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    'Masukkan format 24 jam, contoh 07.35 dan 09.00.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                dropdownField(
                  title: 'Fakultas',
                  value: faculty,
                  items: faculties,
                  icon: Icons.account_balance_outlined,
                  onChanged: (value) {
                    if (value != null) setState(() => faculty = value);
                  },
                ),
                const SizedBox(height: 16),

                label('Gedung Tujuan'),
                TextField(
                  controller: buildingController,
                  style: const TextStyle(fontSize: 13),
                  decoration: decoration(
                    'Contoh: Gedung B11',
                    Icons.location_city_outlined,
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: saveSchedule,
                    icon: Icon(
                      isEditing ? Icons.save_outlined : Icons.check,
                    ),
                    label: Text(
                      isEditing ? 'Simpan Perubahan' : 'Simpan Jadwal',
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
