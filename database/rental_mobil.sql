-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 30 Sep 2026 pada 08.58
-- Versi server: 10.1.38-MariaDB
-- Versi PHP: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rental_mobil`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `background`
--

CREATE TABLE `background` (
  `id_background` int(5) NOT NULL,
  `gambar` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `background`
--

INSERT INTO `background` (`id_background`, `gambar`) VALUES
(1, 'black');

-- --------------------------------------------------------

--
-- Struktur dari tabel `halamanstatis`
--

CREATE TABLE `halamanstatis` (
  `id_halaman` int(5) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `judul_seo` varchar(100) NOT NULL,
  `isi_halaman` text NOT NULL,
  `tgl_posting` date NOT NULL,
  `gambar` varchar(100) NOT NULL,
  `username` varchar(50) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `dibaca` int(5) NOT NULL DEFAULT '1',
  `jam` time NOT NULL,
  `hari` varchar(20) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `halamanstatis`
--

INSERT INTO `halamanstatis` (`id_halaman`, `judul`, `judul_seo`, `isi_halaman`, `tgl_posting`, `gambar`, `username`, `dibaca`, `jam`, `hari`) VALUES
(46, 'Tentang Kami Luxury Rent a Car', 'tentang-kami-luxury-rent-a-car', '<p>Salah satu perusahaan layanan transportasi di Jakarta yang menyediakan jasa&nbsp;<strong>penyewaan kendaraan serta layanan pengemudi</strong>. Kami adalah penyedia jasa rental mobil di Jakarta dengan pengalaman lebih dari 5 tahun di bidang sewa kendaraan, kami telah melayani berbagai perusahaan nasional maupun multi nasional, hotel, perbankan, event organizer, traveling dan para pribadi untuk kepentingan UKM maupun keluarga.&nbsp; Yang semoga dapat mempermudah mobilitas &nbsp;dengan &nbsp;fasilitas armada yang bersih dan terawat,&nbsp; didukung oleh supir yang berpengalaman baik dibidangnya mengetahui jalan&ndash;jalan di jakarta maupun luar kota dengan harga yang variatif dan kompetitif tanpa mengurangi mutu dan pelayanan.<br />\r\n&nbsp;</p>\r\n\r\n<h3><strong>TITIP KENDARAAN</strong></h3>\r\n\r\n<p><strong>Luxury Rent a Car&nbsp;</strong>merupakan salah satu rental di jakarta yang sedang berkembang, hal ini ditandai dengan semakin meningkatnya pelanggan yang memakai jasa Obet Rent Car.</p>\r\n\r\n<p>Melalui info ini kami menawarkan kerja sama yang saling menguntungkan, yaitu membuka penitipan kendaraan untuk disewakan. Adapun jenis kendaraan yang kami butuhkan saat ini yaitu :</p>\r\n\r\n<ul>\r\n	<li>New Avanza</li>\r\n	<li>K Grand Innova</li>\r\n	<li>Yaris</li>\r\n	<li>Fortuner</li>\r\n	<li>Camry</li>\r\n	<li>Rush</li>\r\n	<li>Daihatsu New Xenia</li>\r\n	<li>Daihatsu Terios</li>\r\n	<li>Mobilio</li>\r\n	<li>Jazz</li>\r\n	<li>Suzuki APV</li>\r\n	<li>Suzuki Ertiga</li>\r\n</ul>\r\n\r\n<p>Kami akan membuatkan kontrak perjanjian sewa-menyewa Member (Penitip Kendaraan) dengan kami Luxury Rent a Car (Pengelola Kendaraan). Adapun nilai kontrak bergantung pada jenis dan tahun kendaraan yang dititipkan member kepada kami, batas usia kendaraan minimal tahun 2013 &ndash; 2016 di cover dengan jaminan asuransi All Risk. Masa kontrak yang kami buat minimal 1 (Satu) Tahun.</p>\r\n\r\n<p><strong>Mengapa harus menitipkan kendaraan pada Luxury Rent a Car?</strong></p>\r\n\r\n<ul>\r\n	<li>Mendapat pendapatan tambahan</li>\r\n	<li>Tidak perlu repot bekerja untuk mencari uang, biarlah mobil anda yang bekerja untuk kita</li>\r\n	<li>Anda tidak perlu menggaji karyawan dan melakukan survey penyewa</li>\r\n	<li>Urusan perawatan kendaraan anda menjadi tanggung jawab kami</li>\r\n	<li>Mendapat pendapatan tetap dari kendaraan yang di titipkan di rental selama kontrak berjalan</li>\r\n	<li>Kode etik dan kerahasiaan mitra usaha terjamin</li>\r\n	<li>Berpengalaman lebih dari 5 tahun dalam bidang jasa sewa kendaraan</li>\r\n	<li>Mempunyai jaringan rekanan rental mobil yang luas</li>\r\n	<li>GPS System dengan server terpusat</li>\r\n	<li>Prioritas untuk sewa bulanan sehingga mobil lebih awet dan terjaga</li>\r\n	<li>Target market perusahaan dan kalangan menengah keatas</li>\r\n	<li>Service &amp; Maintenance kendaraan berpengalaman</li>\r\n	<li>Fleksibel</li>\r\n</ul>\r\n\r\n<p><strong>Prosedur Syarat dan Ketentuan :</strong></p>\r\n\r\n<ul>\r\n	<li>Kami akan memberikan penjelasan/gambaran umum tentang ilustrasi bisnis rental mobil.</li>\r\n	<li>Calon member dimintai data FC. KTP dan FC. Polis Asuransi All Risk Kendaraan</li>\r\n	<li>Kami buatkan kontrak perjanjian sewa antara member dengan kami setelah ada kesepakatan.</li>\r\n	<li>Melakukan penandatanganan kontrak perjanjian sewa-menyewa dihadapan kedua belah pihak.</li>\r\n</ul>\r\n', '2014-04-07', '', 'admin', 81, '13:10:57', 'Senin'),
(48, 'Syarat dan Ketentuan', 'syarat-dan-ketentuan', '<h3><strong>PENYEWA DENGAN DRIVER</strong></h3>\r\n\r\n<ul>\r\n	<li>Melakukan Booking kendaraan</li>\r\n	<li>Melampirkan FC. &nbsp;KTP (Bersedia menunjukkan Aslinya)</li>\r\n	<li>Hitungan sewa kendaraan adalah 12 jam</li>\r\n	<li>Memberikan informasikan alamat lengkap penjemputan + No. telp dan rute perjalanan saat booking</li>\r\n	<li>Tidak diwajibkan melengkapi persyaratan sewa kendaraan</li>\r\n</ul>\r\n\r\n<h3><strong>PENYEWA LEPAS KUNCI DOMISILI JABODETABEK</strong></h3>\r\n\r\n<p><strong>SYARAT UNTUK PERORANGAN</strong></p>\r\n\r\n<ol>\r\n	<li><strong>Pelajar Mahasiswa</strong></li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>Melakukan Booking kendaraan</li>\r\n	<li>FC. &nbsp;KTP (Bersedia menunjukkan Aslinya)</li>\r\n	<li>FC. Kartu Pelajar&nbsp;(Bersedia menunjukkan Aslinya)</li>\r\n	<li>FC. SIM A&nbsp;(Bersedia menunjukkan Aslinya)</li>\r\n	<li>FC. KTP+Kartu Keluarga Orang Tua&nbsp;(Bersedia menunjukkan Aslinya)</li>\r\n	<li>Diwajibkan melengkapi persyaratan dan mengisi formulir sewa kendaraan</li>\r\n	<li>Deposit/ Uang Jaminan Rp 500.000 (Dikembalikan lagi setelah pemakaian sewa selesai)</li>\r\n	<li>Bersedia untuk disurvei</li>\r\n</ul>\r\n\r\n<ol start=\"2\">\r\n	<li><strong>Belum Berkeluarga</strong></li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>Melakukan Booking kendaraan</li>\r\n	<li>KTP&nbsp;(Bersedia menunjukkan Aslinya)</li>\r\n	<li>NPWP&nbsp;(Bersedia menunjukkan Aslinya)</li>\r\n	<li>SIM A&nbsp;(Bersedia menunjukkan Aslinya)</li>\r\n	<li>ID CARD tempat bekerja&nbsp;(Asli)</li>\r\n	<li>Diwajibkan melengkapi persyaratan dan mengisi formulir sewa kendaraan</li>\r\n	<li>Deposit/ Uang Jaminan Rp 500.000 (Dikembalikan lagi setelah pemakaian sewa selesai)</li>\r\n	<li>Bersedia untuk disurvei</li>\r\n</ul>\r\n\r\n<ol start=\"3\">\r\n	<li><strong>Sudah Berkeluarga</strong></li>\r\n</ol>\r\n\r\n<ul>\r\n	<li>Melakukan Booking kendaraan</li>\r\n	<li>KTP Suami dan Istri&nbsp;(Bersedia menunjukkan Aslinya)</li>\r\n	<li>Kartu Keluarga&nbsp;(Bersedia menunjukkan Aslinya)</li>\r\n	<li>Buku Nikah&nbsp;(Asli)</li>\r\n	<li>NPWP Suami dan Istri&nbsp;(Asli)</li>\r\n	<li>Diwajibkan melengkapi persyaratan dan mengisi formulir sewa kendaraan</li>\r\n	<li>Deposit/ Uang Jaminan Rp 500.000 (Dikembalikan lagi setelah pemakaian sewa selesai)</li>\r\n	<li>SIM A (Bersedia menunjukkan Aslinya)</li>\r\n	<li>Bersedia untuk disurvei</li>\r\n</ul>\r\n\r\n<h3><strong>SYARAT UNTUK PERUSAHAAN</strong></h3>\r\n\r\n<ul>\r\n	<li>Melakukan Booking kendaraan</li>\r\n	<li>FC : Akte Pendirian, SIUP, TDP, NPWP, HO, Domisili Perusahaan (menunjukkan aslinya)</li>\r\n	<li>FC : KTP pengguna dan KTP Direktur Perusahaan (menunjukkan aslinya)</li>\r\n	<li>FC : SIM A, Rekening Listrik, Rekening Telepon</li>\r\n	<li>Diwajibkan melengkapi persyaratan dan mengisi formulir sewa kendaraan</li>\r\n	<li>Deposit/ Uang jaminan Rp 500.000 (Dikembalikan lagi setelah pemakaian sewa selesai)</li>\r\n</ul>\r\n\r\n<h3><strong>FOREIGNER (Orang Asing)</strong></h3>\r\n\r\n<ul>\r\n	<li>National ID card</li>\r\n	<li>Passport</li>\r\n	<li>Copy of Driving Licenses</li>\r\n	<li>KITAP or KITAS Document</li>\r\n	<li>Guarantee Deposit (500.000 IDR)(Dikembalikan lagi setelah pemakaian sewa selesai)</li>\r\n</ul>\r\n', '2014-04-07', '', 'admin', 49, '13:32:28', 'Senin');

-- --------------------------------------------------------

--
-- Struktur dari tabel `hubungi`
--

CREATE TABLE `hubungi` (
  `id_hubungi` int(5) NOT NULL,
  `nama` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `email` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `subjek` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `pesan` text COLLATE latin1_general_ci NOT NULL,
  `tanggal` date NOT NULL,
  `jam` time NOT NULL,
  `dibaca` enum('Y','N') COLLATE latin1_general_ci NOT NULL DEFAULT 'N'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data untuk tabel `hubungi`
--

INSERT INTO `hubungi` (`id_hubungi`, `nama`, `email`, `subjek`, `pesan`, `tanggal`, `jam`, `dibaca`) VALUES
(39, 'Robby Prihandaya', 'robby.prihandaya@gmail.com', '::1', 'Kami memiliki komitmen untuk memberikan layanan terbaik kepada Anda dan selalu berusaha untuk menyediakan produk dan layanan terbaik yang Anda butuhkan. Apabila untuk alasan tertentu Anda merasa tidak puas dengan pelayanan kami, Anda dapat menyampaikan kritik dan saran Anda kepada kami. Kami akan menidaklanjuti masukan yang Anda berikan dan bila perlu mengambil tindakan untuk mencegah masalah yang sama terulang kembali.', '2017-01-23', '21:56:12', 'Y'),
(35, 'yusri renor', 'aciafifah@gmail.com', 'pertanyaan', 'bagaimana cara mengunduh nomor ujian fak. pertanian', '2014-01-19', '00:00:00', 'Y'),
(36, 'Lusi Rahmawati', 'robby.prihandaya@gmail.com', 'xvgxcvxc', 'gbvibviubuibiub', '2014-07-02', '00:00:00', 'Y'),
(38, 'Udin Sedunia', 'udin.sedunia@gmail.com', 'Ip Pengirim : 120.177.28.244', 'Silahkan menghubungi kami melalui private message melalui form yang berada pada bagian kanan halaman ini. Kritik dan saran Anda sangat penting bagi kami untuk terus meningkatkan kualitas produk dan layanan yang kami berikan kepada Anda.', '2015-06-02', '00:00:00', 'Y'),
(40, 'Robby Prihandaya', 'robby.prihandaya@gmail.com', '::1', 'Kami memiliki komitmen untuk memberikan layanan terbaik kepada Anda dan selalu berusaha untuk menyediakan produk dan layanan terbaik yang Anda butuhkan. Apabila untuk alasan tertentu Anda merasa tidak puas dengan pelayanan kami, Anda dapat menyampaikan kritik dan saran Anda kepada kami. Kami akan menidaklanjuti masukan yang Anda berikan dan bila perlu mengambil tindakan untuk mencegah masalah yang sama terulang kembali.', '2017-01-25', '09:54:45', 'N');

-- --------------------------------------------------------

--
-- Struktur dari tabel `identitas`
--

CREATE TABLE `identitas` (
  `id_identitas` int(5) NOT NULL,
  `nama_website` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `url` varchar(100) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `facebook` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `rekening` varchar(100) NOT NULL,
  `no_telp` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `meta_deskripsi` varchar(250) NOT NULL,
  `meta_keyword` varchar(250) NOT NULL,
  `favicon` varchar(50) NOT NULL,
  `maps` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `identitas`
--

INSERT INTO `identitas` (`id_identitas`, `nama_website`, `email`, `url`, `facebook`, `rekening`, `no_telp`, `meta_deskripsi`, `meta_keyword`, `favicon`, `maps`) VALUES
(1, 'Selamat datang di website Rental Mobil Online', 'robby.prihandaya@gmail.com', 'http://localhost/rental', 'https://www.facebook.com/robbyprihandaya, https://twitter.com/robbyprihandaya, https://plus.google.com/106633506064864167239, https://id.linkedin.com/', '3511887071', '081267771344', 'Rental dan sewa mobil murah sehari dan seminggu di Payakumbuh, Padang, Bukittinggi, Jakarta, Bandung, Bontang, Semarang, Balikpapan, Surabaya, Yogyakarta, dan Bali.', 'rental mobil, harian, mingguan, murah, berkualitas, pelayanan terbaik', 'favicon1.png', 'https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d3989.3358607198243!2d100.35483479999999!3d-0.8910373999999999!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2fd4b8aa1a4e0441%3A0x3f81ebb48d31a38b!2sTunggul+Hitam%2C+Padang+Utara%2C+Kota+Padang%2C+Sumatera+Barat+25173!5e0!3m2!1sid!2sid!4v1408275531365');

-- --------------------------------------------------------

--
-- Struktur dari tabel `logo`
--

CREATE TABLE `logo` (
  `id_logo` int(5) NOT NULL,
  `gambar` varchar(100) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data untuk tabel `logo`
--

INSERT INTO `logo` (`id_logo`, `gambar`) VALUES
(15, 'logo.png');

-- --------------------------------------------------------

--
-- Struktur dari tabel `menu`
--

CREATE TABLE `menu` (
  `id_menu` int(5) NOT NULL,
  `id_parent` int(5) NOT NULL DEFAULT '0',
  `nama_menu` varchar(30) NOT NULL,
  `link` varchar(100) NOT NULL,
  `aktif` enum('Ya','Tidak') NOT NULL DEFAULT 'Ya',
  `position` enum('Top','Bottom') DEFAULT 'Bottom',
  `urutan` int(3) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `menu`
--

INSERT INTO `menu` (`id_menu`, `id_parent`, `nama_menu`, `link`, `aktif`, `position`, `urutan`) VALUES
(7, 0, 'Home Page', 'main', 'Ya', 'Bottom', 1),
(19, 0, 'Layanan dan Reservasi', 'mobil', 'Ya', 'Bottom', 4),
(113, 0, 'Tentang Kami', 'halaman/detail/tentang-kami-luxury-rent-a-car', 'Ya', 'Bottom', 2),
(115, 0, 'Syarat dan Ketentuan', 'halaman/detail/syarat-dan-ketentuan', 'Ya', 'Bottom', 3),
(116, 0, 'Hubungi Kami', 'hubungi', 'Ya', 'Bottom', 7);

-- --------------------------------------------------------

--
-- Struktur dari tabel `mobil`
--

CREATE TABLE `mobil` (
  `id_mobil` int(5) NOT NULL,
  `nama_mobil` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `nama_mobil_seo` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `harga_sewa` int(11) NOT NULL,
  `harga_sopir` int(11) NOT NULL,
  `durasi` int(11) NOT NULL,
  `termasuk` varchar(255) COLLATE latin1_general_ci NOT NULL,
  `mesin` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `tahun` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `kapasitas` varchar(255) COLLATE latin1_general_ci NOT NULL,
  `stok` int(11) NOT NULL,
  `keterangan` text COLLATE latin1_general_ci NOT NULL,
  `gambar_utama` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `aktif` enum('Y','N') COLLATE latin1_general_ci NOT NULL DEFAULT 'Y',
  `hits` int(5) NOT NULL DEFAULT '1',
  `tgl_posting` date NOT NULL,
  `jam` time NOT NULL,
  `hari` varchar(20) COLLATE latin1_general_ci NOT NULL,
  `username` varchar(50) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data untuk tabel `mobil`
--

INSERT INTO `mobil` (`id_mobil`, `nama_mobil`, `nama_mobil_seo`, `harga_sewa`, `harga_sopir`, `durasi`, `termasuk`, `mesin`, `tahun`, `kapasitas`, `stok`, `keterangan`, `gambar_utama`, `aktif`, `hits`, `tgl_posting`, `jam`, `hari`, `username`) VALUES
(30, 'Bentley Phantom', 'bentley-phantom', 250000, 105000, 2, 'Mobil + BBM', '3500 cc', '2017', '5 Orang', 1, '<p><strong>Lorem Ipsum</strong>&nbsp;adalah contoh teks atau dummy dalam industri percetakan dan penataan huruf atau typesetting. Lorem Ipsum telah menjadi standar contoh teks sejak tahun 1500an, saat seorang tukang cetak yang tidak dikenal mengambil sebuah kumpulan teks dan mengacaknya untuk menjadi sebuah buku contoh huruf. Ia tidak hanya bertahan selama 5 abad, tapi juga telah beralih ke penataan huruf elektronik, tanpa ada perubahan apapun. Ia mulai dipopulerkan pada tahun 1960 dengan diluncurkannya lembaran-lembaran Letraset yang menggunakan kalimat-kalimat dari Lorem Ipsum, dan seiring munculnya perangkat lunak Desktop Publishing seperti Aldus PageMaker juga memiliki versi Lorem Ipsum.</p>\r\n\r\n<h2>Mengapa kita menggunakannya?</h2>\r\n\r\n<p>Sudah merupakan fakta bahwa seorang pembaca akan terpengaruh oleh isi tulisan dari sebuah halaman saat ia melihat tata letaknya. Maksud penggunaan Lorem Ipsum adalah karena ia kurang lebih memiliki penyebaran huruf yang normal, ketimbang menggunakan kalimat seperti &quot;Bagian isi disini, bagian isi disini&quot;, sehingga ia seolah menjadi naskah Inggris yang bisa dibaca. Banyak paket Desktop Publishing dan editor situs web yang kini menggunakan Lorem Ipsum sebagai contoh teks. Karenanya pencarian terhadap kalimat &quot;Lorem Ipsum&quot; akan berujung pada banyak situs web yang masih dalam tahap pengembangan. Berbagai versi juga telah berubah dari tahun ke tahun, kadang karena tidak sengaja, kadang karena disengaja (misalnya karena dimasukkan unsur humor atau semacamnya)</p>\r\n\r\n<div style=\"background-color:#ffffff; border:medium none; color:#000000; overflow:hidden; text-align:left; text-decoration:none\">&nbsp;</div>\r\n', 'mobil4a.jpg', 'Y', 28, '2012-08-20', '09:12:06', 'Senin', 'admin'),
(31, 'Excepteur Sint', 'excepteur-sint', 300000, 100000, 1, 'Mobil + BBM', '5500 cc', '2015', '6 Orang', 1, '<p><strong>Lorem Ipsum</strong>&nbsp;adalah contoh teks atau dummy dalam industri percetakan dan penataan huruf atau typesetting. Lorem Ipsum telah menjadi standar contoh teks sejak tahun 1500an, saat seorang tukang cetak yang tidak dikenal mengambil sebuah kumpulan teks dan mengacaknya untuk menjadi sebuah buku contoh huruf. Ia tidak hanya bertahan selama 5 abad, tapi juga telah beralih ke penataan huruf elektronik, tanpa ada perubahan apapun. Ia mulai dipopulerkan pada tahun 1960 dengan diluncurkannya lembaran-lembaran Letraset yang menggunakan kalimat-kalimat dari Lorem Ipsum, dan seiring munculnya perangkat lunak Desktop Publishing seperti Aldus PageMaker juga memiliki versi Lorem Ipsum.</p>\r\n\r\n<h2>Mengapa kita menggunakannya?</h2>\r\n\r\n<p>Sudah merupakan fakta bahwa seorang pembaca akan terpengaruh oleh isi tulisan dari sebuah halaman saat ia melihat tata letaknya. Maksud penggunaan Lorem Ipsum adalah karena ia kurang lebih memiliki penyebaran huruf yang normal, ketimbang menggunakan kalimat seperti &quot;Bagian isi disini, bagian isi disini&quot;, sehingga ia seolah menjadi naskah Inggris yang bisa dibaca. Banyak paket Desktop Publishing dan editor situs web yang kini menggunakan Lorem Ipsum sebagai contoh teks. Karenanya pencarian terhadap kalimat &quot;Lorem Ipsum&quot; akan berujung pada banyak situs web yang masih dalam tahap pengembangan. Berbagai versi juga telah berubah dari tahun ke tahun, kadang karena tidak sengaja, kadang karena disengaja (misalnya karena dimasukkan unsur humor atau semacamnya)</p>\r\n', 'mobil3a.jpg', 'Y', 4, '2012-08-20', '09:40:01', 'Senin', 'admin'),
(28, 'Mobilo Espano Sportivo', 'mobilo-espano-sportivo', 350000, 125000, 1, 'Mobil + BBM', '6000 cc', '2014', '2 Orang', 1, '<p><strong>Lorem Ipsum</strong>&nbsp;adalah contoh teks atau dummy dalam industri percetakan dan penataan huruf atau typesetting. Lorem Ipsum telah menjadi standar contoh teks sejak tahun 1500an, saat seorang tukang cetak yang tidak dikenal mengambil sebuah kumpulan teks dan mengacaknya untuk menjadi sebuah buku contoh huruf. Ia tidak hanya bertahan selama 5 abad, tapi juga telah beralih ke penataan huruf elektronik, tanpa ada perubahan apapun. Ia mulai dipopulerkan pada tahun 1960 dengan diluncurkannya lembaran-lembaran Letraset yang menggunakan kalimat-kalimat dari Lorem Ipsum, dan seiring munculnya perangkat lunak Desktop Publishing seperti Aldus PageMaker juga memiliki versi Lorem Ipsum.</p>\r\n\r\n<h2>Mengapa kita menggunakannya?</h2>\r\n\r\n<p>Sudah merupakan fakta bahwa seorang pembaca akan terpengaruh oleh isi tulisan dari sebuah halaman saat ia melihat tata letaknya. Maksud penggunaan Lorem Ipsum adalah karena ia kurang lebih memiliki penyebaran huruf yang normal, ketimbang menggunakan kalimat seperti &quot;Bagian isi disini, bagian isi disini&quot;, sehingga ia seolah menjadi naskah Inggris yang bisa dibaca. Banyak paket Desktop Publishing dan editor situs web yang kini menggunakan Lorem Ipsum sebagai contoh teks. Karenanya pencarian terhadap kalimat &quot;Lorem Ipsum&quot; akan berujung pada banyak situs web yang masih dalam tahap pengembangan. Berbagai versi juga telah berubah dari tahun ke tahun, kadang karena tidak sengaja, kadang karena disengaja (misalnya karena dimasukkan unsur humor atau semacamnya)</p>\r\n', 'mobil6a.jpg', 'Y', 81, '2012-08-18', '23:14:05', 'Sabtu', 'admin'),
(29, 'Non Proident', 'non-proident', 200000, 145000, 1, 'Mobil + BBM', '4500 cc', '2007', '8 Orang', 1, '<p><strong>Lorem Ipsum</strong>&nbsp;adalah contoh teks atau dummy dalam industri percetakan dan penataan huruf atau typesetting. Lorem Ipsum telah menjadi standar contoh teks sejak tahun 1500an, saat seorang tukang cetak yang tidak dikenal mengambil sebuah kumpulan teks dan mengacaknya untuk menjadi sebuah buku contoh huruf. Ia tidak hanya bertahan selama 5 abad, tapi juga telah beralih ke penataan huruf elektronik, tanpa ada perubahan apapun. Ia mulai dipopulerkan pada tahun 1960 dengan diluncurkannya lembaran-lembaran Letraset yang menggunakan kalimat-kalimat dari Lorem Ipsum, dan seiring munculnya perangkat lunak Desktop Publishing seperti Aldus PageMaker juga memiliki versi Lorem Ipsum.</p>\r\n\r\n<h2>Mengapa kita menggunakannya?</h2>\r\n\r\n<p>Sudah merupakan fakta bahwa seorang pembaca akan terpengaruh oleh isi tulisan dari sebuah halaman saat ia melihat tata letaknya. Maksud penggunaan Lorem Ipsum adalah karena ia kurang lebih memiliki penyebaran huruf yang normal, ketimbang menggunakan kalimat seperti &quot;Bagian isi disini, bagian isi disini&quot;, sehingga ia seolah menjadi naskah Inggris yang bisa dibaca. Banyak paket Desktop Publishing dan editor situs web yang kini menggunakan Lorem Ipsum sebagai contoh teks. Karenanya pencarian terhadap kalimat &quot;Lorem Ipsum&quot; akan berujung pada banyak situs web yang masih dalam tahap pengembangan. Berbagai versi juga telah berubah dari tahun ke tahun, kadang karena tidak sengaja, kadang karena disengaja (misalnya karena dimasukkan unsur humor atau semacamnya)</p>\r\n', 'mobil5a.jpg', 'Y', 74, '2012-08-19', '03:02:27', 'Minggu', 'admin'),
(41, 'Occaecat Cupidatat', 'occaecat-cupidatat', 400000, 120000, 1, 'Mobil + BBM', '5000 cc', '2016', '1 Orang', 1, '<p><strong>Lorem Ipsum</strong>&nbsp;adalah contoh teks atau dummy dalam industri percetakan dan penataan huruf atau typesetting. Lorem Ipsum telah menjadi standar contoh teks sejak tahun 1500an, saat seorang tukang cetak yang tidak dikenal mengambil sebuah kumpulan teks dan mengacaknya untuk menjadi sebuah buku contoh huruf. Ia tidak hanya bertahan selama 5 abad, tapi juga telah beralih ke penataan huruf elektronik, tanpa ada perubahan apapun. Ia mulai dipopulerkan pada tahun 1960 dengan diluncurkannya lembaran-lembaran Letraset yang menggunakan kalimat-kalimat dari Lorem Ipsum, dan seiring munculnya perangkat lunak Desktop Publishing seperti Aldus PageMaker juga memiliki versi Lorem Ipsum.</p>\r\n\r\n<h2>Mengapa kita menggunakannya?</h2>\r\n\r\n<p>Sudah merupakan fakta bahwa seorang pembaca akan terpengaruh oleh isi tulisan dari sebuah halaman saat ia melihat tata letaknya. Maksud penggunaan Lorem Ipsum adalah karena ia kurang lebih memiliki penyebaran huruf yang normal, ketimbang menggunakan kalimat seperti &quot;Bagian isi disini, bagian isi disini&quot;, sehingga ia seolah menjadi naskah Inggris yang bisa dibaca. Banyak paket Desktop Publishing dan editor situs web yang kini menggunakan Lorem Ipsum sebagai contoh teks. Karenanya pencarian terhadap kalimat &quot;Lorem Ipsum&quot; akan berujung pada banyak situs web yang masih dalam tahap pengembangan. Berbagai versi juga telah berubah dari tahun ke tahun, kadang karena tidak sengaja, kadang karena disengaja (misalnya karena dimasukkan unsur humor atau semacamnya)</p>\r\n', 'mobil2a.jpg', 'Y', 195, '2012-08-18', '23:14:05', 'Sabtu', 'admin'),
(50, '  Sed Do Eiusmod Temporaa', '--sed-do-eiusmod-temporaa', 400000, 150000, 2, 'Mobil + BBM', '4000 cc', '2016', '4 Orang', 1, '<p><strong>Lorem Ipsum</strong>&nbsp;adalah contoh teks atau dummy dalam industri percetakan dan penataan huruf atau typesetting.</p>\r\n', 'mobil1aa.jpg', 'Y', 52, '2017-05-20', '23:46:54', 'Sabtu', 'admin'),
(51, 'Lamborghini Huracan', 'lamborghini-huracan', 600000, 250000, 1, 'Mobil Saja', '10000', '2018', '2 Orang', 3, '<p>Belum ada keterangan,..</p>\r\n', 'lamborgini.jpg', 'Y', 2, '2018-08-03', '09:26:52', 'Jumat', 'admin'),
(52, 'Lykan Hypersport', 'lykan-hypersport', 700000, 250000, 1, 'Mobil Saja', '11000', '2018', '2 Orang', 2, '<p>Belum ada keterangan,..</p>\r\n', 'Lykan.jpg', 'Y', 1, '2018-08-03', '09:29:57', 'Jumat', 'admin');

-- --------------------------------------------------------

--
-- Struktur dari tabel `mobil_detail`
--

CREATE TABLE `mobil_detail` (
  `id_mobil_detail` int(5) NOT NULL,
  `id_mobil` int(5) NOT NULL,
  `username` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `judul` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `judul_seo` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `keterangan` text COLLATE latin1_general_ci NOT NULL,
  `gbr_mobil` varchar(100) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data untuk tabel `mobil_detail`
--

INSERT INTO `mobil_detail` (`id_mobil_detail`, `id_mobil`, `username`, `judul`, `judul_seo`, `keterangan`, `gbr_mobil`) VALUES
(1, 50, 'admin', 'Bagian Depan', 'bagian-depan', '', 'depan.jpg'),
(2, 50, 'admin', 'Bagian Belakang', 'bagian-belakang', '', 'belakang.jpg'),
(3, 50, 'admin', 'Bagian Atas', 'bagian-atas', '', 'atas.jpg'),
(4, 50, 'admin', 'Bagian Dalam', 'bagian-dalam', '', 'dalam1.jpg');

-- --------------------------------------------------------

--
-- Struktur dari tabel `modul`
--

CREATE TABLE `modul` (
  `id_modul` int(5) NOT NULL,
  `nama_modul` varchar(50) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `username` varchar(50) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `link` varchar(100) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `static_content` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `gambar` varchar(100) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `publish` enum('Y','N') CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'Y',
  `status` enum('user','admin') CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `aktif` enum('Y','N') CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'Y',
  `urutan` int(5) NOT NULL,
  `link_seo` varchar(50) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `modul`
--

INSERT INTO `modul` (`id_modul`, `nama_modul`, `username`, `link`, `static_content`, `gambar`, `publish`, `status`, `aktif`, `urutan`, `link_seo`) VALUES
(2, 'Manajemen User', 'admin', 'manajemenuser', '', '', 'Y', 'user', 'Y', 0, ''),
(82, 'Rekap Keuangan', 'admin', 'rekap', '', '', 'Y', 'user', 'Y', 0, ''),
(10, 'Manajemen Modul', 'admin', 'manajemenmodul', '', '', 'Y', 'user', 'Y', 0, ''),
(76, 'No Rekening', 'admin', 'rekening', '', '', 'Y', 'user', 'Y', 0, ''),
(77, 'Data Sopir', 'admin', 'sopir', '', '', 'Y', 'user', 'Y', 0, ''),
(78, 'Data Mobil', 'admin', 'mobil', '', '', 'Y', 'user', 'Y', 0, ''),
(79, 'Data Mobil Detail', 'admin', 'mobil_detail', '', '', 'Y', 'user', 'Y', 0, ''),
(80, 'Pemesanan + Report', 'admin', 'pemesanan', '', '', 'Y', 'user', 'Y', 0, ''),
(81, 'Penyewaan + Report', 'admin', 'penyewaan', '', '', 'Y', 'user', 'Y', 0, ''),
(61, 'Identitas Website', 'admin', 'identitaswebsite', '', '', 'Y', 'user', 'Y', 0, ''),
(57, 'Menu Website', 'admin', 'menuwebsite', '', '', 'Y', 'user', 'Y', 0, ''),
(59, 'Halaman Baru', 'admin', 'halamanbaru', '', '', 'Y', 'user', 'Y', 0, ''),
(66, 'Logo Website', 'admin', 'logowebsite', '', '', 'Y', 'user', 'Y', 0, ''),
(70, 'Pesan Masuk', 'admin', 'pesanmasuk', '', '', 'Y', 'user', 'Y', 0, ''),
(75, 'Alamat Kontak', 'admin', 'alamat', '', '', 'Y', 'user', 'Y', 0, '');

-- --------------------------------------------------------

--
-- Struktur dari tabel `mod_alamat`
--

CREATE TABLE `mod_alamat` (
  `id_alamat` int(5) NOT NULL,
  `alamat` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `mod_alamat`
--

INSERT INTO `mod_alamat` (`id_alamat`, `alamat`) VALUES
(1, '<h2><span style=\"color:#000000\">Mengapa menghubungi kami ?</span></h2>\r\n\r\n<p>Kami memiliki komitmen untuk memberikan layanan terbaik kepada Anda dan selalu berusaha untuk menyediakan produk dan layanan terbaik yang Anda butuhkan. Apabila untuk alasan tertentu Anda merasa tidak puas dengan pelayanan kami, Anda dapat menyampaikan kritik dan saran Anda kepada kami. Kami akan menidaklanjuti masukan yang Anda berikan dan bila perlu mengambil tindakan untuk mencegah masalah yang sama terulang kembali.</p>\r\n\r\n<h2>Hubungi kami segera ?</h2>\r\n\r\n<p>Silahkan menghubungi kami melalui private message melalui form yang berada pada bagian kanan halaman ini. Kritik dan saran Anda sangat penting bagi kami untuk terus meningkatkan kualitas produk dan layanan yang kami berikan kepada Anda.</p>\r\n');

-- --------------------------------------------------------

--
-- Struktur dari tabel `orders`
--

CREATE TABLE `orders` (
  `id_orders` int(11) NOT NULL,
  `kode_orders` varchar(50) NOT NULL,
  `nama_pemesan` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `no_telpon` varchar(50) NOT NULL,
  `keterangan` varchar(255) NOT NULL,
  `jemput` text NOT NULL,
  `tujuan` text NOT NULL,
  `status` enum('Pending','Proses') NOT NULL DEFAULT 'Pending',
  `waktu` date NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `orders`
--

INSERT INTO `orders` (`id_orders`, `kode_orders`, `nama_pemesan`, `email`, `no_telpon`, `keterangan`, `jemput`, `tujuan`, `status`, `waktu`) VALUES
(7, 'TRX-20180627061400', 'Robby Prihandaya', 'robby.prihandaya@gmail.com', '081267771344', 'Butuh Cepat,..', 'Gang Doli', 'Transmart Padang', 'Proses', '2018-06-27'),
(10, 'TRX-20180802090405', 'Made Putut Wijaya', 'made.putut@gmail.com', '082309881234', 'Secepatnya ya,..', 'Jl. Begini Begono', 'Jl. Merdeka BIntara', 'Proses', '2018-08-02'),
(15, 'TRX-20190223090509', 'Muhammad Arenio', 'muhammad.arsenio@gmail.com', '088812445677', 'Tidak ada Keterangan,..', 'Jl. Gumarang Jaya', 'Jl. Juanda Raya', 'Proses', '2019-02-23'),
(14, 'TRX-20190223090148', 'Dewiit Safitri', 'dewiit.saftir@gmail.com', '085234569988', 'Tidak ada Keterangan,..', 'Jl. Insyur Soekarno', 'Jl. Juanda Raya', 'Proses', '2019-02-23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `orders_detail`
--

CREATE TABLE `orders_detail` (
  `id_orders_detail` int(11) NOT NULL,
  `id_mobil` int(11) NOT NULL,
  `kode_orders` varchar(50) NOT NULL,
  `sewa_perhari` int(10) NOT NULL,
  `sopir` enum('Ya','Tidak') NOT NULL,
  `dari_tanggal` date NOT NULL,
  `sampai_tanggal` date NOT NULL,
  `waktu_orders` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `orders_detail`
--

INSERT INTO `orders_detail` (`id_orders_detail`, `id_mobil`, `kode_orders`, `sewa_perhari`, `sopir`, `dari_tanggal`, `sampai_tanggal`, `waktu_orders`) VALUES
(42, 50, 'TRX-20180627061400', 400000, 'Ya', '2018-06-27', '2018-06-27', '2018-06-27 06:14:00'),
(56, 30, 'TRX-20180802090405', 250000, 'Ya', '2018-08-02', '2018-08-03', '2018-08-02 09:48:22'),
(57, 31, 'TRX-20180802090405', 300000, 'Tidak', '2018-08-10', '2018-08-12', '2018-08-02 09:48:43'),
(65, 30, 'TRX-20190223090148', 250000, 'Tidak', '2019-02-25', '2019-02-25', '2019-02-23 09:04:13'),
(66, 31, 'TRX-20190223090148', 300000, 'Tidak', '2019-02-23', '2019-02-25', '2019-02-23 09:04:44'),
(67, 41, 'TRX-20190223090509', 400000, 'Tidak', '2019-02-23', '2019-02-25', '2019-02-23 09:05:53'),
(70, 52, 'TRX-20190224075005', 700000, 'Ya', '2019-02-26', '2019-02-27', '2019-02-24 08:39:11'),
(71, 50, 'TRX-20241026111154', 400000, 'Ya', '2024-10-26', '2024-10-27', '2024-10-26 11:11:54');

-- --------------------------------------------------------

--
-- Struktur dari tabel `orders_sopir`
--

CREATE TABLE `orders_sopir` (
  `id_orders_sopir` int(11) NOT NULL,
  `id_orders_detail` int(11) NOT NULL,
  `id_sopir` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `orders_sopir`
--

INSERT INTO `orders_sopir` (`id_orders_sopir`, `id_orders_detail`, `id_sopir`) VALUES
(1, 2, 2),
(2, 3, 1),
(9, 8, 2),
(10, 30, 1),
(11, 31, 0),
(14, 36, 2),
(15, 35, 1),
(16, 42, 1),
(17, 47, 0),
(18, 52, 28),
(19, 53, 1),
(20, 54, 2),
(21, 56, 1),
(23, 57, 1),
(24, 62, 1),
(25, 63, 2),
(26, 64, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengembalian`
--

