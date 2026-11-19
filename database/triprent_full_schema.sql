-- ==========================================================
-- TripRent - Sistem Pemesanan Tiket Perjalanan & Rental Mobil
-- Full MySQL Schema & Seed Data (Multi-Role: Admin, User, Driver)
-- Compatible with MySQL 5.7+ / MariaDB 10+
-- ==========================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `driver_assignments`;
DROP TABLE IF EXISTS `transactions`;
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `drivers`;
DROP TABLE IF EXISTS `cars`;
DROP TABLE IF EXISTS `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------
-- 1. Table `users` (Menyimpan Akun & Hak Akses Role)
-- ----------------------------------------------------------
CREATE TABLE `users` (
  `id` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL UNIQUE,
  `email` varchar(100) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `no_telp` varchar(25) NOT NULL,
  `foto` text DEFAULT NULL,
  `level` varchar(50) DEFAULT 'Member',
  `role` enum('admin', 'user', 'driver') NOT NULL DEFAULT 'user',
  `status` enum('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif',
  `driver_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------
-- 2. Table `cars` (Menyimpan Data Mobil & Ketersediaan)
-- ----------------------------------------------------------
CREATE TABLE `cars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  `nama_seo` varchar(100) NOT NULL,
  `harga_sewa` int(11) NOT NULL,
  `harga_sopir` int(11) NOT NULL DEFAULT 150000,
  `durasi` int(11) NOT NULL DEFAULT 1,
  `termasuk` varchar(255) NOT NULL DEFAULT 'Mobil Saja',
  `mesin` varchar(50) NOT NULL,
  `tahun` varchar(10) NOT NULL,
  `kapasitas` varchar(50) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 1,
  `keterangan` text NOT NULL,
  `gambar_utama` text NOT NULL,
  `category` varchar(50) NOT NULL,
  `transmisi` varchar(50) NOT NULL DEFAULT 'Otomatis',
  `rating` decimal(3,2) NOT NULL DEFAULT 4.80,
  `aktif` tinyint(1) NOT NULL DEFAULT 1,
  `hits` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------
-- 3. Table `drivers` (Menyimpan Informasi Lengkap Supir)
-- ----------------------------------------------------------
CREATE TABLE `drivers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  `jenis_kelamin` enum('Laki-laki', 'Perempuan') NOT NULL DEFAULT 'Laki-laki',
  `tempat_lahir` varchar(50) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `alamat` text NOT NULL,
  `keterangan` text NOT NULL,
  `foto` text NOT NULL,
  `rating` decimal(3,2) NOT NULL DEFAULT 4.90,
  `total_perjalanan` int(11) NOT NULL DEFAULT 0,
  `tersedia` tinyint(1) NOT NULL DEFAULT 1,
  `status_ketersediaan` enum('Tersedia', 'Dalam Perjalanan', 'Istirahat') NOT NULL DEFAULT 'Tersedia',
  `no_hp` varchar(25) NOT NULL,
  `no_sim` varchar(50) NOT NULL DEFAULT 'SIM A & B1 Umum',
  `user_id` varchar(50) DEFAULT NULL,
  `is_aktif` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_drivers_user` (`user_id`),
  CONSTRAINT `fk_drivers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------
