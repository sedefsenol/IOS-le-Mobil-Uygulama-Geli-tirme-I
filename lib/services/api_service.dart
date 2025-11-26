import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kullanici.dart';

class ApiService {
  final String baseUrl = 'https://localhost:5001/api';

  Future<List<Kullanici>> getTumKullanicilar() async {
    final response = await http.get(Uri.parse('$baseUrl/Kullanici'));
    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((json) => Kullanici.fromJson(json)).toList();
    } else {
      throw Exception('Kullanıcılar alınamadı');
    }
  }

  Future<Kullanici?> login(String kullaniciAdi, String sifre) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Kullanici'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'KullaniciAdi': kullaniciAdi, 'Sifre': sifre}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Kullanici.fromJson(data);
    } else {
      return null;
    }
  }
}
