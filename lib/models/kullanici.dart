class Kullanici {
  final int id;
  final String isim;
  final String email;
  final String kullaniciAdi;
  final String sifre;

  Kullanici({
    required this.id,
    required this.isim,
    required this.email,
    required this.kullaniciAdi,
    required this.sifre,
  });

  factory Kullanici.fromJson(Map<String, dynamic> json) {
    return Kullanici(
      id: json['ID'],
      isim: json['Isim'],
      email: json['Email'],
      kullaniciAdi: json['KullaniciAdi'],
      sifre: json['Sifre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Isim': isim,
      'Email': email,
      'KullaniciAdi': kullaniciAdi,
      'Sifre': sifre,
    };
  }
}