-- 4. Table `bookings` (Menyimpan Data Pemesanan Mobil/Tiket)
-- ----------------------------------------------------------
CREATE TABLE `bookings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kode_orders` varchar(50) NOT NULL UNIQUE,
  `user_id` varchar(50) DEFAULT NULL,
  `nama_pemesan` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `no_telpon` varchar(25) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `jemput` varchar(255) NOT NULL,
  `tujuan` varchar(255) NOT NULL,
  `status` enum('Pending', 'Proses', 'Selesai', 'Dibatalkan') NOT NULL DEFAULT 'Pending',
  `waktu` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `car_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `pakai_sopir` tinyint(1) NOT NULL DEFAULT 0,
  `dari_tanggal` date NOT NULL,
  `sampai_tanggal` date NOT NULL,
  `sewa_perhari` int(11) NOT NULL,
  `total_hari` int(11) NOT NULL DEFAULT 1,
  `total_harga` int(11) NOT NULL,
  `bank_pembayaran` varchar(100) NOT NULL DEFAULT 'BCA (0320943647 a/n Robby Prihandaya)',
  `is_ticket` tinyint(1) NOT NULL DEFAULT 0,
  `ticket_title` varchar(150) DEFAULT NULL,
  `driver_task_status` enum('Menunggu Konfirmasi', 'Diterima', 'Dalam Perjalanan', 'Perjalanan Selesai', 'Ditolak') NOT NULL DEFAULT 'Menunggu Konfirmasi',
  `payment_status` enum('Menunggu Verifikasi', 'Lunas', 'Ditolak') NOT NULL DEFAULT 'Menunggu Verifikasi',
  `bukti_pembayaran` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_bookings_user` (`user_id`),
  KEY `fk_bookings_car` (`car_id`),
  KEY `fk_bookings_driver` (`driver_id`),
  CONSTRAINT `fk_bookings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_bookings_car` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_bookings_driver` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------
-- 5. Table `transactions` (Menyimpan Pembayaran & Verifikasi)
-- ----------------------------------------------------------
CREATE TABLE `transactions` (
  `id` varchar(50) NOT NULL,
  `order_id` int(11) NOT NULL,
  `order_code` varchar(50) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `total_amount` int(11) NOT NULL,
  `payment_method` varchar(100) NOT NULL,
  `status` enum('Menunggu Verifikasi', 'Lunas', 'Ditolak') NOT NULL DEFAULT 'Menunggu Verifikasi',
  `proof_image_url` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `transaction_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `verified_by` varchar(50) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_trans_booking` (`order_id`),
  CONSTRAINT `fk_trans_booking` FOREIGN KEY (`order_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------
