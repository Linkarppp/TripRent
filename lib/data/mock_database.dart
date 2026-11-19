import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car.dart';
import '../models/driver.dart';
import '../models/order.dart';
import '../models/company_profile.dart';
import '../models/user.dart';
import '../models/travel_ticket.dart';
import '../models/transaction.dart';

class TripRentStore extends ChangeNotifier {
  static final TripRentStore instance = TripRentStore._internal();
  TripRentStore._internal() {
    _initData();
    _loadFromStorage();
  }

  factory TripRentStore() => instance;

  late List<Car> _cars;
  late List<Driver> _drivers;
  late List<RentalOrder> _orders;
  late CompanyProfile _companyProfile;
  late List<User> _users;
  User? _currentUser;
  late List<TravelTicket> _tickets;
  late List<TransactionRecord> _transactions;

  List<Car> get cars => _cars;
  List<Driver> get drivers => _drivers;
  List<RentalOrder> get orders => _orders;
  CompanyProfile get companyProfile => _companyProfile;
  List<User> get users => _users;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  List<TravelTicket> get tickets => _tickets;
  List<TransactionRecord> get transactions => _transactions;

  // Supir yang sedang login (jika role = driver)
  Driver? get currentDriver {
    if (_currentUser == null) return null;
    try {
      if (_currentUser!.driverId != null) {
        return _drivers.firstWhere((d) => d.id == _currentUser!.driverId);
      }
      return _drivers.firstWhere((d) =>
          d.userId == _currentUser!.id ||
          d.nama.toLowerCase() == _currentUser!.namaLengkap.toLowerCase() ||
          d.noHp.replaceAll(RegExp(r'[^0-9]'), '') ==
              _currentUser!.noTelp.replaceAll(RegExp(r'[^0-9]'), ''));
    } catch (_) {
      // Fallback jika role driver tapi belum terhubung, kembalikan driver pertama
      if (_currentUser!.isDriver && _drivers.isNotEmpty) {
        return _drivers.first;
      }
      return null;
    }
  }

  // Daftar tugas khusus supir yang login
  List<RentalOrder> get driverTasks {
    final driver = currentDriver;
    if (driver == null) return [];
    return _orders.where((o) {
      return (o.driverId == driver.id ||
              (o.driver != null && o.driver!.id == driver.id) ||
              (o.pakaiSopir && o.driver?.nama == driver.nama));
    }).toList();
  }

  // Daftar pesanan milik user yang login
  List<RentalOrder> get userOrders {
    if (_currentUser == null) return _orders;
    if (_currentUser!.isAdmin) return _orders;
    return _orders.where((o) =>
        o.userId == _currentUser!.id ||
        o.email.toLowerCase() == _currentUser!.email.toLowerCase() ||
        o.namaPemesan.toLowerCase() == _currentUser!.namaLengkap.toLowerCase()
    ).toList();
  }

  void _initData() {
    _companyProfile = CompanyProfile(
      namaWebsite: 'TripRent - Rental Mobil & Travel Online',
      email: 'robby.prihandaya@gmail.com',
      noTelp: '0812-8694-3954',
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
        keterangan: 'Driver senior berlisensi SIM A & B1 Umum. Sangat ramah, menguasai seluruh rute wisata Sumatera Barat, Riau, dan Tol Trans Jawa.',
        foto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        rating: 4.98,
        totalPerjalanan: 245,
        tersedia: true,
        statusKetersediaan: 'Tersedia',
        noHp: '0812-6777-1344',
        noSim: 'SIM A & B1 Umum (No. 890512345)',
        userId: 'driver-1',
        isAktif: true,
      ),
      Driver(
        id: 2,
        nama: 'Pak Budi Hartono',
        jenisKelamin: 'Laki-laki',
        tempatLahir: 'Solo',
        tanggalLahir: '1985-08-14',
        alamat: 'Jl. Khatib Sulaiman No. 28, Padang Utara',
        keterangan: 'Spesialis pengemudi armada HiAce dan Elf Microbus pariwisata. Mengutamakan ketepatan waktu, keselamatan berkendara, dan kabin bebas rokok.',
        foto: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
        rating: 4.92,
        totalPerjalanan: 198,
        tersedia: true,
        statusKetersediaan: 'Dalam Perjalanan',
        noHp: '0813-8899-2311',
        noSim: 'SIM B1 Umum (No. 850811902)',
        userId: 'driver-2',
        isAktif: true,
      ),
      Driver(
        id: 3,
        nama: 'Dewiit Safitri',
        jenisKelamin: 'Perempuan',
        tempatLahir: 'Payakumbuh',
        tanggalLahir: '1989-02-12',
        alamat: 'Jl. Linggar Jati 2, Perupuk Tabing, Padang',
        keterangan: 'Driver berpengalaman untuk perjalanan keluarga, ibu & anak, serta tamu VIP. Sangat teliti, sopan, dan menjaga kebersihan armada.',
        foto: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
        rating: 4.95,
        totalPerjalanan: 168,
        tersedia: true,
        statusKetersediaan: 'Tersedia',
        noHp: '0852-3456-9988',
        noSim: 'SIM A (No. 890214887)',
        isAktif: true,
      ),
      Driver(
        id: 4,
        nama: 'Pak Yanto Supriyadi',
        jenisKelamin: 'Laki-laki',
        tempatLahir: 'Bandung',
        tanggalLahir: '1982-11-20',
        alamat: 'Jl. Veteran No. 15, Padang Barat',
        keterangan: 'Driver handal bersertifikat Defensive Driving. Berpengalaman 15 tahun membawa rombongan tour antar kota dan kawasan pegunungan terjal.',
        foto: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80',
        rating: 4.89,
        totalPerjalanan: 215,
        tersedia: false,
        statusKetersediaan: 'Istirahat',
        noHp: '0821-4567-8890',
        noSim: 'SIM B1 Umum (No. 821109765)',
        isAktif: true,
      ),
    ];

