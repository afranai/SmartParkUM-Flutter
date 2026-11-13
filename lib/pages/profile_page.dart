import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/app_data.dart';
import '../widgets/app_widgets.dart';
import 'landing_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Warna hijau butek/sage utama
  static const Color sageGreen = Color(0xFF69B363);
  static const Color darkSage = Color(0xFF4E8D49);
  static const Color paleSage = Color(0xFFE4F2E8);

  bool editing = false, changingPassword = false;
  late TextEditingController name, nim, email, faculty;
  final oldPass = TextEditingController(),
      newPass = TextEditingController(),
      confirmPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    name = TextEditingController(text: AppData.name);
    nim = TextEditingController(text: AppData.nim);
    email = TextEditingController(text: AppData.email);
    faculty = TextEditingController(text: AppData.faculty);
  }

  @override
  void dispose() {
    name.dispose();
    nim.dispose();
    email.dispose();
    faculty.dispose();
    oldPass.dispose();
    newPass.dispose();
    confirmPass.dispose();
    super.dispose();
  }

  Widget _editField(String label, TextEditingController c) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [fieldLabel(label), TextField(controller: c)],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header Profil Full ke Samping (Persis Jadwal Kuliah & Cari Parkir)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: const BoxDecoration(
                color: sageGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Kelola informasi akun dan preferensi Anda.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Bagian Konten di dalam Padding agar rapi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  // Kartu Informasi Profil Utama
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: sageGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: sageGreen.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: sageGreen,
                          child: Text(
                            AppData.name.isNotEmpty
                                ? AppData.name[0].toUpperCase()
                                : 'N',
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppData.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: darkSage,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppData.email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: paleSage,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: sageGreen.withOpacity(0.3)),
                          ),
                          child: Text(
                            'NIM: ${AppData.nim}',
                            style: const TextStyle(
                              color: darkSage,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (editing)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: sageGreen.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Edit Profil',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: darkSage,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _editField('Nama Lengkap', name),
                          _editField('NIM', nim),
                          _editField('Email', email),
                          _editField('Fakultas', faculty),
                          const SizedBox(height: 8),
                          primaryButton('Simpan Perubahan', () {
                            setState(() {
                              AppData.name = name.text;
                              AppData.nim = nim.text;
                              AppData.email = email.text;
                              AppData.faculty = faculty.text;
                              editing = false;
                            });
                          }),
                          Center(
                            child: TextButton(
                              onPressed: () => setState(() => editing = false),
                              child: const Text('Batal',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (changingPassword)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: sageGreen.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ubah Kata Sandi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: darkSage,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _editField('Kata Sandi Saat Ini', oldPass),
                          _editField('Kata Sandi Baru', newPass),
                          _editField('Konfirmasi Kata Sandi Baru', confirmPass),
                          const SizedBox(height: 8),
                          primaryButton('Simpan Kata Sandi', () {
                            if (newPass.text.isEmpty ||
                                newPass.text != confirmPass.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Konfirmasi kata sandi tidak sesuai.'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Simulasi: kata sandi berhasil diperbarui.'),
                                ),
                              );
                              setState(() => changingPassword = false);
                            }
                          }),
                          Center(
                            child: TextButton(
                              onPressed: () =>
                                  setState(() => changingPassword = false),
                              child: const Text('Kembali',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: sageGreen.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pengaturan Akun',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: darkSage,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.edit_outlined, color: sageGreen),
                            title: const Text('Edit Profil',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                            onTap: () => setState(() => editing = true),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.lock_outline, color: sageGreen),
                            title: const Text('Ubah Kata Sandi',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                            onTap: () => setState(() => changingPassword = true),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: const Text(
                              'Keluar Akun',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              AppData.loggedIn = false;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LandingPage()),
                                (_) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}