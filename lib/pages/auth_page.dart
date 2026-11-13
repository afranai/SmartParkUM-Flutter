import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../models/app_data.dart';
import '../widgets/app_widgets.dart';
import 'main_shell.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Warna hijau butek yang senada dengan halaman landing/onboarding
  static const Color myButekGreen = Color(0xFF69B363);
  static const Color myButekDarkGreen = Color(0xFF4E8D49);

  bool signup = false;
  bool obscure = true;
  bool obscureConfirm = true; // State khusus untuk konfirmasi kata sandi

  final name = TextEditingController();
  final identity = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    identity.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  void submit() {
    final enteredName = name.text.trim();
    final enteredIdentity = identity.text.trim().toLowerCase();
    final enteredPassword = password.text;

    if (enteredIdentity.isEmpty || enteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email/NIM dan kata sandi wajib diisi.')),
      );
      return;
    }

    if (signup) {
      if (enteredName.isEmpty ||
          enteredPassword.length < 6 ||
          enteredPassword != confirm.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Lengkapi nama, gunakan kata sandi minimal 6 karakter, dan pastikan konfirmasi sesuai.',
            ),
          ),
        );
        return;
      }

      final alreadyRegistered = AppData.accounts.any(
        (account) => account.identity == enteredIdentity,
      );

      if (alreadyRegistered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau NIM sudah terdaftar.')),
        );
        return;
      }

      AppData.accounts.add(
        LocalAccount(
          name: enteredName,
          identity: enteredIdentity,
          password: enteredPassword,
        ),
      );

      AppData.name = enteredName.split(' ').first;
      AppData.email = enteredIdentity;
    } else {
      LocalAccount? account;

      for (final item in AppData.accounts) {
        if (item.identity == enteredIdentity &&
            item.password == enteredPassword) {
          account = item;
          break;
        }
      }

      if (account == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun tidak ditemukan atau kata sandi salah.'),
          ),
        );
        return;
      }

      AppData.name = account.name.split(' ').first;
      AppData.email = account.identity;
    }

    AppData.loggedIn = true;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: myButekGreen,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(height: 12),

                    Center(child: appLogo(70)),
                    const SizedBox(height: 24),

                    Text(
                      signup
                          ? 'Buat Akun SmartPark UM'
                          : 'Masuk ke SmartPark UM',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      signup
                          ? 'Daftarkan akunmu untuk mulai menggunakan SmartPark.'
                          : 'Selamat datang kembali! Silakan masuk ke akunmu.',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 28),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          if (signup) ...[
                            appField(
                              'Nama Lengkap',
                              name,
                              Icons.person_outline,
                            ),
                            const SizedBox(height: 14),
                          ],

                          appField(
                            'Email atau NIM',
                            identity,
                            Icons.alternate_email,
                          ),
                          const SizedBox(height: 14),

                          appField(
                            'Kata Sandi',
                            password,
                            Icons.lock_outline,
                            obscure: obscure,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),

                          if (signup) ...[
                            const SizedBox(height: 14),
                            // Konfirmasi Kata Sandi dengan tombol mata aktif
                            appField(
                              'Konfirmasi Kata Sandi',
                              confirm,
                              Icons.lock_reset,
                              obscure: obscureConfirm,
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureConfirm = !obscureConfirm;
                                  });
                                },
                                icon: Icon(
                                  obscureConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                          ],

                          if (!signup)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Hubungi admin untuk bantuan reset kata sandi.',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Lupa kata sandi?',
                                  style: TextStyle(color: myButekDarkGreen),
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: myButekGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: submit,
                              child: Text(
                                signup ? 'Buat Akun' : 'Masuk',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            signup = !signup;
                          });
                        },
                        child: Text(
                          signup
                              ? 'Sudah punya akun? Masuk'
                              : 'Belum punya akun? Daftar sekarang',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Center(
                      child: Text(
                        'Catatan: autentikasi pada paket ini masih simulasi lokal.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}