    _cars = [
      Car(
        id: 1,
        nama: 'Toyota All New Avanza',
        namaSeo: 'toyota-all-new-avanza',
        hargaSewa: 350000,
        hargaSopir: 150000,
        durasi: 1,
        termasuk: 'Mobil Saja',
        mesin: '1500 cc Dual VVT-i',
        tahun: '2023',
        kapasitas: '7 Orang',
        stok: 5,
        keterangan: 'Mobil rental terfavorit keluarga Indonesia. Kabin lega 7 penumpang, AC double blower dingin merata, suspensi nyaman, dan sangat hemat bahan bakar.',
        gambarUtama: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80',
        category: CarCategory.keluarga,
        rating: 4.9,
        transmisi: 'Otomatis CVT',
        hits: 240,
        detailImages: [
          'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 2,
        nama: 'Toyota Innova Reborn',
        namaSeo: 'toyota-innova-reborn',
        hargaSewa: 550000,
        hargaSopir: 150000,
        durasi: 1,
        termasuk: 'Mobil Saja',
        mesin: '2400 cc 2GD Turbo Diesel',
        tahun: '2022',
        kapasitas: '7-8 Orang',
        stok: 4,
        keterangan: 'Standar emas armada travel dan rental eksekutif di Indonesia. Mesin diesel tangguh melibas tanjakan perbukitan, kabin senyap, suspensi empuk.',
        gambarUtama: 'https://images.unsplash.com/photo-1550355291-bbee04a92027?auto=format&fit=crop&w=800&q=80',
        category: CarCategory.eksekutif,
        rating: 4.95,
        transmisi: 'Otomatis',
        hits: 310,
        detailImages: [
          'https://images.unsplash.com/photo-1550355291-bbee04a92027?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 3,
        nama: 'Toyota All New Rush',
        namaSeo: 'toyota-all-new-rush',
        hargaSewa: 400000,
        hargaSopir: 150000,
        durasi: 1,
        termasuk: 'Mobil Saja',
        mesin: '1500 cc DOHC Dual VVT-i',
        tahun: '2023',
        kapasitas: '7 Orang',
        stok: 4,
        keterangan: 'SUV keluarga tangguh dengan ground clearance tinggi (220 mm). Siap melibas berbagai medan jalan ke destinasi wisata alam, pantai, dan perbukitan.',
        gambarUtama: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=800&q=80',
        category: CarCategory.tangguh,
        rating: 4.85,
        transmisi: 'Otomatis',
        hits: 195,
        detailImages: [
          'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 4,
        nama: 'Toyota HiAce Premio',
        namaSeo: 'toyota-hiace-premio',
        hargaSewa: 1200000,
        hargaSopir: 200000,
        durasi: 1,
        termasuk: 'Mobil + Sopir',
        mesin: '2800 cc 1GD-FTV Diesel Turbo',
        tahun: '2023',
        kapasitas: '12-14 Orang',
        stok: 3,
        keterangan: 'Minibus van mewah pilihan utama rombongan travel wisata dan antar-jemput bandara VIP. Interior eksekutif dengan kursi reclining lebar.',
        gambarUtama: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=800&q=80',
        category: CarCategory.rombongan,
        rating: 5.0,
        transmisi: 'Manual 6-Speed',
        hits: 280,
        detailImages: [
          'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 5,
        nama: 'Isuzu Elf Long Microbus',
        namaSeo: 'isuzu-elf-long-microbus',
        hargaSewa: 1100000,
        hargaSopir: 200000,
        durasi: 1,
        termasuk: 'Mobil + Sopir',
        mesin: '2771 cc 4JB1-TC Turbo',
        tahun: '2022',
        kapasitas: '19 Orang',
        stok: 3,
        keterangan: 'Microbus berkapasitas besar hingga 19 penumpang, sangat populer untuk study tour, gathering kantor, ziarah, dan rombongan keluarga besar.',
        gambarUtama: 'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=800&q=80',
        category: CarCategory.rombongan,
        rating: 4.8,
        transmisi: 'Manual 5-Speed',
        hits: 210,
        detailImages: [
          'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 6,
        nama: 'Mitsubishi Pajero Sport Dakar',
        namaSeo: 'mitsubishi-pajero-sport-dakar',
        hargaSewa: 1100000,
        hargaSopir: 200000,
        durasi: 1,
        termasuk: 'Mobil Saja',
        mesin: '2400 cc MIVEC Turbo Diesel 181 PS',
        tahun: '2023',
        kapasitas: '7 Orang',
        stok: 2,
        keterangan: 'Big SUV prestisius berkarakter gagah dan bertenaga besar. Pilihan utama dinas instansi, kunjungan proyek, dan perjalanan VIP.',
        gambarUtama: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80',
        category: CarCategory.tangguh,
        rating: 4.9,
        transmisi: 'Otomatis 8-Speed',
        hits: 160,
        detailImages: [
          'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80',
        ],
      ),
      Car(
        id: 7,
        nama: 'Honda Brio RS',
        namaSeo: 'honda-brio-rs',
        hargaSewa: 300000,
        hargaSopir: 150000,
        durasi: 1,
        termasuk: 'Mobil Saja',
        mesin: '1200 cc i-VTEC',
        tahun: '2023',
        kapasitas: '5 Orang',
        stok: 4,
        keterangan: 'City car lincah, stylish, dan sangat irit bahan bakar. Fleksibel untuk manuver di lalu lintas padat dan jalan sempit.',
        gambarUtama: 'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80',
        category: CarCategory.hemat,
        rating: 4.8,
        transmisi: 'CVT Otomatis',
        hits: 180,
        detailImages: [
          'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80',
        ],
      ),
    ];

    _users = [
      const User(
        id: 'admin-1',
        username: 'admin',
        email: 'admin@triprent.com',
        namaLengkap: 'Administrator TripRent',
        noTelp: '0812-8694-3954',
        password: 'admin123',
        foto: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80',
        level: 'Super Admin',
        role: 'admin',
        status: 'aktif',
      ),
      const User(
        id: 'user-1',
        username: 'user',
        email: 'user@triprent.com',
        namaLengkap: 'Rahmat Hidayat',
        noTelp: '0812-3456-7890',
        password: 'password123',
        foto: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
        level: 'VIP Member',
        role: 'user',
        status: 'aktif',
      ),
      const User(
        id: 'driver-1',
        username: 'driver',
        email: 'driver@triprent.com',
        namaLengkap: 'Robby Prihandaya',
        noTelp: '0812-6777-1344',
        password: 'driver123',
        foto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        level: 'Senior Driver',
        role: 'driver',
        driverId: 1,
        status: 'aktif',
      ),
      const User(
        id: 'driver-2',
        username: 'driver_budi',
        email: 'budi@triprent.com',
        namaLengkap: 'Pak Budi Hartono',
        noTelp: '0813-8899-2311',
        password: 'driver123',
        foto: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
        level: 'Pariwisata Driver',
        role: 'driver',
        driverId: 2,
        status: 'aktif',
      ),
      const User(
        id: 'user-2',
        username: 'dewiit',
        email: 'dewiit.safitri@gmail.com',
        namaLengkap: 'Dewiit Safitri',
        noTelp: '0852-3456-9988',
        password: 'password123',
        foto: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
        level: 'Gold Member',
        role: 'user',
        status: 'aktif',
      ),
    ];

    _orders = [
      RentalOrder(
        id: 1,
        kodeOrders: 'SHU-20261120083015',
        namaPemesan: 'Rahmat Hidayat',
        email: 'user@triprent.com',
        noTelpon: '0812-3456-7890',
        keterangan: 'Shuttle Bandung (Dipatiukur) → Jakarta (Pancoran) | Kursi: [1A, 2A] | Jam: 08:00 WIB',
        jemput: 'Outlet Dipatiukur (Bandung)',
        tujuan: 'Outlet Pancoran (Jakarta)',
        status: 'Proses',
        waktu: DateTime.now().subtract(const Duration(hours: 1)),
        car: _cars.firstWhere((c) => c.category == 'Family Van' || c.id == 2),
        driver: _drivers[0],
        driverId: 1,
        userId: 'user-1',
        pakaiSopir: true,
        dariTanggal: DateTime.now(),
        sampaiTanggal: DateTime.now(),
        sewaPerhari: 120000,
        totalHari: 1,
        totalHarga: 240000,
        bankPembayaran: 'QRIS (NMID: ID1020038491829)',
        isTicket: true,
        ticketTitle: 'Bandung (Dipatiukur) → Jakarta (Pancoran)',
        driverTaskStatus: 'Diterima',
        paymentStatus: 'Lunas',
        passengerCount: 2,
        seatNumbers: 'Kursi 1A, 2A',
        paymentMethodType: 'QRIS',
        departureTime: '08:00 WIB',
      ),
      RentalOrder(
        id: 2,
        kodeOrders: 'SHU-20261121140022',
        namaPemesan: 'Rahmat Hidayat',
        email: 'user@triprent.com',
        noTelpon: '0812-3456-7890',
        keterangan: 'Shuttle Tangerang (BSD) → Bandung (Pasteur) | Kursi: [3] | Jam: 14:00 WIB',
        jemput: 'Outlet BSD City (Tangerang)',
        tujuan: 'Outlet Pasteur (Bandung)',
        status: 'Pending',
        waktu: DateTime.now().subtract(const Duration(minutes: 30)),
        car: _cars.firstWhere((c) => c.category == 'Family Van' || c.id == 2),
        driver: _drivers[0],
        driverId: 1,
        userId: 'user-1',
        pakaiSopir: true,
        dariTanggal: DateTime.now().add(const Duration(days: 1)),
        sampaiTanggal: DateTime.now().add(const Duration(days: 1)),
        sewaPerhari: 135000,
        totalHari: 1,
        totalHarga: 135000,
        bankPembayaran: 'Transfer Bank (BCA)',
        isTicket: true,
        ticketTitle: 'Tangerang (BSD) → Bandung (Pasteur)',
        driverTaskStatus: 'Menunggu Konfirmasi',
        paymentStatus: 'Menunggu Verifikasi',
        passengerCount: 1,
        seatNumbers: 'Kursi 3',
        paymentMethodType: 'Transfer Bank',
        departureTime: '14:00 WIB',
      ),
      RentalOrder(
        id: 10,
        kodeOrders: 'TRX-20260802090405',
        namaPemesan: 'Rahmat Hidayat',
        email: 'user@triprent.com',
        noTelpon: '0812-3456-7890',
        keterangan: 'Kunjungan dinas instansi ke Bukittinggi dan Payakumbuh.',
        jemput: 'Bandara Internasional Minangkabau (BIM)',
        tujuan: 'Bukittinggi & Payakumbuh',
        status: 'Proses',
        waktu: DateTime.now().subtract(const Duration(hours: 3)),
        car: _cars.firstWhere((c) => c.id == 2),
        driver: _drivers[0],
        driverId: 1,
        userId: 'user-1',
        pakaiSopir: true,
        dariTanggal: DateTime.now(),
        sampaiTanggal: DateTime.now().add(const Duration(days: 2)),
        sewaPerhari: 550000,
        totalHari: 2,
        totalHarga: 1400000,
        driverTaskStatus: 'Dalam Perjalanan',
        paymentStatus: 'Lunas',
      ),
      RentalOrder(
        id: 11,
        kodeOrders: 'TRX-20261119091200',
        namaPemesan: 'Dewiit Safitri',
        email: 'dewiit.safitri@gmail.com',
        noTelpon: '0852-3456-9988',
        keterangan: 'Penjemputan hotel untuk acara keluarga di Danau Singkarak.',
        jemput: 'Hotel Grand Zuri Padang',
        tujuan: 'Danau Singkarak & Solok',
        status: 'Pending',
        waktu: DateTime.now().subtract(const Duration(hours: 1)),
        car: _cars.firstWhere((c) => c.id == 1),
        driver: _drivers[0],
        driverId: 1,
        userId: 'user-2',
        pakaiSopir: true,
        dariTanggal: DateTime.now().add(const Duration(days: 1)),
        sampaiTanggal: DateTime.now().add(const Duration(days: 2)),
        sewaPerhari: 350000,
        totalHari: 1,
        totalHarga: 500000,
        driverTaskStatus: 'Menunggu Konfirmasi',
        paymentStatus: 'Menunggu Verifikasi',
      ),
      RentalOrder(
        id: 14,
        kodeOrders: 'TRX-20260223090148',
        namaPemesan: 'Rahmat Hidayat',
        email: 'user@triprent.com',
        noTelpon: '0812-3456-7890',
        keterangan: 'Pemesanan lepas kunci untuk silaturahmi keluarga.',
        jemput: 'Jl. Linggar Jati 2, Padang',
        tujuan: 'Kota Solok & Danau Singkarak',
        status: 'Proses',
        waktu: DateTime(2026, 2, 23),
        car: _cars.firstWhere((c) => c.id == 1),
        driver: null,
        driverId: null,
        userId: 'user-1',
        pakaiSopir: false,
        dariTanggal: DateTime(2026, 2, 23),
        sampaiTanggal: DateTime(2026, 2, 25),
        sewaPerhari: 350000,
        totalHari: 2,
        totalHarga: 700000,
        driverTaskStatus: 'Menunggu Konfirmasi',
        paymentStatus: 'Lunas',
      ),
      RentalOrder(
        id: 7,
        kodeOrders: 'TRX-20260627061400',
        namaPemesan: 'Rahmat Hidayat',
        email: 'user@triprent.com',
        noTelpon: '0812-3456-7890',
        keterangan: 'Antar jemput rombongan tamu VIP dari bandara ke hotel.',
        jemput: 'Bandara Internasional Minangkabau (BIM)',
        tujuan: 'Hotel Grand Zuri Padang',
        status: 'Selesai',
        waktu: DateTime(2026, 6, 27),
        car: _cars.firstWhere((c) => c.id == 4),
        driver: _drivers[0],
        driverId: 1,
        userId: 'user-1',
        pakaiSopir: true,
        dariTanggal: DateTime(2026, 6, 27),
        sampaiTanggal: DateTime(2026, 6, 28),
        sewaPerhari: 1200000,
        totalHari: 1,
        totalHarga: 1400000,
        driverTaskStatus: 'Perjalanan Selesai',
        paymentStatus: 'Lunas',
      ),
      RentalOrder(
        id: 15,
        kodeOrders: 'TRX-20260223090509',
        namaPemesan: 'Muhammad Arsenio',
        email: 'muhammad.arsenio@gmail.com',
        noTelpon: '088812445677',
        keterangan: 'Penyewaan weekend trip ke Pantai Carocok Painan.',
        jemput: 'Jl. Gumarang Jaya No. 8',
        tujuan: 'Pantai Carocok Painan',
        status: 'Pending',
        waktu: DateTime(2026, 2, 23),
        car: _cars.firstWhere((c) => c.id == 3),
        driver: _drivers[1],
        driverId: 2,
        userId: 'user-2',
        pakaiSopir: true,
        dariTanggal: DateTime(2026, 2, 23),
        sampaiTanggal: DateTime(2026, 2, 25),
        sewaPerhari: 400000,
        totalHari: 2,
        totalHarga: 800000,
        driverTaskStatus: 'Diterima',
        paymentStatus: 'Menunggu Verifikasi',
      ),
    ];

    _tickets = [
      const TravelTicket(
        id: 1,
        title: 'Shuttle Bandara BIM - Kota Padang (Drop Point)',
        category: 'Airport Shuttle',
        origin: 'Bandara Internasional Minangkabau (BIM)',
        destination: 'Pusat Kota Padang (Drop Point Hotel)',
        price: 50000,
        estimatedDuration: '45 Menit',
        vehicleName: 'Toyota HiAce Premio',
        departureTimes: ['07:00', '09:30', '12:00', '14:30', '17:00', '19:30', '21:00'],
        availableSeats: 12,
        image: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=800&q=80',
        description: 'Layanan shuttle bandara terjadwal dengan HiAce Premio full AC, bagasi aman, dan antar langsung ke drop point hotel kota Padang.',
      ),
      const TravelTicket(
        id: 2,
        title: 'Travel Eksekutif Padang - Bukittinggi (PP)',
        category: 'Antar Kota (Shuttle)',
        origin: 'Pool Padang (Tunggul Hitam)',
        destination: 'Pool Bukittinggi (Jam Gadang)',
        price: 65000,
        estimatedDuration: '2 Jam 15 Menit',
        vehicleName: 'Toyota Avanza & Innova Reborn',
        departureTimes: ['06:30', '09:00', '11:30', '14:00', '16:30', '19:00'],
        availableSeats: 7,
        image: 'https://images.unsplash.com/photo-1550355291-bbee04a92027?auto=format&fit=crop&w=800&q=80',
        description: 'Travel antar kota via Lembah Anai & Padang Panjang. Layanan point-to-point dengan armada nyaman, sejuk, dan sopir berpengalaman.',
      ),
      const TravelTicket(
        id: 3,
        title: 'Travel VIP Padang - Payakumbuh Express',
        category: 'Antar Kota (Shuttle)',
        origin: 'Pool Padang (Tunggul Hitam)',
        destination: 'Pusat Kota Payakumbuh',
        price: 75000,
        estimatedDuration: '2.5 Jam',
        vehicleName: 'Toyota All New Rush',
        departureTimes: ['07:00', '10:00', '13:00', '16:00', '19:00'],
        availableSeats: 6,
        image: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=800&q=80',
        description: 'Perjalanan cepat Padang ke Payakumbuh tanpa transit. Full AC, audio musik santai, dan singgah di rest area kuliner lokal.',
      ),
    ];

    _initTransactions();
  }

  void _initTransactions() {
    _transactions = _orders.map((o) {
      return TransactionRecord(
        id: 'TXN-${o.id}',
        orderCode: o.kodeOrders,
        customerName: o.namaPemesan,
        itemName: o.isTicket ? (o.ticketTitle ?? 'Tiket Travel') : o.car.nama,
        totalAmount: o.totalHarga,
        paymentMethod: o.bankPembayaran,
        status: o.paymentStatus,
        transactionDate: o.waktu,
        proofImageUrl: o.buktiPembayaran,
      );
    }).toList();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('triprent_registered_users');
      if (usersJson != null && usersJson.isNotEmpty) {
        final List<dynamic> list = jsonDecode(usersJson);
        for (final item in list) {
          final u = User.fromJson(Map<String, dynamic>.from(item));
          final idx = _users.indexWhere(
              (existing) => existing.email.toLowerCase() == u.email.toLowerCase());
          if (idx == -1) {
            _users.insert(0, u);
          } else {
            _users[idx] = u;
          }
        }
      }
      final currentUserId = prefs.getString('triprent_current_user_id');
      if (currentUserId != null) {
        final found = _users.where((u) => u.id == currentUserId);
        if (found.isNotEmpty) {
          _currentUser = found.first;
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveUsersToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersData = _users.map((u) => u.toJson()).toList();
      await prefs.setString('triprent_registered_users', jsonEncode(usersData));
      if (_currentUser != null) {
        await prefs.setString('triprent_current_user_id', _currentUser!.id);
      } else {
        await prefs.remove('triprent_current_user_id');
      }
    } catch (_) {}
  }

  // --- AUTENTIKASI & ROLE ---
  ({bool success, String message, User? user}) login({
    required String identifier,
    required String password,
  }) {
    final cleanId = identifier.trim().toLowerCase();
    final cleanPass = password.trim();

    try {
      final user = _users.firstWhere((u) =>
          u.email.toLowerCase() == cleanId ||
          u.username.toLowerCase() == cleanId ||
          u.noTelp.replaceAll(RegExp(r'[^0-9]'), '') ==
              cleanId.replaceAll(RegExp(r'[^0-9]'), ''));

      if (!user.isAktif) {
        return (
          success: false,
          message: 'Akun Anda berstatus nonaktif. Silakan hubungi Administrator.',
          user: null,
        );
      }

      if (user.password == cleanPass) {
        _currentUser = user;
        _saveUsersToStorage();
        notifyListeners();
        return (
          success: true,
          message: 'Selamat datang kembali, ${user.namaLengkap}!',
          user: user,
        );
      } else {
        return (
          success: false,
          message: 'Kata sandi yang Anda masukkan salah.',
          user: null,
        );
      }
    } catch (_) {
      return (
        success: false,
        message: 'Akun dengan email atau username tersebut tidak ditemukan.',
        user: null,
      );
    }
  }

  ({bool success, String message}) register({
    required String namaLengkap,
    required String email,
    required String noTelp,
    required String password,
    String role = 'user',
  }) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = noTelp.trim();
    final cleanName = namaLengkap.trim();
    final cleanPass = password.trim();

    if (cleanName.isEmpty || cleanEmail.isEmpty || cleanPass.isEmpty) {
      return (success: false, message: 'Semua kolom wajib diisi.');
    }

    final exists = _users.any((u) =>
        u.email.toLowerCase() == cleanEmail ||
        (cleanPhone.isNotEmpty && u.noTelp == cleanPhone));

    if (exists) {
      return (
        success: false,
        message: 'Email atau nomor telepon sudah terdaftar. Silakan login.',
      );
    }

    final newUser = User(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      username: cleanEmail.split('@').first,
      email: cleanEmail,
      namaLengkap: cleanName,
      noTelp: cleanPhone,
      password: cleanPass,
      foto:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
      level: 'Member Baru',
      role: role,
      status: 'aktif',
    );

    _users.insert(0, newUser);
    _currentUser = newUser;
    _saveUsersToStorage();
    notifyListeners();
    return (
      success: true,
      message: 'Pendaftaran berhasil! Selamat bergabung, $cleanName.',
    );
  }

  void logout() {
    _currentUser = null;
    _saveUsersToStorage();
    notifyListeners();
  }

  // --- KELOLA USER (ADMIN) ---
  void addUser(User user) {
    _users.insert(0, user);
    _saveUsersToStorage();
    notifyListeners();
  }

  void updateUser(User user) {
    final idx = _users.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      _users[idx] = user;
      if (_currentUser?.id == user.id) {
        _currentUser = user;
      }
      _saveUsersToStorage();
      notifyListeners();
    }
  }

  void deleteUser(String userId) {
    _users.removeWhere((u) => u.id == userId);
    if (_currentUser?.id == userId) {
      _currentUser = null;
    }
    _saveUsersToStorage();
    notifyListeners();
  }

  void toggleUserStatus(String userId) {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      final old = _users[idx];
      final newStatus = old.status == 'aktif' ? 'nonaktif' : 'aktif';
      _users[idx] = old.copyWith(status: newStatus);
      if (_currentUser?.id == userId) {
        _currentUser = _users[idx];
      }
      _saveUsersToStorage();
      notifyListeners();
    }
  }

  // --- KELOLA MOBIL (ADMIN & USER) ---
  void addCar(Car car) {
    _cars.insert(0, car);
    notifyListeners();
  }

  void updateCar(Car car) {
    final idx = _cars.indexWhere((c) => c.id == car.id);
    if (idx != -1) {
      _cars[idx] = car;
      notifyListeners();
    }
  }

  void deleteCar(int carId) {
    _cars.removeWhere((c) => c.id == carId);
    notifyListeners();
  }

  void toggleCarAvailability(int carId) {
    final idx = _cars.indexWhere((c) => c.id == carId);
    if (idx != -1) {
      final old = _cars[idx];
      _cars[idx] = old.copyWith(aktif: !old.aktif);
      notifyListeners();
    }
  }

  // --- KELOLA SUPIR (ADMIN & DRIVER) ---
  void addDriver(
    Driver driver, {
    String? username,
    String? password,
  }) {
    _drivers.insert(0, driver);
    // Jika admin membuat akun login untuk supir
    if (username != null && username.isNotEmpty && password != null && password.isNotEmpty) {
      final driverUser = User(
        id: 'driver-usr-${driver.id}',
        username: username.trim().toLowerCase(),
        email: '${username.trim().toLowerCase()}@triprent.com',
        namaLengkap: driver.nama,
        noTelp: driver.noHp,
        password: password.trim(),
        foto: driver.foto,
        level: 'Mitra Supir',
        role: 'driver',
        driverId: driver.id,
        status: 'aktif',
      );
      _users.insert(0, driverUser);
      _saveUsersToStorage();
    }
    notifyListeners();
  }

  void updateDriver(Driver driver) {
    final idx = _drivers.indexWhere((d) => d.id == driver.id);
    if (idx != -1) {
      _drivers[idx] = driver;
      // Perbarui juga data di User jika terhubung
      final uIdx = _users.indexWhere((u) => u.driverId == driver.id || u.id == driver.userId);
      if (uIdx != -1) {
        _users[uIdx] = _users[uIdx].copyWith(
          namaLengkap: driver.nama,
          noTelp: driver.noHp,
          foto: driver.foto,
        );
      }
      notifyListeners();
    }
  }

  void deleteDriver(int driverId) {
    _drivers.removeWhere((d) => d.id == driverId);
    _users.removeWhere((u) => u.driverId == driverId);
    _saveUsersToStorage();
    notifyListeners();
  }

  void updateDriverAvailability(int driverId, String status) {
    final idx = _drivers.indexWhere((d) => d.id == driverId);
    if (idx != -1) {
      final old = _drivers[idx];
      _drivers[idx] = old.copyWith(
        statusKetersediaan: status,
        tersedia: status == 'Tersedia',
      );
      notifyListeners();
    }
  }

  void toggleDriverStatus(int driverId) {
    final idx = _drivers.indexWhere((d) => d.id == driverId);
    if (idx != -1) {
      final old = _drivers[idx];
      _drivers[idx] = old.copyWith(isAktif: !old.isAktif);
      notifyListeners();
    }
  }

  // --- KELOLA PEMESANAN & PENUGASAN SUPIR ---
  void addOrder(RentalOrder newOrder) {
    _orders.insert(0, newOrder);
    _transactions.insert(
      0,
      TransactionRecord(
        id: 'TXN-${newOrder.id}',
        orderCode: newOrder.kodeOrders,
        customerName: newOrder.namaPemesan,
        itemName: newOrder.isTicket
            ? (newOrder.ticketTitle ?? 'Tiket Travel')
            : newOrder.car.nama,
        totalAmount: newOrder.totalHarga,
        paymentMethod: newOrder.bankPembayaran,
        status: newOrder.paymentStatus,
        transactionDate: newOrder.waktu,
        proofImageUrl: newOrder.buktiPembayaran,
      ),
    );
    notifyListeners();
  }

  void updateOrderStatus(String orderCode, String newStatus) {
    final index = _orders.indexWhere((o) => o.kodeOrders == orderCode);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void assignDriverToOrder(String orderCode, int driverId) {
    final orderIndex = _orders.indexWhere((o) => o.kodeOrders == orderCode);
    final driverIndex = _drivers.indexWhere((d) => d.id == driverId);

    if (orderIndex != -1 && driverIndex != -1) {
      final assignedDriver = _drivers[driverIndex];
      _orders[orderIndex] = _orders[orderIndex].copyWith(
        driver: assignedDriver,
        driverId: assignedDriver.id,
        pakaiSopir: true,
        driverTaskStatus: 'Menunggu Konfirmasi',
      );
      notifyListeners();
    }
  }

  void updateDriverTaskStatus(String orderCode, String taskStatus) {
    final index = _orders.indexWhere((o) => o.kodeOrders == orderCode);
    if (index != -1) {
      final old = _orders[index];
      String newOrderStatus = old.status;
      if (taskStatus == 'Dalam Perjalanan') {
        newOrderStatus = 'Proses';
      } else if (taskStatus == 'Perjalanan Selesai') {
        newOrderStatus = 'Selesai';
      } else if (taskStatus == 'Ditolak') {
        // supir menolak
      }
      _orders[index] = old.copyWith(
        driverTaskStatus: taskStatus,
        status: newOrderStatus,
      );
      notifyListeners();
    }
  }

  void deleteOrder(String orderCode) {
    _orders.removeWhere((o) => o.kodeOrders == orderCode);
    _transactions.removeWhere((t) => t.orderCode == orderCode);
    notifyListeners();
  }

  // --- KELOLA TRANSAKSI (ADMIN & USER) ---
  void verifyPayment(String orderCode, String newPaymentStatus) {
    final oIdx = _orders.indexWhere((o) => o.kodeOrders == orderCode);
    if (oIdx != -1) {
      _orders[oIdx] = _orders[oIdx].copyWith(paymentStatus: newPaymentStatus);
    }
    final tIdx = _transactions.indexWhere((t) => t.orderCode == orderCode);
    if (tIdx != -1) {
      _transactions[tIdx] =
          _transactions[tIdx].copyWith(status: newPaymentStatus);
    }
    notifyListeners();
  }

  void uploadPaymentProof(String orderCode, String proofUrl) {
    final oIdx = _orders.indexWhere((o) => o.kodeOrders == orderCode);
    if (oIdx != -1) {
      _orders[oIdx] = _orders[oIdx].copyWith(
        buktiPembayaran: proofUrl,
        paymentStatus: 'Menunggu Verifikasi',
      );
    }
    final tIdx = _transactions.indexWhere((t) => t.orderCode == orderCode);
    if (tIdx != -1) {
      _transactions[tIdx] = _transactions[tIdx].copyWith(
        proofImageUrl: proofUrl,
        status: 'Menunggu Verifikasi',
      );
    }
    notifyListeners();
  }

  // --- Sales & Statistics ---
  int get totalRevenue => _transactions
      .where((t) => t.status == 'Lunas')
      .fold(0, (sum, t) => sum + t.totalAmount);

  int get totalCompletedRevenue => _orders
      .where((o) => o.status == 'Selesai')
      .fold(0, (sum, o) => sum + o.totalHarga);

  int get totalCarRentalsRevenue => _orders
      .where((o) => !o.isTicket && o.status != 'Dibatalkan')
      .fold(0, (sum, o) => sum + o.totalHarga);

  int get totalTicketsRevenue => _orders
      .where((o) => o.isTicket && o.status != 'Dibatalkan')
      .fold(0, (sum, o) => sum + o.totalHarga);

  int get countCompletedOrders =>
      _orders.where((o) => o.status == 'Selesai').length;

  int get countProcessOrders =>
      _orders.where((o) => o.status == 'Proses').length;

  int get countPendingOrders =>
      _orders.where((o) => o.status == 'Pending').length;

  int get countCancelledOrders =>
      _orders.where((o) => o.status == 'Dibatalkan').length;

  int get totalPendingPaymentRevenue => _transactions
      .where((t) => t.status == 'Menunggu Verifikasi')
      .fold(0, (sum, t) => sum + t.totalAmount);

  int get countActiveCars => _cars.where((c) => c.aktif).length;
  int get countActiveDrivers => _drivers.where((d) => d.isAktif).length;
  int get countAvailableDrivers =>
      _drivers.where((d) => d.isAktif && d.statusKetersediaan == 'Tersedia').length;
  int get countUsers => _users.where((u) => u.isUser).length;
  int get countAllBookings => _orders.length;
  int get countAllTransactions => _transactions.length;
}
