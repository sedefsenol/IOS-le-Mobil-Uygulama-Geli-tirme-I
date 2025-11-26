import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DenemeScreen extends StatefulWidget {
  const DenemeScreen({super.key});

  @override
  State<DenemeScreen> createState() => _DenemeScreenState();
}

class _DenemeScreenState extends State<DenemeScreen> {
  final TextEditingController _kullaniciController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  String _mesaj = '';
  bool _loading = false;

  Future<void> login() async {
    if (_kullaniciController.text.isEmpty || _sifreController.text.isEmpty) {
      setState(() {
        _mesaj = 'Lütfen tüm alanları doldurun.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _mesaj = '';
    });

    try {
      final url = Uri.parse('https://localhost:5001/api/Kullanicilar/Login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'KullaniciAdi': _kullaniciController.text,
          'Sifre': _sifreController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _mesaj = 'Giriş başarılı!';
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _mesaj = 'Kullanıcı adı veya şifre hatalı';
        });
      } else {
        setState(() {
          _mesaj = 'Sunucu hatası: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _mesaj = 'Bağlantı hatası: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CineScope Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _kullaniciController,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _sifreController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: login,
                    child: const Text('Giriş Yap'),
                  ),
              const SizedBox(height: 20),
              Text(
                _mesaj,
                style: TextStyle(
                  color:
                      _mesaj == 'Giriş başarılı!' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
