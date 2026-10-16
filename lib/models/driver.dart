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
  final String noHp;

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
    this.noHp = '0812-6777-1344',
  });
}
