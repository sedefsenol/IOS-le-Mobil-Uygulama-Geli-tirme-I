import 'dart:convert';
import 'package:cinescope/screens/bildirimler_screen.dart';
import 'package:cinescope/screens/favorilerim_screen.dart';
import 'package:cinescope/screens/hesap_screen.dart';
import 'package:cinescope/screens/home_screen.dart';
import 'package:cinescope/screens/mesajlar_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cinescope/screens/elestiriler_screen.dart' as elestiriler;
import 'package:cinescope/screens/listeler_screen.dart' as listeler;
import 'package:cinescope/screens/arama_screen.dart' as arama;
import 'package:cinescope/screens/filmler_screen.dart' as filmler;

class ListeolusturScreen extends StatefulWidget {
  const ListeolusturScreen({super.key});

  @override
  State<ListeolusturScreen> createState() => _ListeolusturScreenState();
}

class _ListeolusturScreenState extends State<ListeolusturScreen> {
  static const apiKey = "02f7a3e84e6acce9ce0b5583deffb717";
  int _selectedIndex = 0;
  int _selectedButtonIndex = 2;

  // Controllers ve state
  final TextEditingController _listeAdiController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();
  final TextEditingController _filmController = TextEditingController();
  String _gorunurluk = 'Herkese Açık';
  final List<String> _secilenFilmler = [];

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
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------
                // ÜST KUTULAR
                // ---------------------
                Row(
                  children: [
                    _buildRoundedButton(
                      title: "Listelerim",
                      index: 0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const listeler.ListelerScreen(),
                          ),
                        );
                      },
                    ),
                    _buildRoundedButton(
                      title: "Favorilerim",
                      index: 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavorilerimScreen(),
                          ),
                        );
                      },
                    ),
                    _buildRoundedButton(
                      title: "Liste Oluştur",
                      index: 2,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ---------------------
                // LİSTE OLUŞTURMA FORMU
                // ---------------------
                const Text(
                  "Liste İsmi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _listeAdiController,
                  decoration: InputDecoration(
                    hintText: "Liste adını girin",
                    filled: true,
                    fillColor: Colors.grey.shade700,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Görünürlük",
                  style: TextStyle(
                    color: Color(0xFF616161),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  initialValue: _gorunurluk,
                  items: const [
                    DropdownMenuItem(
                      value: "Herkese Açık",
                      child: Text("Herkese Açık"),
                    ),
                    DropdownMenuItem(
                      value: "Sadece Arkadaşlarım",
                      child: Text("Sadece Arkadaşlarım"),
                    ),
                    DropdownMenuItem(value: "Özel", child: Text("Özel")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _gorunurluk = value!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade700,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Açıklama",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _aciklamaController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Açıklama girin",
                    filled: true,
                    fillColor: Colors.grey.shade700,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Film Ekle",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  children: [
                    TextField(
                      controller: _filmController,
                      onChanged: (query) {
                        setState(() {
                          // Her değişiklikte arama tetiklenecek
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Film adı girin",
                        filled: true,
                        fillColor: Colors.grey.shade700,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    FutureBuilder<List<dynamic>>(
                      future:
                          _filmController.text.isEmpty
                              ? Future.value([]) // boşsa sonuç yok
                              : searchMovies(_filmController.text),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const SizedBox();
                        }
                        final results = snapshot.data!;
                        return SizedBox(
                          height: 200, // scrollable küçük kutu
                          child: ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final movie = results[index];
                              final title = movie['title'] ?? '';
                              return ListTile(
                                title: Text(
                                  title,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  if (!_secilenFilmler.contains(title)) {
                                    setState(() {
                                      _secilenFilmler.add(title);
                                      _filmController.clear();
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  "Seçilen Filmler",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _secilenFilmler.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _secilenFilmler[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _secilenFilmler.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),

                const Divider(color: Colors.grey, thickness: 1),
              ],
            ),
          ),
        ),

        // ---------------------
        // ALT MENÜ
        // ---------------------
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

  Future<List<dynamic>> searchMovies(String query) async {
    final url =
        "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query&language=tr-TR";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      return [];
    }
  }
}
