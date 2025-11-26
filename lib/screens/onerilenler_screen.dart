import 'dart:convert';
import 'package:cinescope/screens/bildirimler_screen.dart';
import 'package:cinescope/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cinescope/screens/elestiriler_screen.dart' as elestiriler;
import 'package:cinescope/screens/listeler_screen.dart' as listeler;
import 'package:cinescope/screens/arama_screen.dart' as arama;
import 'package:cinescope/screens/mesajlar_screen.dart';
import 'package:cinescope/screens/hesap_screen.dart';
import 'package:cinescope/screens/filmler_screen.dart' as filmler;

class OnerilenlerScreen extends StatefulWidget {
  const OnerilenlerScreen({super.key});

  @override
  State<OnerilenlerScreen> createState() => _OnerilenlerScreenState();
}

class _OnerilenlerScreenState extends State<OnerilenlerScreen> {
  static const apiKey = "02f7a3e84e6acce9ce0b5583deffb717";
  int _selectedIndex = 0;
  int _selectedButtonIndex = 1; // Önerilenler seçili başlatılıyor

  // Önerilen kullanıcı verileri
  final List<Map<String, String>> recommendedUsers = [
    {
      "name": "Ali",
      "text": "ile %87 uyumlusun.\nİkiniz de aynı filmi izlediniz.",
    },
    {
      "name": "Ayşe",
      "text": "ile %92 uyumlusun.\nBenzer film türlerini beğeniyorsunuz.",
    },
    {
      "name": "Mehmet",
      "text": "ile %74 uyumlusun.\nSon izlenen filmleriniz benzer.",
    },
    {
      "name": "İlayda",
      "text": "ile %81 uyumlusun.\nAynı favori yönetmeni takip ediyorsunuz.",
    },
    {
      "name": "Emre",
      "text": "ile %69 uyumlusun.\nListelerinizde ortak filmler var.",
    },
  ];

  Future<List<dynamic>> fetchMovies(String type) async {
    final String url =
        "https://api.themoviedb.org/3/movie/$type?api_key=$apiKey&language=tr-TR";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception("Veri alınamadı");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: (index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const filmler.FilmlerScreen(),
                  ),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const elestiriler.ElestirilerScreen(),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const listeler.ListelerScreen(),
                  ),
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const arama.AramaScreen(),
                  ),
                );
              }
            },
            tabs: const [
              Tab(text: "Filmler"),
              Tab(
                child: Text(
                  "Eleştiriler",
                  style: TextStyle(letterSpacing: -0.5),
                ),
              ),
              Tab(text: "Listeler"),
              Tab(text: "Arama"),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildRoundedButton(
                    title: "Bildirimler",
                    index: 0,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BildirimlerScreen(),
                        ),
                      );
                    },
                  ),
                  _buildRoundedButton(
                    title: "Önerilenler",
                    index: 1,
                    onTap: () {
                      setState(() {
                        _selectedButtonIndex = 1;
                      });
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.grey, thickness: 1),
              const SizedBox(height: 10),
              // Önerilen kullanıcı listesi
              Expanded(
                child: ListView.separated(
                  itemCount: recommendedUsers.length,
                  separatorBuilder:
                      (context, index) => const Divider(color: Colors.grey),
                  itemBuilder: (context, index) {
                    final user = recommendedUsers[index];
                    return ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${user["name"]} ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: user["text"],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
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
      ),
    );
  }

  Widget _buildRoundedButton({
    required String title,
    required VoidCallback onTap,
    required int index,
  }) {
    bool isSelected = _selectedButtonIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedButtonIndex = index;
          });
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
