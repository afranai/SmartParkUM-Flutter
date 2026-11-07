import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../data/parking_data.dart';
import '../widgets/app_widgets.dart';

class RecommendationPage extends StatefulWidget { const RecommendationPage({super.key}); @override State<RecommendationPage> createState() => _RecommendationPageState(); }
class _RecommendationPageState extends State<RecommendationPage> { String day = 'Senin', time = '07.00 - 09.00', faculty = 'Fakultas Teknik'; final room = TextEditingController(); bool searched = false;
  @override void dispose() { room.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [const Text('Temukan Parkir Terbaik 📍', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)), const SizedBox(height: 7), const Text('Atur jadwal kuliah dan lokasi tujuan untuk menemukan area parkir yang paling sesuai.', style: TextStyle(color: muted, height: 1.5)), const SizedBox(height: 22),
    appPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Cari Rekomendasi Parkir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const SizedBox(height: 5), const Text('Lengkapi informasi jadwal dan lokasi kuliahmu.', style: TextStyle(color: muted, fontSize: 12)), const SizedBox(height: 18), fieldLabel('Hari Kuliah'), appDropdown(day, ['Senin','Selasa','Rabu','Kamis','Jumat'], (v) => setState(() => day = v!)), const SizedBox(height: 13), fieldLabel('Jam Kuliah'), appDropdown(time, ['07.00 - 09.00','09.00 - 11.00','11.00 - 13.00','13.00 - 15.00','15.00 - 17.00'], (v) => setState(() => time = v!)), const SizedBox(height: 13), fieldLabel('Fakultas Tujuan'), appDropdown(faculty, ['Fakultas Teknik','Fakultas Ekonomi dan Bisnis','Fakultas Ilmu Pendidikan','Fakultas Sastra','Fakultas Ilmu Sosial'], (v) => setState(() => faculty = v!)), const SizedBox(height: 13), fieldLabel('Ruangan Tujuan'), TextField(controller: room, decoration: const InputDecoration(hintText: 'Contoh: B11', prefixIcon: Icon(Icons.meeting_room_outlined))), const SizedBox(height: 18), primaryButton('Cari Rekomendasi Parkir', () { if (room.text.trim().isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan ruangan tujuan terlebih dahulu.'))); return; } setState(() => searched = true); })])),
    if (searched) ...[const SizedBox(height: 22), const Text('Hasil Rekomendasi', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)), const Text('Area parkir yang disarankan untuk jadwalmu.', style: TextStyle(color: muted, fontSize: 12)), const SizedBox(height: 10), ...parkingAreas.map((p) => parkingTile(context, p))],
  ]);
}

