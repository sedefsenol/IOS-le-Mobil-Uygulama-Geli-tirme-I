import 'dart:convert';
import 'package:cinescope/screens/ayarlar_screen.dart';
import 'package:cinescope/screens/bildirimler_screen.dart';
import 'package:cinescope/screens/home_screen.dart';
import 'package:cinescope/screens/mesajlar_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cinescope/screens/listeler_screen.dart' as listeler;
import 'package:cinescope/screens/arama_screen.dart' as arama;
import 'package:cinescope/screens/filmler_screen.dart' as filmler;
import 'package:cinescope/screens/elestiriler_screen.dart' as elestiriler;

class HesapScreen extends StatefulWidget {
  const HesapScreen({super.key});

  @override
  State<HesapScreen> createState() => _HesapScreenState();
}

class _HesapScreenState extends State<HesapScreen> {
  static const apiKey = "02f7a3e84e6acce9ce0b5583deffb717";
  int _selectedIndex = 3;

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
    const Color darkGreyBackground = Color(0xFF444444);
    const Color darkerGrey = Color(0xFF262626);
    const Color textWhite = Colors.white;
    const Color lightGreyText = Color(0xFFAAAAAA);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: darkGreyBackground,
        appBar: AppBar(
          backgroundColor: darkerGrey,
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
                  "Elestiriler",
                  style: TextStyle(letterSpacing: -0.5),
                ),
              ),
              Tab(text: "Listeler"),
              Tab(text: "Arama"),
            ],
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _showProfilePhotoModal();
                      },
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFF6C7A89),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF262626),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sedefco",
                            style: TextStyle(
                              color: textWhite,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Flexible(
                                child: Text(
                                  "150 Takipçi",
                                  style: TextStyle(
                                    color: lightGreyText,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  "200 Takip",
                                  style: TextStyle(
                                    color: lightGreyText,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AyarlarlarScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: lightGreyText, thickness: 0.5),

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Hakkımda",
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                color: darkerGrey,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  "Film eleştirilerimi paylaşmak ve yeni yapımları keşfetmek için buradayım.",
                  style: TextStyle(color: textWhite, fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Eleştiriler",
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(color: lightGreyText, thickness: 0.5),

              _elestiriItem("Avatar: The Way of Water", "Keyifliydi"),
              _elestiriItem("Oppenheimer", "Muhteşem!"),
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

  void _showProfilePhotoModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 100,
                backgroundColor: Color(0xFF6C7A89),
                child: Icon(Icons.person, size: 120, color: Color(0xFF262626)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF262626),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Fotoğrafı Düzenle",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Fotoğrafı Kaldır",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _elestiriItem(String film, String yorum) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      leading: Container(
        width: 60,
        height: 90,
        color: const Color(0xFF1B2C3B),
        child: const Center(
          child: Text(
            "POSTER",
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ),
      title: Text(
        yorum,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      subtitle: Text(
        film,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      onTap: () {},
    );
  }
}
