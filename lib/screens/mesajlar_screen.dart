import 'dart:convert';
import 'package:cinescope/screens/bildirimler_screen.dart';
import 'package:cinescope/screens/hesap_screen.dart';
import 'package:cinescope/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cinescope/screens/elestiriler_screen.dart' as elestiriler;
import 'package:cinescope/screens/listeler_screen.dart' as listeler;
import 'package:cinescope/screens/arama_screen.dart' as arama;
import 'package:cinescope/screens/filmler_screen.dart' as filmler;

class MesajlarScreen extends StatefulWidget {
  const MesajlarScreen({super.key});

  @override
  State<MesajlarScreen> createState() => _MesajlarScreenState();
}

class _MesajlarScreenState extends State<MesajlarScreen> {
  static const apiKey = "02f7a3e84e6acce9ce0b5583deffb717";
  int _selectedIndex = 1;

  // aktif sohbet edilen kullanıcı
  String? selectedUser;

  // Örnek kullanıcı listesi
  final List<Map<String, String>> users = [
    {"name": "Ahmet", "profile": "https://i.pravatar.cc/150?img=1"},
    {"name": "Sedef", "profile": "https://i.pravatar.cc/150?img=2"},
    {"name": "Elif", "profile": "https://i.pravatar.cc/150?img=3"},
    {"name": "Murat", "profile": "https://i.pravatar.cc/150?img=4"},
    {"name": "Zeynep", "profile": "https://i.pravatar.cc/150?img=5"},
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

        // 🟢 GÖVDE (KULLANICI LİSTESİ veya MESAJ EKRANI)
        body:
            selectedUser == null
                ? ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedUser = user["name"];
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                              Text(
                                user["name"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 15,
                            endIndent: 15,
                          ),
                        ],
                      ),
                    );
                  },
                )
                : ChatScreen(
                  username: selectedUser!,
                  onBack: () {
                    setState(() {
                      selectedUser = null;
                    });
                  },
                ),

        // 🔻 ALT NAVBAR
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
}

//
// 🟡 MESAJ EKRANI (Artık aynı sayfada sekmelerle birlikte çalışıyor)
//
class ChatScreen extends StatefulWidget {
  final String username;
  final VoidCallback onBack;
  const ChatScreen({super.key, required this.username, required this.onBack});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {"sender": "me", "text": "Merhaba!"},
    {"sender": "other", "text": "Selam, nasılsın?"},
  ];
  final TextEditingController _controller = TextEditingController();

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({"sender": "me", "text": _controller.text.trim()});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Üst bar (geri butonu + kullanıcı adı)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: const Color(0xFF333333),
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
              const SizedBox(width: 10),
              Text(
                widget.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // 🔹 Mesaj listesi
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg["sender"] == "me";
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blueAccent : Colors.grey[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    msg["text"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ),

        // 🔹 Mesaj yazma alanı
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          color: const Color(0xFF262626),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Mesaj yaz...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
