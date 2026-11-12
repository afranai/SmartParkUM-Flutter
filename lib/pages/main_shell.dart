
import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'recommendation_page.dart';
import 'all_schedules_page.dart';
import 'profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;

  static const Color green = Color(0xFF43B66D);
  static const Color darkGreen = Color(0xFF24864A);

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        onNavigate: (value) {
          setState(() => tab = value);
        },
      ),
      const RecommendationPage(),
      const AllSchedulesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: tab,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 76,
          backgroundColor: const Color(0xFFF3F6F0),
          indicatorColor: const Color(0xFFD5EBD7),
          indicatorShape: const StadiumBorder(),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) {
              return TextStyle(
                fontSize: 11,
                fontWeight: states.contains(WidgetState.selected)
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: states.contains(WidgetState.selected)
                    ? darkGreen
                    : Colors.black54,
              );
            },
          ),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (states) {
              return IconThemeData(
                size: 25,
                color: states.contains(WidgetState.selected)
                    ? darkGreen
                    : Colors.black54,
              );
            },
          ),
        ),
        child: NavigationBar(
          selectedIndex: tab,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (value) {
            setState(() => tab = value);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search),
              label: 'Cari Parkir',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Jadwal Kuliah',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
