import 'package:flutter/material.dart';

import '../data/parking_data.dart';
import '../models/parking_area.dart';
import 'parking_detail_page.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() =>
      _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  // Warna hijau butek/sage yang senada dengan halaman lainnya
  static const Color green = Color(0xFF69B363);
  static const Color darkGreen = Color(0xFF4E8D49);
  static const Color paleGreen = Color(0xFFE4F2E8);
  static const Color background = Color(0xFFF8F9FA);

  final TextEditingController searchController =
      TextEditingController();

  String searchQuery = '';

  // Keyword alternatif untuk mempermudah pencarian parkir.
  final Map<String, List<String>> parkingKeywords = {
    'P01': [
      'b12',
      'gedung b12',
      'parkiran b12',
    ],
    'P02': [
      'masjid',
      'area masjid',
    ],
    'P03': [
      'um mart',
      'mart',
      'um',
    ],
    'P04': [
      'fik',
      'olahraga',
      'keolahragaan',
      'fakultas ilmu keolahragaan',
    ],
    'P05': [
      'fs',
      'sastra',
      'fakultas sastra',
    ],
    'P06': [
      'fip',
      'pendidikan',
      'ilmu pendidikan',
      'fakultas ilmu pendidikan',
    ],
    'P07': [
      'fis',
      'ilmu sosial',
      'sosial',
      'fakultas ilmu sosial',
    ],
    'P08': [
      'gkb a19',
      'a19',
      'gedung a19',
    ],
    'P09': [
      'gkb a20',
      'a20',
      'gedung a20',
    ],
    'P10': [
      'gkb depan',
      'depan gkb',
      'area gkb',
    ],
    'P11': [
      'feb',
      'ekonomi',
      'bisnis',
      'fakultas ekonomi dan bisnis',
    ],
    'P12': [
      'fmipa',
      'mipa',
      'matematika',
      'ipa',
      'fakultas matematika',
    ],
    'P13': [
      'gracak',
      'gra cak',
      'graha cakrawala',
      'cakrawala',
      'graha',
    ],
    'P14': [
      'fmipa 2',
      'mipa 2',
      'mipa kedua',
    ],
    'P15': [
      'rektorat',
      'graha rektorat',
      'rektor',
      'gedung rektorat',
    ],
  };

  // Pencarian berdasarkan nama, lokasi, kode, dan keyword.
  List<ParkingArea> get filteredParking {
    final query = searchQuery.trim().toLowerCase();

    final result = parkingAreas.where((parking) {
      // Hanya tampilkan parkiran yang masih memiliki slot.
      if (parking.available <= 0) {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }

      final keywords = parkingKeywords[parking.code] ?? [];

      final searchableText = [
        parking.code,
        parking.name,
        parking.location,
        ...keywords,
      ].join(' ').toLowerCase();

      return searchableText.contains(query);
    }).toList();

    // Urutkan dari slot kosong terbanyak.
    result.sort(
      (a, b) => b.available.compareTo(a.available),
    );

    return result;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Membuka halaman detail parkir.
  void openDetail(ParkingArea parking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParkingDetailPage(
          parking: parking,
        ),
      ),
    );
  }

  // Kolom pencarian.
  Widget buildSearchBox() {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Cari kode, nama, atau lokasi parkir',
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 11,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: darkGreen,
        ),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  searchController.clear();

                  setState(() {
                    searchQuery = '';
                  });
                },
                icon: const Icon(
                  Icons.close,
                  size: 20,
                  color: darkGreen,
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: green.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: green.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: darkGreen,
            width: 1.3,
          ),
        ),
      ),
    );
  }

  // Kartu informasi parkir.
  Widget buildParkingCard(ParkingArea parking) {
    final lowAvailability = parking.available <= 5;
    final occupancy = parking.occupancy.clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: paleGreen,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.two_wheeler,
                  color: green,
                  size: 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parking.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      parking.location,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Terisi ${(occupancy * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 65,
                height: 75,
                decoration: BoxDecoration(
                  color: lowAvailability
                      ? const Color(0xFFFFEEEE)
                      : const Color(0xFFFFF5DF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: lowAvailability
                        ? Colors.red.shade200
                        : Colors.orange.shade300,
                  ),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
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
              onPressed: () => openDetail(parking),
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tampilan ketika hasil pencarian kosong.
  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off,
            color: Colors.grey,
            size: 42,
          ),
          SizedBox(height: 10),
          Text(
            'Area parkir tidak ditemukan.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Coba gunakan kata kunci lain.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredParking;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: RefreshIndicator(
          color: green,
          onRefresh: () async {
            setState(() {});
          },
          child: Column(
            children: [
              // Header Hijau Butek di Atas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
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
                      'Cari Parkir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Temukan area parkir yang sesuai dengan kebutuhanmu.',
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
                  padding: const EdgeInsets.all(18),
                  children: [
                    // Panel pencarian dengan warna hijau butek transparan
                    Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
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
                          const Text(
                            'Search Rekomendasi Parkir',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cari berdasarkan kode, nama, atau lokasi parkir.',
                            style: TextStyle(
                              color: darkGreen.withOpacity(0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 14),
                          buildSearchBox(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 23),

                    // Judul daftar parkir.
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Area Parkir Tersedia',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: paleGreen,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: green),
                          ),
                          child: const Text(
                            'Slot terbanyak',
                            style: TextStyle(
                              color: darkGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      searchQuery.isEmpty
                          ? 'Diurutkan dari jumlah slot kosong terbanyak.'
                          : '${results.length} hasil ditemukan.',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Daftar hasil pencarian.
                    if (results.isEmpty)
                      buildEmptyState()
                    else
                      ...results.map(buildParkingCard),

                    const SizedBox(height: 20),

                    const Center(
                      child: Text(
                        'Data slot parkir masih berupa simulasi.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}