class Driver {
  final int id;
  final String nama;
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;
  final String alamat;
  final String keterangan;
  final String foto;
  final double rating;
  final int totalPerjalanan;
  final bool tersedia;
  final String statusKetersediaan; // 'Tersedia' | 'Dalam Perjalanan' | 'Istirahat'
  final String noHp;
  final String noSim;
  final String? userId; // Link ke User ID akun login
  final bool isAktif;

  Driver({
    required this.id,
    required this.nama,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
    required this.keterangan,
    required this.foto,
    this.rating = 4.9,
    this.totalPerjalanan = 124,
    this.tersedia = true,
    this.statusKetersediaan = 'Tersedia',
    this.noHp = '0812-6777-1344',
    this.noSim = 'SIM A & B1 Umum',
    this.userId,
    this.isAktif = true,
  });

  Driver copyWith({
    int? id,
    String? nama,
    String? jenisKelamin,
    String? tempatLahir,
    String? tanggalLahir,
    String? alamat,
    String? keterangan,
    String? foto,
    double? rating,
    int? totalPerjalanan,
    bool? tersedia,
    String? statusKetersediaan,
    String? noHp,
    String? noSim,
    String? userId,
    bool? isAktif,
  }) {
    return Driver(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      alamat: alamat ?? this.alamat,
      keterangan: keterangan ?? this.keterangan,
      foto: foto ?? this.foto,
      rating: rating ?? this.rating,
      totalPerjalanan: totalPerjalanan ?? this.totalPerjalanan,
      tersedia: tersedia ?? this.tersedia,
      statusKetersediaan: statusKetersediaan ?? this.statusKetersediaan,
      noHp: noHp ?? this.noHp,
      noSim: noSim ?? this.noSim,
      userId: userId ?? this.userId,
      isAktif: isAktif ?? this.isAktif,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jenisKelamin': jenisKelamin,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir,
      'alamat': alamat,
      'keterangan': keterangan,
      'foto': foto,
      'rating': rating,
      'totalPerjalanan': totalPerjalanan,
      'tersedia': tersedia,
      'statusKetersediaan': statusKetersediaan,
      'noHp': noHp,
      'noSim': noSim,
      'userId': userId,
      'isAktif': isAktif,
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nama: json['nama'] ?? '',
      jenisKelamin: json['jenisKelamin'] ?? 'Laki-laki',
      tempatLahir: json['tempatLahir'] ?? '',
      tanggalLahir: json['tanggalLahir'] ?? '',
      alamat: json['alamat'] ?? '',
      keterangan: json['keterangan'] ?? '',
      foto: json['foto'] ?? '',
      rating: (json['rating'] != null) ? double.parse(json['rating'].toString()) : 4.9,
      totalPerjalanan: json['totalPerjalanan'] != null ? int.parse(json['totalPerjalanan'].toString()) : 0,
      tersedia: json['tersedia'] == true || json['tersedia'] == 1 || json['tersedia'] == '1',
      statusKetersediaan: json['statusKetersediaan'] ?? 'Tersedia',
      noHp: json['noHp'] ?? '0812-6777-1344',
      noSim: json['noSim'] ?? 'SIM A & B1 Umum',
      userId: json['userId']?.toString(),
      isAktif: json['isAktif'] == null || json['isAktif'] == true || json['isAktif'] == 1,
    );
  }
}
