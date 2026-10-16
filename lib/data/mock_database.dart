import 'package:flutter/foundation.dart';
import '../models/car.dart';
import '../models/driver.dart';
import '../models/order.dart';
import '../models/company_profile.dart';

class TripRentStore extends ChangeNotifier {
  static final TripRentStore instance = TripRentStore._internal();
  TripRentStore._internal() {
    _initData();
  }

  factory TripRentStore() => instance;

  late List<Car> _cars;
  late List<Driver> _drivers;
  late List<RentalOrder> _orders;
  late CompanyProfile _companyProfile;

  List<Car> get cars => _cars;
  List<Driver> get drivers => _drivers;
  List<RentalOrder> get orders => _orders;
  CompanyProfile get companyProfile => _companyProfile;

  void _initData() {
    _companyProfile = CompanyProfile(
      namaWebsite: 'TripRent - Rental Mobil Online',
      email: 'robby.prihandaya@gmail.com',
      noTelp: '0812-6777-1344',
      alamat: 'Jl. Angkasa Puri, Perundam 4, Tunggul Hitam, Padang Utara, Sumatera Barat',
      metaDeskripsi: 'Rental dan sewa mobil murah sehari dan seminggu di Padang, Payakumbuh, Bukittinggi, Jakarta, Bali dengan armada terlengkap dan driver profesional.',
      bankAccounts: [
        BankAccount(
          id: 1,
          namaBank: 'BANK BCA (Bank Central Asia)',
          noRekening: '0320943647',
          pemilik: 'Robby Prihandaya',
        ),
        BankAccount(
          id: 2,
          namaBank: 'BANK BRI (Bank Rakyat Indonesia)',
          noRekening: '547601016142539',
          pemilik: 'Robby Prihandaya',
        ),
      ],
    );

    _drivers = [
      Driver(
        id: 1,
        nama: 'Robby Prihandaya',
        jenisKelamin: 'Laki-laki',
        tempatLahir: 'Padang',
        tanggalLahir: '1989-05-06',
        alamat: 'Jl. Angkasa Puri, Perundam 4, Tunggul Hitam, Padang',
        keterangan: 'Driver senior berlisensi SIM A & B1, ramah, menguasai seluruh rute wisata Sumatera Barat & Jabodetabek.',
        foto: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
        rating: 4.95,
        totalPerjalanan: 184,
        tersedia: true,
        noHp: '0812-6777-1344',
      ),
      Driver(
        id: 2,
        nama: 'Dewiit Safitri',
        jenisKelamin: 'Perempuan',
        tempatLahir: 'Payakumbuh',
        tanggalLahir: '1989-02-12',
        alamat: 'Jl. Linggar Jati 2, Perupuk Tabing, Padang',
        keterangan: 'Driver berpengalaman untuk perjalanan VIP dan keluarga, tepat waktu dan sangat teliti.',
        foto: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
        rating: 4.88,
        totalPerjalanan: 142,
        tersedia: true,
        noHp: '0852-3456-9988',
      ),
    ];

    _cars = [
      Car(
        id: 51,
        nama: 'Lamborghini Huracan',
        namaSeo: 'lamborghini-huracan',
        hargaSewa: 600000,
        hargaSopir: 250000,
        durasi: 1,
        termasuk: 'Mobil Saja',
        mesin: '10000 cc',
        tahun: '2018',
        kapasitas: '2 Orang',
        stok: 3,
        keterangan: 'Supercar performa tinggi dengan mesin bertenaga buas, interior balap eksklusif, transmisi dual-clutch, dan aerodinamika agresif.',
        gambarUtama: 'https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?auto=format&fit=crop&w=800&q=80',
        category: 'Supercar',
        rating: 5.0,
        transmisi: 'Dual-Clutch Auto',
        hits: 142,
        detailImages: [
          'https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 52,
        nama: 'Lykan Hypersport',
        namaSeo: 'lykan-hypersport',
        hargaSewa: 700000,
        hargaSopir: 250000,
        durasi: 1,
        termasuk: 'Mobil Saja',
        mesin: '11000 cc',
        tahun: '2018',
        kapasitas: '2 Orang',
        stok: 2,
        keterangan: 'Hypercar legendaris bernuansa futuristik dengan lampu depan berhiaskan berlian dan pintu reverse dihedral door yang spektakuler.',
        gambarUtama: 'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?auto=format&fit=crop&w=800&q=80',
        category: 'Supercar',
        rating: 4.95,
        transmisi: 'Sequential 6-Speed',
        hits: 98,
        detailImages: [
          'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 30,
        nama: 'Bentley Phantom',
        namaSeo: 'bentley-phantom',
        hargaSewa: 250000,
        hargaSopir: 105000,
        durasi: 2,
        termasuk: 'Mobil + BBM',
        mesin: '3500 cc',
        tahun: '2017',
        kapasitas: '5 Orang',
        stok: 2,
        keterangan: 'Sedan ultra-mewah dengan kabin kedap suara mutlak, jok kulit nappa hand-stitched, serta suspensi udara lembut layaknya melayang di atas awan.',
        gambarUtama: 'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=800&q=80',
        category: 'Luxury Sedan',
        rating: 4.9,
        transmisi: 'Otomatis 8-Speed',
        hits: 78,
        detailImages: [
          'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1502877338535-766e1452684a?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 28,
        nama: 'Mobilo Espano Sportivo',
        namaSeo: 'mobilo-espano-sportivo',
        hargaSewa: 350000,
        hargaSopir: 125000,
        durasi: 1,
        termasuk: 'Mobil + BBM',
        mesin: '6000 cc',
        tahun: '2014',
        kapasitas: '2 Orang',
        stok: 1,
        keterangan: 'Coupe sporty dengan akselerasi responsif dan handling tajam, cocok untuk kebutuhan jalan-jalan prestisius dan photoshoot.',
        gambarUtama: 'https://images.unsplash.com/photo-1508974239320-0a029497e820?auto=format&fit=crop&w=800&q=80',
        category: 'Sportivo',
        rating: 4.85,
        transmisi: 'Sport Otomatis',
        hits: 81,
        detailImages: [
          'https://images.unsplash.com/photo-1508974239320-0a029497e820?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 50,
        nama: 'Sed Do Eiusmod Temporaa',
        namaSeo: '--sed-do-eiusmod-temporaa',
        hargaSewa: 400000,
        hargaSopir: 150000,
        durasi: 2,
        termasuk: 'Mobil + BBM',
        mesin: '4000 cc',
        tahun: '2016',
        kapasitas: '4 Orang',
        stok: 1,
        keterangan: 'Sedan eksekutif modern lengkap dengan fitur keselamatan komprehensif, cruise control, dan hiburan multimedia premium.',
        gambarUtama: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=800&q=80',
        category: 'Executive',
        rating: 4.8,
        transmisi: 'Otomatis Tiptronic',
        hits: 52,
        detailImages: [
          'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 31,
        nama: 'Excepteur Sint',
        namaSeo: 'excepteur-sint',
        hargaSewa: 300000,
        hargaSopir: 100000,
        durasi: 1,
        termasuk: 'Mobil + BBM',
        mesin: '5500 cc',
        tahun: '2015',
        kapasitas: '6 Orang',
        stok: 2,
        keterangan: 'SUV keluarga berukuran besar yang lega, suspensi kokoh di jalan perbukitan Sumatera Barat, dan bagasi yang sangat lapang.',
        gambarUtama: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=800&q=80',
        category: 'SUV',
        rating: 4.75,
        transmisi: 'A/T AWD',
        hits: 64,
        detailImages: [
          'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 29,
        nama: 'Non Proident (Family Van)',
        namaSeo: 'non-proident',
        hargaSewa: 200000,
        hargaSopir: 145000,
        durasi: 1,
        termasuk: 'Mobil + BBM',
        mesin: '4500 cc',
        tahun: '2007',
        kapasitas: '8 Orang',
        stok: 3,
        keterangan: 'Minivan lapang kapasitas 8 penumpang, AC double blower dingin, sangat hemat bahan bakar untuk liburan rombongan keluarga.',
        gambarUtama: 'https://images.unsplash.com/photo-1525609004556-c46c7d6cf023?auto=format&fit=crop&w=800&q=80',
        category: 'Family Van',
        rating: 4.7,
        transmisi: 'Manual 5-Speed',
        hits: 74,
        detailImages: [
          'https://images.unsplash.com/photo-1525609004556-c46c7d6cf023?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 41,
        nama: 'Occaecat Cupidatat',
        namaSeo: 'occaecat-cupidatat',
        hargaSewa: 400000,
        hargaSopir: 120000,
        durasi: 1,
        termasuk: 'Mobil + BBM',
        mesin: '5000 cc',
        tahun: '2016',
        kapasitas: '2 Orang',
        stok: 1,
        keterangan: 'Roadster convertible elegan beratap terbuka, memberikan sensasi berkendara menyusuri garis pantai dan pemandangan pegunungan.',
        gambarUtama: 'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=800&q=80',
        category: 'Sportivo',
        rating: 4.9,
        transmisi: 'Otomatis 7-Speed',
        hits: 195,
        detailImages: [
          'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=800&q=80',
        ],
      ),
    ];

    _orders = [
      RentalOrder(
        id: 10,
        kodeOrders: 'TRX-20180802090405',
        namaPemesan: 'Made Putut Wijaya',
        email: 'made.putut@gmail.com',
        noTelpon: '082309881234',
        keterangan: 'Secepatnya ya, untuk keperluan kunjungan bisnis dinas.',
        jemput: 'Jl. Begini Begono No. 12, Padang',
        tujuan: 'Jl. Merdeka Bintara, Bukittinggi',
        status: 'Proses',
        waktu: DateTime(2026, 8, 2),
        car: _cars.firstWhere((c) => c.id == 30),
        driver: _drivers[0],
        pakaiSopir: true,
        dariTanggal: DateTime(2026, 8, 2),
        sampaiTanggal: DateTime(2026, 8, 4),
        sewaPerhari: 250000,
        totalHari: 2,
        totalHarga: 710000, // (250rb sewa + 105rb sopir) * 2 hari
      ),
      RentalOrder(
        id: 14,
        kodeOrders: 'TRX-20190223090148',
        namaPemesan: 'Dewiit Safitri',
        email: 'dewiit.safitri@gmail.com',
        noTelpon: '085234569988',
        keterangan: 'Pemesanan lepas kunci untuk acara keluarga.',
        jemput: 'Jl. Insyur Soekarno No. 45',
        tujuan: 'Jl. Juanda Raya',
        status: 'Proses',
        waktu: DateTime(2026, 2, 23),
        car: _cars.firstWhere((c) => c.id == 31),
        driver: null,
        pakaiSopir: false,
        dariTanggal: DateTime(2026, 2, 23),
        sampaiTanggal: DateTime(2026, 2, 25),
        sewaPerhari: 300000,
        totalHari: 2,
        totalHarga: 600000,
      ),
      RentalOrder(
        id: 7,
        kodeOrders: 'TRX-20180627061400',
        namaPemesan: 'Robby Prihandaya',
        email: 'robby.prihandaya@gmail.com',
        noTelpon: '081267771344',
        keterangan: 'Butuh cepat untuk antar tamu VIP dari bandara.',
        jemput: 'Bandara Internasional Minangkabau (BIM)',
        tujuan: 'Transmart Padang',
        status: 'Selesai',
        waktu: DateTime(2026, 6, 27),
        car: _cars.firstWhere((c) => c.id == 50),
        driver: _drivers[0],
        pakaiSopir: true,
        dariTanggal: DateTime(2026, 6, 27),
        sampaiTanggal: DateTime(2026, 6, 28),
        sewaPerhari: 400000,
        totalHari: 1,
        totalHarga: 550000,
      ),
      RentalOrder(
        id: 15,
        kodeOrders: 'TRX-20190223090509',
        namaPemesan: 'Muhammad Arsenio',
        email: 'muhammad.arsenio@gmail.com',
        noTelpon: '088812445677',
        keterangan: 'Penyewaan weekend trip.',
        jemput: 'Jl. Gumarang Jaya No. 8',
        tujuan: 'Pantai Carocok Painan',
        status: 'Pending',
        waktu: DateTime(2026, 2, 23),
        car: _cars.firstWhere((c) => c.id == 41),
        driver: null,
        pakaiSopir: false,
        dariTanggal: DateTime(2026, 2, 23),
        sampaiTanggal: DateTime(2026, 2, 25),
        sewaPerhari: 400000,
        totalHari: 2,
        totalHarga: 800000,
      ),
    ];
  }

  void addOrder(RentalOrder newOrder) {
    _orders.insert(0, newOrder);
    notifyListeners();
  }

  void updateOrderStatus(String orderCode, String newStatus) {
    final index = _orders.indexWhere((o) => o.kodeOrders == orderCode);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = RentalOrder(
        id: old.id,
        kodeOrders: old.kodeOrders,
        namaPemesan: old.namaPemesan,
        email: old.email,
        noTelpon: old.noTelpon,
        keterangan: old.keterangan,
        jemput: old.jemput,
        tujuan: old.tujuan,
        status: newStatus,
        waktu: old.waktu,
        car: old.car,
        driver: old.driver,
        pakaiSopir: old.pakaiSopir,
        dariTanggal: old.dariTanggal,
        sampaiTanggal: old.sampaiTanggal,
        sewaPerhari: old.sewaPerhari,
        totalHari: old.totalHari,
        totalHarga: old.totalHarga,
        bankPembayaran: old.bankPembayaran,
      );
      notifyListeners();
    }
  }
}
