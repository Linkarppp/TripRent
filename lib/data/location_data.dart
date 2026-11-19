import 'package:flutter/material.dart';

enum LocationType {
  airport,
  station,
  city,
  hotel,
  tour,
  general,
}

class LocationItem {
  final String title;
  final String subtitle;
  final LocationType type;
  final List<String> tags;

  const LocationItem({
    required this.title,
    required this.subtitle,
    this.type = LocationType.general,
    this.tags = const [],
  });

  IconData get icon {
    switch (type) {
      case LocationType.airport:
        return Icons.local_airport_rounded;
      case LocationType.station:
        return Icons.train_rounded;
      case LocationType.hotel:
        return Icons.hotel_rounded;
      case LocationType.tour:
        return Icons.nature_people_rounded;
      case LocationType.city:
        return Icons.location_city_rounded;
      case LocationType.general:
        return Icons.place_rounded;
    }
  }

  String get typeLabel {
    switch (type) {
      case LocationType.airport:
        return 'Bandara';
      case LocationType.station:
        return 'Stasiun';
      case LocationType.hotel:
        return 'Hotel';
      case LocationType.tour:
        return 'Wisata';
      case LocationType.city:
        return 'Kota/Wilayah';
      case LocationType.general:
        return 'Lokasi';
    }
  }
}

