import 'package:flutter/material.dart';

class Car {
  final int id;
  final String nama;
  final String namaSeo;
  final int hargaSewa;
  final int hargaSopir;
  final int durasi;
  final String termasuk;
  final String mesin;
  final String tahun;
  final String kapasitas;
  final int stok;
  final String keterangan;
  final String gambarUtama;
  final bool aktif;
  final int hits;
  final String category;
  final double rating;
  final String transmisi;
  final List<String> detailImages;

  Car({
    required this.id,
    required this.nama,
    required this.namaSeo,
    required this.hargaSewa,
    required this.hargaSopir,
    required this.durasi,
    required this.termasuk,
    required this.mesin,
    required this.tahun,
    required this.kapasitas,
    required this.stok,
    required this.keterangan,
    required this.gambarUtama,
    this.aktif = true,
    this.hits = 0,
    required this.category,
    this.rating = 4.8,
    this.transmisi = 'Otomatis',
    this.detailImages = const [],
  });

  Car copyWith({
    int? id,
    String? nama,
    String? namaSeo,
    int? hargaSewa,
    int? hargaSopir,
    int? durasi,
    String? termasuk,
    String? mesin,
    String? tahun,
    String? kapasitas,
    int? stok,
    String? keterangan,
    String? gambarUtama,
    bool? aktif,
    int? hits,
    String? category,
    double? rating,
    String? transmisi,
    List<String>? detailImages,
  }) {
    return Car(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      namaSeo: namaSeo ?? this.namaSeo,
      hargaSewa: hargaSewa ?? this.hargaSewa,
      hargaSopir: hargaSopir ?? this.hargaSopir,
      durasi: durasi ?? this.durasi,
      termasuk: termasuk ?? this.termasuk,
      mesin: mesin ?? this.mesin,
      tahun: tahun ?? this.tahun,
      kapasitas: kapasitas ?? this.kapasitas,
      stok: stok ?? this.stok,
      keterangan: keterangan ?? this.keterangan,
      gambarUtama: gambarUtama ?? this.gambarUtama,
      aktif: aktif ?? this.aktif,
      hits: hits ?? this.hits,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      transmisi: transmisi ?? this.transmisi,
      detailImages: detailImages ?? this.detailImages,
    );
  }
}

class CarCategory {
  static const String all = 'Semua';
  static const String keluarga = 'Mobil Keluarga (7 Kursi)';
  static const String eksekutif = 'Eksekutif & Nyaman';
  static const String tangguh = 'Tangguh Segala Medan';
  static const String rombongan = 'Rombongan (12-19 Kursi)';
  static const String mewah = 'Mewah & VIP';
  static const String hemat = 'Hemat & Lincah (5 Kursi)';

  static const List<String> list = [
    keluarga,
    eksekutif,
    tangguh,
    rombongan,
    mewah,
    hemat,
  ];

  static const List<String> filterList = [
    all,
    keluarga,
    eksekutif,
    tangguh,
    rombongan,
    mewah,
    hemat,
  ];

  /// Normalisasi nama kategori lama atau teknis ke format yang mudah dipahami
  static String normalize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return keluarga;
    final r = raw.toLowerCase().trim();
    if (r == all.toLowerCase()) return all;
    if (r.contains('mpv keluarga') || r == 'mpv' || (r.contains('keluarga') && !r.contains('medium'))) {
      return keluarga;
    }
    if (r.contains('medium mpv') || r.contains('innova') || r.contains('eksekutif')) {
      return eksekutif;
    }
    if (r.contains('suv') || r.contains('tangguh') || r.contains('medan')) {
      return tangguh;
    }
    if (r.contains('minibus') || r.contains('elf') || r.contains('hiace') || r.contains('rombongan')) {
      return rombongan;
    }
    if (r.contains('luxury') || r.contains('vip') || r.contains('mewah') || r.contains('alphard')) {
      return mewah;
    }
    if (r.contains('city') || r.contains('hemat') || r.contains('brio') || r.contains('lincah')) {
      return hemat;
    }
    return raw;
  }

  static IconData getCategoryIcon(String category) {
    final cat = normalize(category);
    if (cat == keluarga) return Icons.groups_rounded;
    if (cat == eksekutif) return Icons.airline_seat_recline_extra_rounded;
    if (cat == tangguh) return Icons.terrain_rounded;
    if (cat == rombongan) return Icons.directions_bus_rounded;
    if (cat == mewah) return Icons.workspace_premium_rounded;
    if (cat == hemat) return Icons.electric_car_rounded;
    return Icons.directions_car_rounded;
  }
}
