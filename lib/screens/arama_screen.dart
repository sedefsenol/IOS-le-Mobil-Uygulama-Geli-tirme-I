import 'dart:convert';
import 'package:cinescope/screens/bildirimler_screen.dart';
import 'package:cinescope/screens/hesap_screen.dart';
import 'package:cinescope/screens/home_screen.dart';
import 'package:cinescope/screens/mesajlar_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AramaScreen extends StatefulWidget {
  const AramaScreen({super.key});

  @override
  State<AramaScreen> createState() => _AramaScreenState();
}

class _AramaScreenState extends State<AramaScreen> {
  static const apiKey = "02f7a3e84e6acce9ce0b5583deffb717";
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  String selectedYil = "Yıl";
  String selectedPuan = "Puan";
  String selectedKategori = "Kategoriler";

  List<String> yillar = [
    "Yıl",
    "2024",
    "2023",
    "2022",
    "2021",
    "2020",
    "1990",
    "1980",
    "1970",
    "1960",
    "1950",
  ];
  List<String> puanlar = [
    "Puan",
    "10",
    "9",
    "8",
    "7",
    "6",
    "5",
    "4",
    "3",
    "2",
    "1",
  ];
  List<String> kategoriler = [
    "Kategoriler",
    "Aksiyon",
    "Anime",
    "Belgesel",
    "Bilim-Kurgu",
    "Drama",
    "Fantastik",
    "Gerilim",
    "Komedi",
    "Korku",
    "Müzikal",
    "Romantik",
    "Suç",
    "Tarih",
  ];

  List<dynamic> movies = [];
  bool isLoading = false;

  Future<void> searchMovies(String query) async {
    setState(() {
      isLoading = true;
    });

    String url =
        "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=tr-TR&query=$query";

    if (selectedYil != "Yıl") {
      url += "&year=$selectedYil";
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movies = data['results'];
      });
    } else {
      setState(() {
        movies = [];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF444444),
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626),
        title: const Text(
          "CineScope",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Film, dizi veya oyuncu ara...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFF262626),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    searchMovies(_searchController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2C3B),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: selectedYil,
              dropdownColor: const Color(0xFF262626),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF262626),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              items:
                  yillar
                      .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedYil = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedPuan,
              dropdownColor: const Color(0xFF262626),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF262626),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              items:
                  puanlar
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPuan = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedKategori,
              dropdownColor: const Color(0xFF262626),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF262626),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              items:
                  kategoriler
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategori = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : movies.isEmpty
                      ? Center(
                        child: Text(
                          "Hiç film bulunamadı",
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      )
                      : ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return Card(
                            color: const Color(0xFF262626),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading:
                                  movie['poster_path'] != null
                                      ? Image.network(
                                        "https://image.tmdb.org/t/p/w92${movie['poster_path']}",
                                        fit: BoxFit.cover,
                                      )
                                      : const SizedBox(width: 50),
                              title: Text(
                                movie['title'] ?? "Bilinmeyen",
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Puan: ${movie['vote_average']} - Yıl: ${movie['release_date']?.split('-')[0] ?? "-"}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF262626),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MesajlarScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BildirimlerScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HesapScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Anasayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Mesaj"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Bildirimler",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Hesap"),
        ],
      ),
    );
  }
}