CREATE TABLE `pengembalian` (
  `id_pengembalian` int(11) NOT NULL,
  `id_orders` int(11) NOT NULL,
  `biaya_tambahan` int(11) NOT NULL,
  `catatan` text NOT NULL,
  `waktu_proses` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `pengembalian`
--

INSERT INTO `pengembalian` (`id_pengembalian`, `id_orders`, `biaya_tambahan`, `catatan`, `waktu_proses`) VALUES
(1, 10, 250000, 'Body mobil gores, dan dikenakan biaya tambahan saat pengembalian,..', '2018-08-04 06:10:40'),
(2, 7, 200000, 'Ganti uang untuk mobil gores,..', '2018-08-06 07:19:33');

-- --------------------------------------------------------

--
-- Struktur dari tabel `rb_rekening`
--

CREATE TABLE `rb_rekening` (
  `id_rekening` int(5) NOT NULL,
  `nama_bank` varchar(50) NOT NULL,
  `no_rekening` varchar(50) NOT NULL,
  `pemilik_rekening` varchar(150) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `rb_rekening`
--

INSERT INTO `rb_rekening` (`id_rekening`, `nama_bank`, `no_rekening`, `pemilik_rekening`) VALUES
(1, 'BANK BRI (Bank Rakyat Indonesia)', '547601016142539', 'Robby Prihandaya'),
(2, 'BANK BCA (Bank Central Asia)', '0320943647', 'Robby Prihandaya');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sopir`
--

CREATE TABLE `sopir` (
  `id_sopir` int(11) NOT NULL,
  `nama_sopir` varchar(255) NOT NULL,
  `jenis_kelamin` enum('Laki-laki','Perempuan') NOT NULL,
  `tempat_lahir` varchar(255) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `alamat_lengkap` text NOT NULL,
  `keterangan` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `sopir`
--

INSERT INTO `sopir` (`id_sopir`, `nama_sopir`, `jenis_kelamin`, `tempat_lahir`, `tanggal_lahir`, `alamat_lengkap`, `keterangan`) VALUES
(1, 'Robby Prihandaya', 'Laki-laki', 'Padang', '1989-05-06', 'Jl. Angkasa Puri, Perundam 4, Tunggul Hitam, Padang', 'Tidak ada Keterangan untuk data ini.'),
(2, 'Dewiit Safitri', 'Perempuan', 'Payakumbuh', '1989-02-12', 'Jl. Linggar Jati 2, Perupuk Tabing, Padang', 'Tidak ada Keterangan untuk data ini.');

-- --------------------------------------------------------

--
-- Struktur dari tabel `statistik`
--

CREATE TABLE `statistik` (
  `ip` varchar(20) NOT NULL DEFAULT '',
  `tanggal` date NOT NULL,
  `hits` int(10) NOT NULL DEFAULT '1',
  `online` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `statistik`
--

INSERT INTO `statistik` (`ip`, `tanggal`, `hits`, `online`) VALUES
('223.255.231.148', '2014-05-06', 1, '1399357334'),
('223.255.231.147', '2014-05-15', 3, '1400119147'),
('223.255.224.73', '2014-05-15', 12, '1400123797'),
('223.255.224.69', '2014-05-16', 2, '1400215103'),
('118.96.51.231', '2014-05-16', 19, '1400233044'),
('223.255.231.146', '2014-05-16', 2, '1400228049'),
('::1', '2014-06-20', 2, '1403230579'),
('::1', '2014-06-22', 8, '1403436591'),
('223.255.231.154', '2014-06-26', 1, '1403739948'),
('223.255.231.148', '2014-06-26', 6, '1403745715'),
('223.255.224.74', '2014-06-26', 1, '1403748060'),
('223.255.224.69', '2014-06-26', 1, '1403753239'),
('223.255.224.77', '2014-06-29', 1, '1404039342'),
('::1', '2014-07-02', 6, '1404277263'),
('127.0.0.1', '2014-07-17', 2, '1405582494'),
('127.0.0.1', '2014-07-21', 1, '1405929828'),
('36.76.60.43', '2014-07-21', 1, '1405951864'),
('223.255.231.154', '2014-07-21', 2, '1405957200'),
('223.255.227.21', '2014-07-22', 1, '1405995171'),
('223.255.231.146', '2014-07-22', 1, '1405997152'),
('223.255.227.21', '2014-07-23', 1, '1406100212'),
('223.255.227.17', '2014-07-23', 1, '1406104552'),
('223.255.227.23', '2014-07-24', 1, '1406168095'),
('223.255.231.153', '2014-07-24', 1, '1406204439'),
('223.255.231.146', '2014-07-25', 1, '1406268985'),
('180.76.5.193', '2014-08-06', 1, '1407302738'),
('180.76.5.23', '2014-08-06', 1, '1407304739'),
('202.67.36.241', '2014-08-06', 1, '1407305643'),
('198.148.27.22', '2014-08-06', 1, '1407306703'),
('180.251.170.42', '2014-08-06', 7, '1407310167'),
('128.199.171.191', '2014-08-06', 3, '1407323435'),
('223.255.231.149', '2014-08-06', 2, '1407309879'),
('223.255.227.28', '2014-08-06', 8, '1407311801'),
('103.24.49.242', '2014-08-06', 1, '1407312326'),
('223.255.231.146', '2014-08-06', 1, '1407313297'),
('180.214.233.34', '2014-08-06', 1, '1407321063'),
('66.249.77.87', '2014-08-06', 1, '1407323509'),
('223.255.227.30', '2014-08-06', 1, '1407325862'),
('180.254.207.13', '2014-08-06', 5, '1407330687'),
('114.79.13.199', '2014-08-06', 1, '1407336900'),
('202.152.199.34', '2014-08-06', 7, '1407337100'),
('180.76.6.21', '2014-08-07', 1, '1407347753'),
('114.79.13.55', '2014-08-07', 3, '1407354277'),
('114.125.41.136', '2014-08-07', 1, '1407352625'),
('180.76.6.147', '2014-08-07', 1, '1407355344'),
('180.76.6.64', '2014-08-07', 1, '1407367237'),
('69.171.247.116', '2014-08-07', 1, '1407379834'),
('69.171.247.119', '2014-08-07', 1, '1407379834'),
('69.171.247.114', '2014-08-07', 1, '1407379834'),
('69.171.247.115', '2014-08-07', 1, '1407379834'),
('202.67.34.29', '2014-08-07', 2, '1407380415'),
('36.76.52.112', '2014-08-07', 1, '1407380496'),
('223.255.231.145', '2014-08-07', 5, '1407387045'),
('223.255.231.153', '2014-08-07', 2, '1407388883'),
('223.255.227.27', '2014-08-07', 1, '1407393087'),
('180.76.5.25', '2014-08-07', 1, '1407394749'),
('223.255.231.146', '2014-08-07', 1, '1407397183'),
('157.55.39.248', '2014-08-07', 1, '1407397231'),
('180.254.200.55', '2014-08-07', 2, '1407399466'),
('110.139.67.15', '2014-08-07', 8, '1407399221'),
('180.242.17.64', '2014-08-07', 11, '1407414373'),
('141.0.8.59', '2014-08-07', 1, '1407412384'),
('110.76.149.91', '2014-08-07', 1, '1407422367'),
('223.255.231.151', '2014-08-07', 3, '1407426943'),
('82.145.209.206', '2014-08-07', 1, '1407430369'),
('223.255.227.28', '2014-08-08', 3, '1407469589'),
('66.93.156.50', '2014-08-08', 1, '1407472340'),
('202.62.17.47', '2014-08-08', 1, '1407484393'),
('36.70.135.163', '2014-08-08', 6, '1407485987'),
('173.252.74.115', '2014-08-08', 1, '1407485153'),
('118.96.58.136', '2014-08-08', 2, '1407486347'),
('114.79.29.68', '2014-08-08', 1, '1407502537'),
('66.220.156.113', '2014-08-08', 1, '1407503375'),
('112.215.66.79', '2014-08-08', 1, '1407503381'),
('125.163.113.156', '2014-08-08', 9, '1407508824'),
('180.76.5.94', '2014-08-08', 1, '1407508624'),
('120.172.9.192', '2014-08-08', 1, '1407515634'),
('202.67.41.51', '2014-08-08', 1, '1407515702'),
('180.253.243.222', '2014-08-09', 1, '1407542724'),
('36.75.224.20', '2014-08-09', 1, '1407548005'),
('180.76.5.65', '2014-08-09', 1, '1407548865'),
('66.249.77.77', '2014-08-09', 2, '1407582711'),
('180.76.6.137', '2014-08-09', 1, '1407553037'),
('66.249.77.87', '2014-08-09', 1, '1407554836'),
('66.249.77.97', '2014-08-09', 2, '1407562640'),
('120.177.44.126', '2014-08-09', 2, '1407558625'),
('223.255.231.145', '2014-08-09', 3, '1407558663'),
('36.73.64.113', '2014-08-09', 1, '1407558640'),
('36.72.187.12', '2014-08-09', 1, '1407560351'),
('202.67.41.51', '2014-08-09', 1, '1407561096'),
('114.125.60.68', '2014-08-09', 4, '1407561514'),
('202.67.40.50', '2014-08-09', 1, '1407562007'),
('180.76.6.136', '2014-08-09', 1, '1407562581'),
('110.232.81.2', '2014-08-09', 5, '1407563275'),
('146.185.28.59', '2014-08-09', 1, '1407564768'),
('120.174.157.139', '2014-08-09', 1, '1407568139'),
('223.255.227.23', '2014-08-09', 2, '1407570163'),
('193.105.210.119', '2014-08-09', 1, '1407577518'),
('125.162.57.66', '2014-08-09', 2, '1407579822'),
('180.241.163.1', '2014-08-09', 8, '1407580493'),
('36.76.44.163', '2014-08-09', 6, '1407603574'),
('180.76.5.144', '2014-08-09', 1, '1407582757'),
('107.167.103.40', '2014-08-09', 1, '1407586189'),
('36.68.48.23', '2014-08-09', 1, '1407586974'),
('192.99.218.151', '2014-08-09', 4, '1407587574'),
('36.74.55.24', '2014-08-09', 3, '1407589161'),
('118.97.212.184', '2014-08-09', 8, '1407595169'),
('36.72.114.118', '2014-08-09', 2, '1407597684'),
('180.76.5.153', '2014-08-09', 1, '1407602870'),
('180.76.5.59', '2014-08-09', 1, '1407603153'),
('180.76.5.18', '2014-08-10', 1, '1407606581'),
('180.254.155.156', '2014-08-10', 2, '1407607003'),
('180.76.6.42', '2014-08-10', 1, '1407608363'),
('36.68.242.217', '2014-08-10', 5, '1407627100'),
('66.249.77.77', '2014-08-10', 2, '1407633623'),
('202.67.44.64', '2014-08-10', 1, '1407629598'),
('180.76.6.43', '2014-08-10', 1, '1407631270'),
('118.97.212.182', '2014-08-10', 4, '1407632228'),
('139.0.102.140', '2014-08-10', 1, '1407633944'),
('66.249.77.87', '2014-08-10', 1, '1407636902'),
('66.249.77.97', '2014-08-10', 1, '1407639983'),
('180.76.6.159', '2014-08-10', 1, '1407640798'),
('118.97.212.181', '2014-08-10', 3, '1407642556'),
('36.68.46.37', '2014-08-10', 2, '1407642940'),
('180.76.5.69', '2014-08-10', 1, '1407645158'),
('180.76.5.80', '2014-08-10', 1, '1407648268'),
('180.76.5.143', '2014-08-10', 1, '1407650068'),
('223.255.231.145', '2014-08-10', 1, '1407650216'),
('180.76.6.149', '2014-08-10', 1, '1407657020'),
('36.77.183.218', '2014-08-10', 2, '1407657119'),
('127.0.0.1', '2014-08-10', 2, '1407660057'),
('127.0.0.1', '2014-08-11', 2, '1407725194'),
('127.0.0.1', '2014-08-12', 1, '1407862185'),
('127.0.0.1', '2014-08-13', 1, '1407899819'),
('127.0.0.1', '2014-08-17', 44, '1408287630'),
('127.0.0.1', '2014-08-18', 253, '1408372590'),
('127.0.0.1', '2014-08-19', 4, '1408413702'),
('::1', '2014-08-19', 90, '1408433250'),
('::1', '2014-08-31', 1, '1409487043'),
('::1', '2015-03-11', 11, '1426061663'),
('::1', '2015-03-12', 1, '1426114982'),
('::1', '2015-03-15', 32, '1426430637'),
('::1', '2015-03-18', 137, '1426666506'),
('::1', '2015-03-19', 143, '1426751746'),
('::1', '2015-03-21', 198, '1426912294'),
('::1', '2015-03-22', 554, '1427039069'),
('127.0.0.1', '2015-03-22', 1, '1427030317'),
('::1', '2015-03-23', 275, '1427093113'),
('::1', '2015-03-24', 42, '1427179474'),
('::1', '2015-03-25', 45, '1427251499'),
('39.225.164.2', '2015-05-14', 7, '1431584409'),
('119.110.72.130', '2015-05-14', 30, '1431595368'),
('89.145.95.2', '2015-05-14', 1, '1431582645'),
('66.220.158.118', '2015-05-14', 1, '1431582842'),
('66.220.158.115', '2015-05-14', 1, '1431582852'),
('66.220.158.112', '2015-05-14', 3, '1431595371'),
('66.220.158.119', '2015-05-14', 1, '1431582942'),
('114.125.43.185', '2015-05-14', 5, '1431602132'),
('119.110.72.130', '2015-05-15', 1, '1431673658'),
('114.125.45.206', '2015-05-16', 18, '1431741581'),
('66.220.158.116', '2015-05-16', 1, '1431741049'),
('66.220.158.118', '2015-05-16', 1, '1431741224'),
('66.220.158.114', '2015-05-16', 1, '1431741233'),
('39.229.6.148', '2015-05-16', 11, '1431791037'),
('39.225.236.155', '2015-05-17', 8, '1431862096'),
('119.110.72.130', '2015-05-19', 6, '1432006569'),
('89.145.95.42', '2015-05-19', 2, '1432006661'),
('114.121.133.117', '2015-05-19', 3, '1432046663'),
('124.195.114.65', '2015-05-28', 16, '1432832381'),
('66.220.158.119', '2015-05-28', 1, '1432831000'),
('66.220.158.115', '2015-05-28', 1, '1432831013'),
('66.220.158.116', '2015-05-28', 1, '1432832385'),
('124.195.114.65', '2015-05-29', 77, '1432836214'),
('66.220.158.113', '2015-05-29', 1, '1432835961'),
('66.249.84.178', '2015-05-29', 1, '1432836220'),
('103.246.200.14', '2015-05-29', 1, '1432851867'),
('103.246.200.59', '2015-05-29', 1, '1432851916'),
('114.124.5.250', '2015-05-29', 6, '1432852876'),
('173.252.105.114', '2015-05-29', 1, '1432852770'),
('120.180.175.150', '2015-05-29', 36, '1432864082'),
('103.246.200.50', '2015-05-29', 1, '1432863615'),
('103.246.200.1', '2015-05-29', 1, '1432863650'),
('103.246.200.33', '2015-05-29', 1, '1432863711'),
('103.246.200.44', '2015-05-29', 1, '1432863795'),
('120.174.144.115', '2015-05-29', 1, '1432908445'),
('119.110.72.130', '2015-05-29', 27, '1432912022'),
('173.252.90.117', '2015-05-29', 1, '1432910852'),
('173.252.90.116', '2015-05-29', 1, '1432910873'),
('173.252.90.118', '2015-05-29', 1, '1432911344'),
('173.252.90.122', '2015-05-29', 1, '1432911470'),
('66.249.84.190', '2015-05-30', 1, '1432945579'),
('39.254.117.222', '2015-05-30', 1, '1432991226'),
('66.249.84.178', '2015-05-31', 1, '1433037242'),
('120.176.92.190', '2015-06-01', 3, '1433128955'),
('66.102.6.210', '2015-06-01', 1, '1433134430'),
('120.164.44.28', '2015-06-01', 13, '1433149419'),
('124.195.118.227', '2015-06-01', 1, '1433170960'),
('120.177.28.244', '2015-06-02', 8, '1433220043'),
('66.249.84.190', '2015-06-02', 1, '1433247837'),
('120.190.75.179', '2015-06-03', 7, '1433302768'),
('119.110.72.130', '2015-06-03', 4, '1433302761'),
('89.145.95.2', '2015-06-03', 1, '1433302690'),
('66.249.71.147', '2015-06-07', 46, '1433696370'),
('66.249.71.130', '2015-06-07', 30, '1433696150'),
('66.249.71.164', '2015-06-07', 37, '1433696154'),
('173.252.74.113', '2015-06-07', 8, '1433694061'),
('173.252.74.117', '2015-06-07', 3, '1433676319'),
('66.249.64.57', '2015-06-07', 1, '1433674283'),
('173.252.88.89', '2015-06-07', 5, '1433677999'),
('173.252.88.86', '2015-06-07', 2, '1433677597'),
('173.252.74.119', '2015-06-07', 7, '1433694862'),
('66.249.79.117', '2015-06-07', 1, '1433674983'),
('173.252.88.84', '2015-06-07', 2, '1433676738'),
('173.252.74.115', '2015-06-07', 3, '1433676460'),
('173.252.74.114', '2015-06-07', 2, '1433694204'),
('173.252.74.118', '2015-06-07', 3, '1433676180'),
('173.252.74.112', '2015-06-07', 5, '1433695314'),
('173.252.88.85', '2015-06-07', 2, '1433677804'),
('173.252.88.90', '2015-06-07', 1, '1433676251'),
('173.252.74.116', '2015-06-07', 5, '1433695249'),
('173.252.88.87', '2015-06-07', 2, '1433677488'),
('173.252.88.88', '2015-06-07', 1, '1433677370'),
('66.249.79.130', '2015-06-07', 1, '1433694848'),
('66.220.156.116', '2015-06-07', 2, '1433696197'),
('66.249.67.104', '2015-06-07', 1, '1433696147'),
('66.220.156.112', '2015-06-07', 2, '1433696173'),
('66.220.146.22', '2015-06-07', 1, '1433696162'),
('66.249.67.117', '2015-06-07', 1, '1433696288'),
('66.220.156.114', '2015-06-07', 1, '1433696309'),
('66.220.156.117', '2015-06-08', 3, '1433711204'),
('66.249.71.164', '2015-06-08', 32, '1433779112'),
('66.220.146.25', '2015-06-08', 2, '1433736854'),
('66.220.156.116', '2015-06-08', 2, '1433709422'),
('66.249.71.147', '2015-06-08', 29, '1433748751'),
('66.220.156.112', '2015-06-08', 4, '1433715007'),
('66.220.146.20', '2015-06-08', 1, '1433696744'),
('66.249.71.130', '2015-06-08', 38, '1433777391'),
('66.220.156.118', '2015-06-08', 2, '1433712628'),
('66.220.146.27', '2015-06-08', 1, '1433712556'),
('66.220.146.26', '2015-06-08', 1, '1433712746'),
('66.249.67.104', '2015-06-08', 4, '1433746797'),
('66.220.146.22', '2015-06-08', 1, '1433714244'),
('66.220.156.115', '2015-06-08', 2, '1433714821'),
('66.249.67.117', '2015-06-08', 2, '1433780504'),
('120.176.251.49', '2015-06-08', 2, '1433737104'),
('66.220.156.119', '2015-06-08', 1, '1433737457'),
('66.249.71.147', '2015-06-09', 3, '1433836081'),
('66.249.71.130', '2015-06-09', 4, '1433835126'),
('66.249.67.104', '2015-06-09', 1, '1433788622'),
('66.249.71.164', '2015-06-09', 1, '1433823064'),
('66.249.71.130', '2015-06-10', 5, '1433953790'),
('66.249.67.117', '2015-06-10', 1, '1433911605'),
('66.249.71.164', '2015-06-10', 3, '1433954890'),
('66.249.71.147', '2015-06-10', 2, '1433953573'),
('66.249.71.147', '2015-06-11', 1, '1433957808'),
('66.249.71.164', '2015-06-11', 2, '1433990805'),
('68.180.228.104', '2015-06-11', 1, '1433975257'),
('66.249.71.130', '2015-06-11', 1, '1433991891'),
('36.68.28.19', '2015-06-14', 5, '1434224041'),
('120.164.46.127', '2015-06-14', 2, '1434239557'),
('66.249.67.248', '2015-06-15', 1, '1434362861'),
('104.193.10.50', '2015-06-15', 3, '1434372762'),
('104.193.10.50', '2015-06-16', 2, '1434454308'),
('36.80.234.114', '2015-06-16', 4, '1434443273'),
('173.252.74.115', '2015-06-16', 1, '1434443264'),
('173.252.74.114', '2015-06-16', 1, '1434443279'),
('119.110.72.130', '2015-06-16', 1, '1434467216'),
('124.195.116.71', '2015-06-17', 3, '1434551738'),
('120.184.130.21', '2015-06-27', 1, '1435386862'),
('66.249.84.246', '2015-06-27', 1, '1435387150'),
('120.176.176.106', '2015-06-28', 7, '1435461088'),
('66.220.158.114', '2015-06-28', 1, '1435461007'),
('66.249.84.129', '2015-06-28', 1, '1435466083'),
('66.249.84.246', '2015-06-29', 2, '1435563211'),
('66.249.84.252', '2015-06-29', 1, '1435563206'),
('66.249.84.246', '2015-06-30', 3, '1435677685'),
('66.249.84.252', '2015-06-30', 1, '1435645799'),
('66.249.84.252', '2015-07-01', 1, '1435710707'),
('66.249.84.129', '2015-07-01', 1, '1435711780'),
('120.177.18.200', '2015-07-02', 1, '1435824891'),
('::1', '2015-11-25', 15, '1448407930'),
('::1', '2015-12-01', 12, '1448944568'),
('::1', '2015-12-03', 9, '1449138520'),
('::1', '2015-12-05', 26, '1449279360'),
('::1', '2015-12-07', 4, '1449442678'),
('::1', '2015-12-08', 8, '1449532582'),
('::1', '2015-12-13', 31, '1449974628'),
('::1', '2015-12-18', 9, '1450418535'),
('::1', '2015-12-21', 10, '1450654644'),
('::1', '2015-12-24', 3, '1450917714'),
('::1', '2015-12-25', 4, '1451037761'),
('::1', '2015-12-26', 5, '1451086546'),
('::1', '2016-01-01', 1, '1451626224'),
('::1', '2016-01-12', 2, '1452564572'),
('::1', '2016-01-16', 7, '1452913899'),
('::1', '2016-01-17', 150, '1453036730'),
('::1', '2016-07-24', 24, '1469318037'),
('::1', '2016-07-29', 1, '1469767572'),
('::1', '2016-07-31', 1, '1469936872'),
('::1', '2016-08-01', 14, '1470019073'),
('::1', '2016-08-12', 4, '1470940786'),
('::1', '2016-08-14', 3, '1471191885'),
('::1', '2016-08-22', 5, '1471851644'),
('::1', '2016-08-26', 4, '1472207940'),
('::1', '2016-08-29', 9, '1472475500'),
('::1', '2016-08-30', 1, '1472531831'),
('::1', '2016-09-13', 4, '1473760584'),
('::1', '2016-09-16', 7, '1473998550'),
('::1', '2016-09-17', 3, '1474076080'),
('::1', '2016-09-20', 4, '1474335445'),
('::1', '2016-09-21', 5, '1474470987'),
('::1', '2016-09-26', 8, '1474866854'),
('::1', '2016-11-21', 20, '1479719811'),
('::1', '2016-11-22', 26, '1479795839'),
('::1', '2016-12-24', 1, '1482592503'),
('::1', '2016-12-23', 2, '1482451494'),
('::1', '2016-12-20', 7, '1482205377'),
('::1', '2016-12-14', 4, '1481717872'),
('::1', '2016-12-13', 24, '1481593512'),
('::1', '2016-12-09', 1, '1481243159'),
('::1', '2016-12-03', 3, '1480741491'),
('::1', '2016-11-28', 32, '1480303392'),
('::1', '2016-11-27', 2, '1480224412'),
('::1', '2016-11-24', 403, '1479984680'),
('::1', '2016-11-23', 2, '1479913316'),
('::1', '2017-01-03', 9, '1483421812'),
('::1', '2017-01-04', 2, '1483534977'),
('::1', '2017-01-05', 3, '1483627230'),
('::1', '2017-01-14', 1, '1484352852'),
('::1', '2017-01-17', 3, '1484663823'),
('::1', '2017-01-25', 12, '1485359750'),
('::1', '2017-01-26', 37, '1485414680'),
('::1', '2017-01-27', 70, '1485508785'),
('::1', '2017-01-28', 1, '1485567010'),
('::1', '2017-02-04', 1, '1486213804'),
('::1', '2017-02-09', 14, '1486659480'),
('::1', '2017-02-10', 3, '1486684650'),
('::1', '2017-02-11', 11, '1486773431'),
('::1', '2017-02-12', 6, '1486869838'),
('::1', '2017-02-13', 5, '1486995163'),
('::1', '2017-02-15', 3, '1487123924'),
('::1', '2017-02-21', 1, '1487659967'),
('::1', '2017-02-23', 7, '1487832476'),
('::1', '2017-02-26', 4, '1488064851'),
('::1', '2017-03-13', 44, '1489366890'),
('::1', '2017-03-17', 24, '1489744337'),
('::1', '2017-03-20', 1, '1489988038'),
('::1', '2017-03-25', 1, '1490413626'),
('::1', '2017-03-29', 7, '1490744633'),
('::1', '2017-04-02', 1, '1491122695'),
('::1', '2017-04-06', 56, '1491462329'),
('::1', '2017-04-07', 59, '1491524075'),
('::1', '2017-04-09', 20, '1491711058'),
('::1', '2017-04-11', 9, '1491877995'),
('::1', '2017-04-12', 124, '1492006218'),
('::1', '2017-04-13', 53, '1492088580'),
('::1', '2017-05-14', 133, '1494767093'),
('::1', '2017-05-20', 167, '1495299592'),
('::1', '2017-05-21', 235, '1495377214'),
('::1', '2017-05-25', 111, '1495731477'),
('::1', '2017-05-26', 119, '1495809631'),
('::1', '2017-05-27', 2, '1495839269'),
('::1', '2017-06-06', 4, '1496752645'),
('::1', '2017-06-08', 191, '1496939366'),
('::1', '2017-06-09', 494, '1497008376'),
('::1', '2017-06-10', 139, '1497063353'),
('::1', '2017-06-11', 6, '1497142911'),
('::1', '2017-06-16', 3, '1497570235'),
('::1', '2017-11-07', 89, '1510068474'),
('::1', '2017-11-09', 225, '1510205282'),
('::1', '2018-03-24', 178, '1521909011'),
('::1', '2018-03-25', 85, '1521944562'),
('::1', '2018-03-26', 2, '1522038054'),
('::1', '2018-03-27', 23, '1522154380'),
('::1', '2018-06-24', 33, '1529828346'),
('::1', '2018-06-25', 3, '1529876687'),
('::1', '2018-06-27', 8, '1530055124'),
('::1', '2018-07-02', 11, '1530512900'),
('::1', '2018-08-02', 75, '1533179886'),
('::1', '2018-08-03', 29, '1533265934'),
('::1', '2018-08-04', 3, '1533345904'),
('::1', '2018-08-05', 2, '1533452567'),
('::1', '2018-08-06', 8, '1533526184'),
('::1', '2018-08-07', 1, '1533613282'),
('::1', '2018-08-08', 1, '1533684065'),
('::1', '2019-02-23', 20, '1550930202'),
('::1', '2019-02-24', 135, '1550975436'),
('127.0.0.1', '2024-10-26', 16, '1729916126');

-- --------------------------------------------------------

--
-- Struktur dari tabel `templates`
--

CREATE TABLE `templates` (
  `id_templates` int(5) NOT NULL,
  `judul` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `username` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `pembuat` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `folder` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `aktif` enum('Y','N') COLLATE latin1_general_ci NOT NULL DEFAULT 'N'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data untuk tabel `templates`
--

INSERT INTO `templates` (`id_templates`, `judul`, `username`, `pembuat`, `folder`, `aktif`) VALUES
(17, 'PHPMU - Rental Mobil Online', 'admin', 'Robby Prihandaya', 'phpmu-tigo', 'Y');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `username` varchar(50) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `nama_lengkap` varchar(100) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `email` varchar(100) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `no_telp` varchar(20) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `foto` varchar(100) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `level` varchar(20) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'user',
  `blokir` enum('Y','N') CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'N',
  `id_session` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`username`, `password`, `nama_lengkap`, `email`, `no_telp`, `foto`, `level`, `blokir`, `id_session`) VALUES
('\0', '*4ACFE3202A5FF5CF467898FC58AAB1D615029441', '\0', '\0', '0877474575899', '', 'user', 'N', '');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users_modul`
--

CREATE TABLE `users_modul` (
  `id_umod` int(11) NOT NULL,
  `id_session` varchar(255) NOT NULL,
  `id_modul` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `users_modul`
--

INSERT INTO `users_modul` (`id_umod`, `id_session`, `id_modul`) VALUES
(1, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 70),
(2, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 65),
(3, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 63),
(4, 'f76ad5ee772ac196cbc09824e24859ee', 70),
(5, 'f76ad5ee772ac196cbc09824e24859ee', 65),
(6, 'f76ad5ee772ac196cbc09824e24859ee', 63),
(7, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 18),
(8, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 66),
(9, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 33),
(10, '3460d81e02faa3559f9e02c9a766fcbd-20170124215625', 18),
(11, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 41),
(12, '6bec9c852847242e384a4d5ac0962ba0-20170406140423', 18),
(13, 'fa7688658d8b38aae731826ea1daebb5-20170521103501', 18),
(14, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 81),
(15, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 80),
(16, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 70),
(17, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 59),
(18, 'ed1d859c50262701d92e5cbf39652792-20170120090507', 57);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `background`
--
ALTER TABLE `background`
  ADD PRIMARY KEY (`id_background`);

--
-- Indeks untuk tabel `hubungi`
--
ALTER TABLE `hubungi`
  ADD PRIMARY KEY (`id_hubungi`);

--
-- Indeks untuk tabel `identitas`
--
ALTER TABLE `identitas`
  ADD PRIMARY KEY (`id_identitas`);

--
-- Indeks untuk tabel `logo`
--
ALTER TABLE `logo`
  ADD PRIMARY KEY (`id_logo`);

--
-- Indeks untuk tabel `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id_menu`);

--
-- Indeks untuk tabel `mobil`
--
ALTER TABLE `mobil`
  ADD PRIMARY KEY (`id_mobil`);

--
-- Indeks untuk tabel `mobil_detail`
--
ALTER TABLE `mobil_detail`
  ADD PRIMARY KEY (`id_mobil_detail`);

--
-- Indeks untuk tabel `modul`
--
ALTER TABLE `modul`
  ADD PRIMARY KEY (`id_modul`);

--
-- Indeks untuk tabel `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id_orders`);

--
-- Indeks untuk tabel `orders_detail`
--
ALTER TABLE `orders_detail`
  ADD PRIMARY KEY (`id_orders_detail`);

--
-- Indeks untuk tabel `orders_sopir`
--
ALTER TABLE `orders_sopir`
  ADD PRIMARY KEY (`id_orders_sopir`);

--
-- Indeks untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  ADD PRIMARY KEY (`id_pengembalian`);

--
-- Indeks untuk tabel `rb_rekening`
--
ALTER TABLE `rb_rekening`
  ADD PRIMARY KEY (`id_rekening`);

--
-- Indeks untuk tabel `sopir`
--
ALTER TABLE `sopir`
  ADD PRIMARY KEY (`id_sopir`);

--
-- Indeks untuk tabel `templates`
--
ALTER TABLE `templates`
  ADD PRIMARY KEY (`id_templates`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`username`);

--
-- Indeks untuk tabel `users_modul`
--
ALTER TABLE `users_modul`
  ADD PRIMARY KEY (`id_umod`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `background`
--
ALTER TABLE `background`
  MODIFY `id_background` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `hubungi`
--
ALTER TABLE `hubungi`
  MODIFY `id_hubungi` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT untuk tabel `identitas`
--
ALTER TABLE `identitas`
  MODIFY `id_identitas` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `logo`
--
ALTER TABLE `logo`
  MODIFY `id_logo` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT untuk tabel `menu`
--
ALTER TABLE `menu`
  MODIFY `id_menu` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT untuk tabel `mobil`
--
ALTER TABLE `mobil`
  MODIFY `id_mobil` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT untuk tabel `mobil_detail`
--
ALTER TABLE `mobil_detail`
  MODIFY `id_mobil_detail` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `modul`
--
ALTER TABLE `modul`
  MODIFY `id_modul` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT untuk tabel `orders`
--
ALTER TABLE `orders`
  MODIFY `id_orders` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `orders_detail`
--
ALTER TABLE `orders_detail`
  MODIFY `id_orders_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT untuk tabel `orders_sopir`
--
ALTER TABLE `orders_sopir`
  MODIFY `id_orders_sopir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  MODIFY `id_pengembalian` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `rb_rekening`
--
ALTER TABLE `rb_rekening`
  MODIFY `id_rekening` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `sopir`
--
ALTER TABLE `sopir`
  MODIFY `id_sopir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `templates`
--
ALTER TABLE `templates`
  MODIFY `id_templates` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT untuk tabel `users_modul`
--
ALTER TABLE `users_modul`
  MODIFY `id_umod` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