class LocationData {
  static const List<LocationItem> locations = [
    // --- INDRAMAYU & SEKITARNYA (JAWA BARAT) ---
    LocationItem(
      title: 'Indramayu Kota',
      subtitle: 'Kabupaten Indramayu, Jawa Barat',
      type: LocationType.city,
      tags: ['indramayu', 'jawa barat', 'pantura', 'alun-alun indramayu'],
    ),
    LocationItem(
      title: 'Stasiun Jatibarang (Indramayu)',
      subtitle: 'Kec. Jatibarang, Kabupaten Indramayu, Jawa Barat',
      type: LocationType.station,
      tags: ['indramayu', 'jatibarang', 'stasiun', 'kereta'],
    ),
    LocationItem(
      title: 'Karangampel, Indramayu',
      subtitle: 'Jalur Pantura Cirebon-Indramayu, Jawa Barat',
      type: LocationType.city,
      tags: ['indramayu', 'karangampel', 'pantura'],
    ),
    LocationItem(
      title: 'Haurgeulis, Indramayu',
      subtitle: 'Stasiun & Pusat Kota Haurgeulis, Kab. Indramayu',
      type: LocationType.station,
      tags: ['indramayu', 'haurgeulis', 'stasiun'],
    ),
    LocationItem(
      title: 'Pantai Balongan & Pertamina Indramayu',
      subtitle: 'Balongan, Kabupaten Indramayu, Jawa Barat',
      type: LocationType.tour,
      tags: ['indramayu', 'balongan', 'pantai', 'pertamina'],
    ),
    LocationItem(
      title: 'Kota Cirebon (Pusat Kota)',
      subtitle: 'Kejaksaan / Harjamukti, Cirebon, Jawa Barat',
      type: LocationType.city,
      tags: ['cirebon', 'jawa barat', 'pantura'],
    ),
    LocationItem(
      title: 'Stasiun Cirebon (Kejaksaan)',
      subtitle: 'Jl. Siliwangi, Kebonbaru, Kejaksan, Kota Cirebon',
      type: LocationType.station,
      tags: ['cirebon', 'stasiun cirebon', 'kejaksaan'],
    ),
    LocationItem(
      title: 'Stasiun Cirebon Prujakan',
      subtitle: 'Jl. Nyi Mas Gandasari, Pekalangan, Kota Cirebon',
      type: LocationType.station,
      tags: ['cirebon', 'prujakan', 'stasiun'],
    ),
    LocationItem(
      title: 'Bandara Internasional Kertajati (KJT)',
      subtitle: 'Kertajati, Kabupaten Majalengka, Jawa Barat',
      type: LocationType.airport,
      tags: ['kertajati', 'kjt', 'majalengka', 'cirebon', 'indramayu', 'bandara'],
    ),

    // --- PADANG & SUMATERA BARAT ---
    LocationItem(
      title: 'Bandara Internasional Minangkabau (BIM)',
      subtitle: 'Ketaping, Batang Anai, Kab. Padang Pariaman, Sumbar',
      type: LocationType.airport,
      tags: ['bim', 'bandara', 'airport', 'minangkabau', 'padang'],
    ),
    LocationItem(
      title: 'Pusat Kota Padang & Wisata Pantai',
      subtitle: 'Kec. Padang Barat, Kota Padang, Sumatera Barat',
      type: LocationType.city,
      tags: ['padang', 'kota padang', 'pantai padang', 'taplau', 'pusat kota'],
    ),
    LocationItem(
      title: 'Pool TripRent Pusat (Tunggul Hitam)',
      subtitle: 'Jl. Raya Tunggul Hitam No. 45, Koto Tangah, Kota Padang',
      type: LocationType.city,
      tags: ['pool', 'triprent', 'tunggul hitam', 'padang'],
    ),
    LocationItem(
      title: 'Stasiun Padang (Simpang Haru)',
      subtitle: 'Sawahan Timur, Padang Timur, Kota Padang',
      type: LocationType.station,
      tags: ['stasiun', 'padang', 'simpang haru', 'kereta bandara'],
    ),
    LocationItem(
      title: 'Hotel Grand Zuri Padang',
      subtitle: 'Jl. M. Thamrin No. 27, Alang Laweh, Kota Padang',
      type: LocationType.hotel,
      tags: ['hotel', 'grand zuri', 'padang'],
    ),
    LocationItem(
      title: 'Hotel Ibis Padang',
      subtitle: 'Jl. Tamansiswa No. 1A, Alai Parak Kopi, Padang',
      type: LocationType.hotel,
      tags: ['hotel', 'ibis', 'padang'],
    ),
    LocationItem(
      title: 'Hotel Mercure Padang',
      subtitle: 'Jl. Purus IV No. 8, Purus, Padang Barat, Kota Padang',
      type: LocationType.hotel,
      tags: ['hotel', 'mercure', 'padang', 'purus'],
    ),
    LocationItem(
      title: 'Hotel The Axana Padang',
      subtitle: 'Jl. Bundo Kanduang No. 14-16, Kampung Pondok, Padang',
      type: LocationType.hotel,
      tags: ['hotel', 'axana', 'padang'],
    ),
    LocationItem(
      title: 'Hotel Santika Premiere Padang',
      subtitle: 'Jl. Jend. A. Yani No. 20, Olo, Padang Barat',
      type: LocationType.hotel,
      tags: ['hotel', 'santika', 'padang'],
    ),
    LocationItem(
      title: 'Pelabuhan Teluk Bayur (Padang)',
      subtitle: 'Teluk Bayur, Padang Selatan, Kota Padang',
      type: LocationType.general,
      tags: ['pelabuhan', 'teluk bayur', 'padang'],
    ),
    LocationItem(
      title: 'Pelabuhan Muaro Padang (Penyeberangan Mentawai)',
      subtitle: 'Batang Arau, Padang Selatan, Kota Padang',
      type: LocationType.general,
      tags: ['muaro', 'mentawai', 'pelabuhan', 'padang'],
    ),
    LocationItem(
      title: 'Bukittinggi (Jam Gadang & Pasar Atas)',
      subtitle: 'Kec. Guguk Panjang, Kota Bukittinggi, Sumatera Barat',
      type: LocationType.city,
      tags: ['bukittinggi', 'jam gadang', 'pasar atas', 'ngarai sianok'],
    ),
    LocationItem(
      title: 'Payakumbuh & Lembah Harau',
      subtitle: 'Kab. Lima Puluh Kota & Kota Payakumbuh, Sumbar',
      type: LocationType.tour,
      tags: ['payakumbuh', 'harau', 'lembah harau', 'kelok 9'],
    ),
    LocationItem(
      title: 'Kelok Sembilan (Flyover Kelok 9)',
      subtitle: 'Sarilamak, Harau, Kabupaten Lima Puluh Kota',
      type: LocationType.tour,
      tags: ['kelok 9', 'kelok sembilan', 'payakumbuh', 'wisata'],
    ),
    LocationItem(
      title: 'Kota Solok & Danau Singkarak',
      subtitle: 'Kota Solok & Dermaga Singkarak, Sumatera Barat',
      type: LocationType.tour,
      tags: ['solok', 'singkarak', 'danau singkarak'],
    ),
    LocationItem(
      title: 'Kawasan Wisata Mandeh (Carocok Anau)',
      subtitle: 'Koto XI Tarusan, Kabupaten Pesisir Selatan, Sumbar',
      type: LocationType.tour,
      tags: ['mandeh', 'tarusan', 'pesisir selatan', 'wisata bahari'],
    ),
    LocationItem(
      title: 'Pantai Carocok Painan',
      subtitle: 'Painan, Kabupaten Pesisir Selatan, Sumatera Barat',
      type: LocationType.tour,
      tags: ['carocok', 'painan', 'pesisir selatan'],
    ),
    LocationItem(
      title: 'Kota Pariaman (Pantai Gandoriah)',
      subtitle: 'Pariaman Tengah, Kota Pariaman, Sumatera Barat',
      type: LocationType.city,
      tags: ['pariaman', 'gandoriah', 'pantai kata'],
    ),
    LocationItem(
      title: 'Padang Panjang (Pusat Kuliner Sate & Mifan)',
      subtitle: 'Silaing Bawah, Kota Padang Panjang, Sumbar',
      type: LocationType.city,
      tags: ['padang panjang', 'silaing', 'mifan'],
    ),
    LocationItem(
      title: 'Batusangkar & Istano Basa Pagaruyung',
      subtitle: 'Pagaruyung, Tanjung Emas, Kab. Tanah Datar',
      type: LocationType.tour,
      tags: ['batusangkar', 'pagaruyung', 'tanah datar'],
    ),
    LocationItem(
      title: 'Danau Maninjau & Kelok 44',
      subtitle: 'Tanjung Raya, Kabupaten Agam, Sumatera Barat',
      type: LocationType.tour,
      tags: ['maninjau', 'danau maninjau', 'kelok 44', 'agam'],
    ),
    LocationItem(
      title: 'Alahan Panjang & Kebun Teh Danau Diatas',
      subtitle: 'Lembah Gumanti, Kabupaten Solok, Sumatera Barat',
      type: LocationType.tour,
      tags: ['alahan panjang', 'danau kembar', 'kebun teh', 'solok'],
    ),
    LocationItem(
      title: 'Kota Sawahlunto (Kota Tua Warisan Tambang)',
      subtitle: 'Lembah Segar, Kota Sawahlunto, Sumatera Barat',
      type: LocationType.city,
      tags: ['sawahlunto', 'omblin', 'kota tua'],
    ),
    LocationItem(
      title: 'Lubuk Basung (Ibukota Kab. Agam)',
      subtitle: 'Kabupaten Agam, Sumatera Barat',
      type: LocationType.city,
      tags: ['lubuk basung', 'agam'],
    ),
    LocationItem(
      title: 'Simpang Empat (Pasaman Barat)',
      subtitle: 'Pasaman Barat, Sumatera Barat',
      type: LocationType.city,
      tags: ['pasaman', 'pasaman barat', 'simpang empat'],
    ),
    LocationItem(
      title: 'Lubuk Sikaping (Pasaman)',
      subtitle: 'Kabupaten Pasaman, Sumatera Barat',
      type: LocationType.city,
      tags: ['pasaman', 'lubuk sikaping'],
    ),
    LocationItem(
      title: 'Pulau Punjung (Dharmasraya)',
      subtitle: 'Kabupaten Dharmasraya, Sumatera Barat',
      type: LocationType.city,
      tags: ['dharmasraya', 'pulau punjung', 'lintas sumatera'],
    ),
    LocationItem(
      title: 'Muaro Sijunjung',
      subtitle: 'Kabupaten Sijunjung, Sumatera Barat',
      type: LocationType.city,
      tags: ['sijunjung', 'muaro sijunjung'],
    ),

    // --- RIAU & PEKANBARU ---
    LocationItem(
      title: 'Kota Pekanbaru (Pusat Kota)',
      subtitle: 'Sukajadi / Senapelan, Kota Pekanbaru, Riau',
      type: LocationType.city,
      tags: ['pekanbaru', 'riau', 'pusat kota'],
    ),
    LocationItem(
      title: 'Bandara Sultan Syarif Kasim II (PKU)',
      subtitle: 'Simpang Tiga, Bukit Raya, Kota Pekanbaru, Riau',
      type: LocationType.airport,
      tags: ['pekanbaru', 'pku', 'bandara', 'syarif kasim'],
    ),
    LocationItem(
      title: 'Terminal AKAP Bandar Raya Payung Sekaki',
      subtitle: 'Payung Sekaki, Kota Pekanbaru, Riau',
      type: LocationType.station,
      tags: ['pekanbaru', 'terminal akap', 'payung sekaki'],
    ),
    LocationItem(
      title: 'Bangkinang (Kabupaten Kampar)',
      subtitle: 'Kampar, Riau (Pintu Tol Pekanbaru-Bangkinang)',
      type: LocationType.city,
      tags: ['kampar', 'bangkinang', 'tol bangkinang'],
    ),
    LocationItem(
      title: 'Kota Dumai (Pelabuhan Internasional)',
      subtitle: 'Kota Dumai, Provinsi Riau',
      type: LocationType.city,
      tags: ['dumai', 'pelabuhan dumai', 'riau'],
    ),

    // --- JABODETABEK ---
    LocationItem(
      title: 'Bandara Internasional Soekarno-Hatta (CGK)',
      subtitle: 'Cengkareng, Kota Tangerang, Banten / Jabodetabek',
      type: LocationType.airport,
      tags: ['jakarta', 'cgk', 'soekarno hatta', 'cengkareng', 'bandara'],
    ),
    LocationItem(
      title: 'Bandara Halim Perdanakusuma (HLP)',
      subtitle: 'Makasar, Kota Jakarta Timur, DKI Jakarta',
      type: LocationType.airport,
      tags: ['jakarta', 'halim', 'hlp', 'bandara halim'],
    ),
    LocationItem(
      title: 'Jakarta Pusat (Monas, Thamrin, Sudirman)',
      subtitle: 'DKI Jakarta',
      type: LocationType.city,
      tags: ['jakarta', 'jakarta pusat', 'monas', 'sudirman', 'thamrin'],
    ),
    LocationItem(
      title: 'Jakarta Selatan (Senayan, Blok M, TB Simatupang)',
      subtitle: 'DKI Jakarta',
      type: LocationType.city,
      tags: ['jakarta', 'jakarta selatan', 'senayan', 'blok m'],
    ),
    LocationItem(
      title: 'Stasiun Gambir (Jakarta Pusat)',
      subtitle: 'Gambir, Kota Jakarta Pusat, DKI Jakarta',
      type: LocationType.station,
      tags: ['jakarta', 'gambir', 'stasiun gambir'],
    ),
    LocationItem(
      title: 'Stasiun Pasar Senen (Jakarta Pusat)',
      subtitle: 'Senen, Kota Jakarta Pusat, DKI Jakarta',
      type: LocationType.station,
      tags: ['jakarta', 'pasar senen', 'senen', 'stasiun senen'],
    ),
    LocationItem(
      title: 'Kota Bandung (Pusat Kota & Gedung Sate)',
      subtitle: 'Bandung Wetan, Kota Bandung, Jawa Barat',
      type: LocationType.city,
      tags: ['bandung', 'jawa barat', 'gedung sate', 'dago'],
    ),
    LocationItem(
      title: 'Stasiun Bandung (Hall)',
      subtitle: 'Kebon Kawung, Kota Bandung, Jawa Barat',
      type: LocationType.station,
      tags: ['bandung', 'stasiun bandung', 'stasiun hall'],
    ),
    LocationItem(
      title: 'Kota Bekasi & Summarecon',
      subtitle: 'Bekasi Barat, Kota Bekasi, Jawa Barat',
      type: LocationType.city,
      tags: ['bekasi', 'summarecon bekasi'],
    ),
    LocationItem(
      title: 'Kota Depok (Margonda)',
      subtitle: 'Kec. Beji, Kota Depok, Jawa Barat',
      type: LocationType.city,
      tags: ['depok', 'margonda'],
    ),
    LocationItem(
      title: 'Kota Bogor (Kebun Raya Bogor)',
      subtitle: 'Bogor Tengah, Kota Bogor, Jawa Barat',
      type: LocationType.city,
      tags: ['bogor', 'kebun raya'],
    ),
    LocationItem(
      title: 'Tangerang Selatan (BSD City & Alam Sutera)',
      subtitle: 'Serpong, Kota Tangerang Selatan, Banten',
      type: LocationType.city,
      tags: ['tangerang', 'bsd', 'serpong', 'alam sutera'],
    ),

    // --- KOTA BESAR LAINNYA DI JAWA & SUMATERA ---
    LocationItem(
      title: 'Kota Semarang (Simpang Lima)',
      subtitle: 'Semarang Tengah, Kota Semarang, Jawa Tengah',
      type: LocationType.city,
      tags: ['semarang', 'simpang lima', 'jawa tengah'],
    ),
    LocationItem(
      title: 'Yogyakarta (Malioboro & Tugu Jogja)',
      subtitle: 'Danurejan / Gedongtengen, Kota Yogyakarta, DIY',
      type: LocationType.city,
      tags: ['jogja', 'yogyakarta', 'malioboro', 'tugu'],
    ),
    LocationItem(
      title: 'Kota Solo / Surakarta',
      subtitle: 'Banjarsari, Kota Surakarta, Jawa Tengah',
      type: LocationType.city,
      tags: ['solo', 'surakarta', 'jawa tengah'],
    ),
    LocationItem(
      title: 'Kota Surabaya (Tunjungan Plaza & Gubeng)',
      subtitle: 'Genteng, Kota Surabaya, Jawa Timur',
      type: LocationType.city,
      tags: ['surabaya', 'jawa timur', 'tunjungan'],
    ),
    LocationItem(
      title: 'Kota Malang & Wisata Batu',
      subtitle: 'Klojen / Batu, Jawa Timur',
      type: LocationType.city,
      tags: ['malang', 'batu', 'jawa timur'],
    ),
    LocationItem(
      title: 'Kota Medan (Istana Maimun & Kesawan)',
      subtitle: 'Medan Kota, Kota Medan, Sumatera Utara',
      type: LocationType.city,
      tags: ['medan', 'sumatera utara'],
    ),
    LocationItem(
      title: 'Bandara Internasional Kualanamu (KNO)',
      subtitle: 'Beringin, Deli Serdang, Sumatera Utara',
      type: LocationType.airport,
      tags: ['kualanamu', 'kno', 'medan', 'bandara'],
    ),
    LocationItem(
      title: 'Kota Palembang (Jembatan Ampera)',
      subtitle: 'Ilir Timur, Kota Palembang, Sumatera Selatan',
      type: LocationType.city,
      tags: ['palembang', 'ampera', 'sumatera selatan'],
    ),
    LocationItem(
      title: 'Bandar Lampung (Pusat Kota)',
      subtitle: 'Tanjung Karang, Kota Bandar Lampung, Lampung',
      type: LocationType.city,
      tags: ['lampung', 'bandar lampung'],
    ),
    LocationItem(
      title: 'Kota Jambi (Telanaipura)',
      subtitle: 'Kec. Telanaipura, Kota Jambi, Provinsi Jambi',
      type: LocationType.city,
      tags: ['jambi', 'kota jambi'],
    ),
    LocationItem(
      title: 'Kota Bengkulu (Pantai Panjang)',
      subtitle: 'Ratu Samban, Kota Bengkulu, Bengkulu',
      type: LocationType.city,
      tags: ['bengkulu', 'pantai panjang'],
    ),
  ];

  /// Filter locations matching a query string
  static List<LocationItem> search(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return locations.take(6).toList();
    }

    // Exact or prefix matches first, then contains
    final directMatches = <LocationItem>[];
    final otherMatches = <LocationItem>[];

    for (final loc in locations) {
      final titleLower = loc.title.toLowerCase();
      final subtitleLower = loc.subtitle.toLowerCase();
      final tagMatch = loc.tags.any((t) => t.toLowerCase().contains(cleanQuery));

      if (titleLower.startsWith(cleanQuery)) {
        directMatches.add(loc);
      } else if (titleLower.contains(cleanQuery) ||
          subtitleLower.contains(cleanQuery) ||
          tagMatch) {
        otherMatches.add(loc);
      }
    }

    return [...directMatches, ...otherMatches].take(8).toList();
  }
}