-- 6. Table `driver_assignments` (Menyimpan Penugasan Supir)
-- ----------------------------------------------------------
CREATE TABLE `driver_assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `assigned_by` varchar(50) NOT NULL DEFAULT 'admin',
  `status_tugas` enum('Menunggu Konfirmasi', 'Diterima', 'Dalam Perjalanan', 'Perjalanan Selesai', 'Ditolak') NOT NULL DEFAULT 'Menunggu Konfirmasi',
  `catatan` text DEFAULT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_assign_order` (`order_id`),
  KEY `fk_assign_driver` (`driver_id`),
  CONSTRAINT `fk_assign_order` FOREIGN KEY (`order_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_assign_driver` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================================
-- SEED DATA (Awal Sistem TripRent)
-- ==========================================================

-- Data Akun Pengguna (Admin, User, Driver)
INSERT INTO `users` (`id`, `username`, `email`, `password`, `nama_lengkap`, `no_telp`, `foto`, `level`, `role`, `status`, `driver_id`) VALUES
('admin-1', 'admin', 'admin@triprent.com', 'admin123', 'Administrator TripRent', '0812-8694-3954', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80', 'Super Admin', 'admin', 'aktif', NULL),
('user-1', 'user', 'user@triprent.com', 'password123', 'Rahmat Hidayat', '0812-3456-7890', 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80', 'VIP Member', 'user', 'aktif', NULL),
('driver-1', 'driver', 'driver@triprent.com', 'driver123', 'Robby Prihandaya', '0812-6777-1344', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80', 'Senior Driver', 'driver', 'aktif', 1),
('driver-2', 'driver_budi', 'budi@triprent.com', 'driver123', 'Pak Budi Hartono', '0813-8899-2311', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80', 'Pariwisata Driver', 'driver', 'aktif', 2),
('user-2', 'dewiit', 'dewiit.safitri@gmail.com', 'password123', 'Dewiit Safitri', '0852-3456-9988', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80', 'Gold Member', 'user', 'aktif', NULL);

-- Data Supir
INSERT INTO `drivers` (`id`, `nama`, `jenis_kelamin`, `tempat_lahir`, `tanggal_lahir`, `alamat`, `keterangan`, `foto`, `rating`, `total_perjalanan`, `tersedia`, `status_ketersediaan`, `no_hp`, `no_sim`, `user_id`, `is_aktif`) VALUES
(1, 'Robby Prihandaya', 'Laki-laki', 'Padang', '1989-05-06', 'Jl. Angkasa Puri, Perundam 4, Tunggul Hitam, Padang', 'Driver senior berlisensi SIM A & B1 Umum. Sangat ramah, menguasai seluruh rute wisata Sumatera Barat, Riau, dan Tol Trans Jawa.', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80', 4.98, 245, 1, 'Tersedia', '0812-6777-1344', 'SIM A & B1 Umum (No. 890512345)', 'driver-1', 1),
(2, 'Pak Budi Hartono', 'Laki-laki', 'Solo', '1985-08-14', 'Jl. Khatib Sulaiman No. 28, Padang Utara', 'Spesialis pengemudi armada HiAce dan Elf Microbus pariwisata. Mengutamakan ketepatan waktu, keselamatan berkendara, dan kabin bebas rokok.', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80', 4.92, 198, 1, 'Dalam Perjalanan', '0813-8899-2311', 'SIM B1 Umum (No. 850811902)', 'driver-2', 1),
(3, 'Dewiit Safitri', 'Perempuan', 'Payakumbuh', '1989-02-12', 'Jl. Linggar Jati 2, Perupuk Tabing, Padang', 'Driver berpengalaman untuk perjalanan keluarga, ibu & anak, serta tamu VIP. Sangat teliti, sopan, dan menjaga kebersihan armada.', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80', 4.95, 168, 1, 'Tersedia', '0852-3456-9988', 'SIM A (No. 890214887)', NULL, 1),
(4, 'Pak Yanto Supriyadi', 'Laki-laki', 'Bandung', '1982-11-20', 'Jl. Veteran No. 15, Padang Barat', 'Driver handal bersertifikat Defensive Driving. Berpengalaman 15 tahun membawa rombongan tour antar kota dan kawasan pegunungan terjal.', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80', 4.89, 215, 0, 'Istirahat', '0821-4567-8890', 'SIM B1 Umum (No. 821109765)', NULL, 1);

-- Data Mobil
INSERT INTO `cars` (`id`, `nama`, `nama_seo`, `harga_sewa`, `harga_sopir`, `durasi`, `termasuk`, `mesin`, `tahun`, `kapasitas`, `stok`, `keterangan`, `gambar_utama`, `category`, `transmisi`, `rating`, `aktif`, `hits`) VALUES
(1, 'Toyota All New Avanza', 'toyota-all-new-avanza', 350000, 150000, 1, 'Mobil Saja', '1500 cc Dual VVT-i', '2023', '7 Orang', 5, 'Mobil rental terfavorit keluarga Indonesia. Kabin lega 7 penumpang, AC double blower dingin merata, suspensi nyaman.', 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80', 'Mobil Keluarga (7 Kursi)', 'Otomatis CVT', 4.90, 1, 240),
(2, 'Toyota Innova Reborn', 'toyota-innova-reborn', 550000, 150000, 1, 'Mobil Saja', '2400 cc 2GD Turbo Diesel', '2022', '7-8 Orang', 4, 'Standar emas armada travel dan rental eksekutif di Indonesia. Mesin diesel tangguh melibas tanjakan perbukitan.', 'https://images.unsplash.com/photo-1550355291-bbee04a92027?auto=format&fit=crop&w=800&q=80', 'Eksekutif & Nyaman', 'Otomatis', 4.95, 1, 310),
(3, 'Toyota All New Rush', 'toyota-all-new-rush', 400000, 150000, 1, 'Mobil Saja', '1500 cc DOHC Dual VVT-i', '2023', '7 Orang', 4, 'SUV keluarga tangguh dengan ground clearance tinggi (220 mm). Siap melibas berbagai medan jalan ke destinasi wisata alam.', 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=800&q=80', 'Tangguh Segala Medan', 'Otomatis', 4.85, 1, 195),
(4, 'Toyota HiAce Premio', 'toyota-hiace-premio', 1200000, 200000, 1, 'Mobil + Sopir', '2800 cc 1GD-FTV Diesel Turbo', '2023', '12-14 Orang', 3, 'Minibus van mewah pilihan utama rombongan travel wisata dan antar-jemput bandara VIP. Kursi reclining lebar.', 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=800&q=80', 'Rombongan (12-19 Kursi)', 'Manual 6-Speed', 5.00, 1, 280),
(5, 'Isuzu Elf Long Microbus', 'isuzu-elf-long-microbus', 1100000, 200000, 1, 'Mobil + Sopir', '2771 cc 4JB1-TC Turbo', '2022', '19 Orang', 3, 'Microbus berkapasitas besar hingga 19 penumpang, sangat populer untuk study tour, gathering kantor, ziarah.', 'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=800&q=80', 'Rombongan (12-19 Kursi)', 'Manual 5-Speed', 4.80, 1, 210),
(6, 'Mitsubishi Pajero Sport Dakar', 'mitsubishi-pajero-sport-dakar', 1100000, 200000, 1, 'Mobil Saja', '2400 cc MIVEC Turbo Diesel', '2023', '7 Orang', 2, 'Big SUV prestisius berkarakter gagah dan bertenaga besar. Pilihan utama dinas instansi, kunjungan proyek.', 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80', 'Tangguh Segala Medan', 'Otomatis 8-Speed', 4.90, 1, 160),
(7, 'Honda Brio RS', 'honda-brio-rs', 300000, 150000, 1, 'Mobil Saja', '1200 cc i-VTEC', '2023', '5 Orang', 4, 'City car lincah, stylish, dan irit bahan bakar untuk mobilitas praktis di perkotaan.', 'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80', 'Hemat & Lincah (5 Kursi)', 'CVT Otomatis', 4.80, 1, 180);

-- Data Pemesanan
INSERT INTO `bookings` (`id`, `kode_orders`, `user_id`, `nama_pemesan`, `email`, `no_telpon`, `keterangan`, `jemput`, `tujuan`, `status`, `car_id`, `driver_id`, `pakai_sopir`, `dari_tanggal`, `sampai_tanggal`, `sewa_perhari`, `total_hari`, `total_harga`, `bank_pembayaran`, `is_ticket`, `ticket_title`, `driver_task_status`, `payment_status`) VALUES
(10, 'TRX-20260802090405', 'user-1', 'Rahmat Hidayat', 'user@triprent.com', '0812-3456-7890', 'Kunjungan dinas instansi ke Bukittinggi dan Payakumbuh.', 'Bandara Internasional Minangkabau (BIM)', 'Bukittinggi & Payakumbuh', 'Proses', 2, 1, 1, '2026-11-19', '2026-11-21', 550000, 2, 1400000, 'BANK BCA (0320943647 a/n Robby Prihandaya)', 0, NULL, 'Dalam Perjalanan', 'Lunas'),
(11, 'TRX-20261119091200', 'user-2', 'Dewiit Safitri', 'dewiit.safitri@gmail.com', '0852-3456-9988', 'Penjemputan hotel untuk acara keluarga di Danau Singkarak.', 'Hotel Grand Zuri Padang', 'Danau Singkarak & Solok', 'Pending', 1, 1, 1, '2026-11-20', '2026-11-21', 350000, 1, 500000, 'BANK BCA (0320943647 a/n Robby Prihandaya)', 0, NULL, 'Menunggu Konfirmasi', 'Menunggu Verifikasi'),
(14, 'TRX-20260223090148', 'user-1', 'Rahmat Hidayat', 'user@triprent.com', '0812-3456-7890', 'Pemesanan lepas kunci untuk silaturahmi keluarga.', 'Jl. Linggar Jati 2, Padang', 'Kota Solok & Danau Singkarak', 'Proses', 1, NULL, 0, '2026-02-23', '2026-02-25', 350000, 2, 700000, 'BANK BCA (0320943647 a/n Robby Prihandaya)', 0, NULL, 'Menunggu Konfirmasi', 'Lunas'),
(7, 'TRX-20260627061400', 'user-1', 'Rahmat Hidayat', 'user@triprent.com', '0812-3456-7890', 'Antar jemput rombongan tamu VIP dari bandara ke hotel.', 'Bandara Internasional Minangkabau (BIM)', 'Hotel Grand Zuri Padang', 'Selesai', 4, 1, 1, '2026-06-27', '2026-06-28', 1200000, 1, 1400000, 'BANK BCA (0320943647 a/n Robby Prihandaya)', 0, NULL, 'Perjalanan Selesai', 'Lunas'),
(15, 'TRX-20260223090509', 'user-2', 'Muhammad Arsenio', 'muhammad.arsenio@gmail.com', '088812445677', 'Penyewaan weekend trip ke Pantai Carocok Painan.', 'Jl. Gumarang Jaya No. 8', 'Pantai Carocok Painan', 'Pending', 3, 2, 1, '2026-02-23', '2026-02-25', 400000, 2, 800000, 'BANK BRI (547601016142539 a/n Robby Prihandaya)', 0, NULL, 'Diterima', 'Menunggu Verifikasi');

-- Data Transaksi
INSERT INTO `transactions` (`id`, `order_id`, `order_code`, `customer_name`, `item_name`, `total_amount`, `payment_method`, `status`, `transaction_date`) VALUES
('TXN-10', 10, 'TRX-20260802090405', 'Rahmat Hidayat', 'Toyota Innova Reborn', 1400000, 'BANK BCA', 'Lunas', CURRENT_TIMESTAMP),
('TXN-11', 11, 'TRX-20261119091200', 'Dewiit Safitri', 'Toyota All New Avanza', 500000, 'BANK BCA', 'Menunggu Verifikasi', CURRENT_TIMESTAMP),
('TXN-14', 14, 'TRX-20260223090148', 'Rahmat Hidayat', 'Toyota All New Avanza', 700000, 'BANK BCA', 'Lunas', '2026-02-23 09:01:48'),
('TXN-7', 7, 'TRX-20260627061400', 'Rahmat Hidayat', 'Toyota HiAce Premio', 1400000, 'BANK BCA', 'Lunas', '2026-06-27 06:14:00'),
('TXN-15', 15, 'TRX-20260223090509', 'Muhammad Arsenio', 'Toyota All New Rush', 800000, 'BANK BRI', 'Menunggu Verifikasi', '2026-02-23 09:05:09');

-- Data Penugasan Supir
INSERT INTO `driver_assignments` (`id`, `order_id`, `driver_id`, `assigned_by`, `status_tugas`, `catatan`) VALUES
(1, 10, 1, 'admin', 'Dalam Perjalanan', 'Penjemputan bandara penerbangan pagi. Pastikan kendaraan bersih.'),
(2, 11, 1, 'admin', 'Menunggu Konfirmasi', 'Tamu VIP keluarga, mohon konfirmasi ketersediaan.'),
(3, 7, 1, 'admin', 'Perjalanan Selesai', 'Rombongan tamu VIP telah diantar ke hotel dengan aman.'),
(4, 15, 2, 'admin', 'Diterima', 'Pak Budi telah menyetujui penugasan perjalanan Painan.');
