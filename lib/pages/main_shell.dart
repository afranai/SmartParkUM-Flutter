import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'recommendation_page.dart';
import 'profile_page.dart';

class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState() => _MainShellState(); }
class _MainShellState extends State<MainShell> { int tab = 0; @override Widget build(BuildContext context) { final pages = [DashboardPage(onNavigate: (v) => setState(() => tab = v)), const RecommendationPage(), const ProfilePage()]; return Scaffold(body: SafeArea(child: pages[tab]), bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v), destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'), NavigationDestination(icon: Icon(Icons.location_searching), label: 'Rekomendasi'), NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil')])); } }

