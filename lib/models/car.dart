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
