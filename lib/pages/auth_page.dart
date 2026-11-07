
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
  bool signup = false;
  bool obscure = true;

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
    final enteredIdentity = identity.text.trim();
    final enteredPassword = password.text;

    if (enteredIdentity.isEmpty ||
        enteredPassword.isEmpty ||
        (signup &&
            (enteredName.isEmpty ||
                enteredPassword != confirm.text ||
                enteredPassword.length < 6))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi semua data. Kata sandi minimal 6 karakter dan konfirmasi harus sesuai.',
          ),
        ),
      );
      return;
    }

    if (signup) {
      AppData.name = enteredName.split(' ').first;
    } else if (AppData.name.isEmpty) {
      AppData.name = enteredIdentity.contains('@')
          ? enteredIdentity.split('@').first
          : enteredIdentity;
    }

    AppData.email = enteredIdentity;
    AppData.loggedIn = true;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainShell(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    icon: const Icon(Icons.arrow_back),
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
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    signup
                        ? 'Daftarkan akunmu untuk mulai menggunakan SmartPark.'
                        : 'Selamat datang kembali! Silakan masuk ke akunmu.',
                    style: const TextStyle(color: muted),
                  ),
                  const SizedBox(height: 28),

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
                    appField(
                      'Konfirmasi Kata Sandi',
                      confirm,
                      Icons.lock_reset,
                      obscure: true,
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
                        child: const Text('Lupa kata sandi?'),
                      ),
                    ),

                  const SizedBox(height: 16),

                  primaryButton(
                    signup ? 'Buat Akun' : 'Masuk',
                    submit,
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
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Catatan: autentikasi pada paket ini masih simulasi lokal.',
                    style: TextStyle(
                      fontSize: 11,
                      color: muted,
                      height: 1.5,
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
}
