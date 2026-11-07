
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/landing_page.dart';
import 'utils/app_colors.dart';

class SmartParkApp extends StatelessWidget {
  const SmartParkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPark UM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pale,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          primary: green,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: pale,
          foregroundColor: ink,
          elevation: 0,
        ),
      ),

      // Semua halaman aplikasi dibatasi seperti ukuran HP.
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            final appWidth = screenWidth > 430
                ? 430.0
                : screenWidth;

            return ColoredBox(
              color: const Color(0xFFE8EDE9),
              child: Center(
                child: SizedBox(
                  width: appWidth,
                  height: screenHeight,
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            );
          },
        );
      },

      // Langsung masuk ke halaman Beranda.
      home: const LandingPage(),
    );
  }
}
