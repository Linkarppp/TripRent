import 'car.dart';
import 'driver.dart';

class RentalOrder {
  final int id;
  final String kodeOrders;
  final String namaPemesan;
  final String email;
  final String noTelpon;
  final String keterangan;
  final String jemput;
  final String tujuan;
  final String status;
  final DateTime waktu;
  final Car car;
  final Driver? driver;
  final bool pakaiSopir;
  final DateTime dariTanggal;
  final DateTime sampaiTanggal;
  final int sewaPerhari;
  final int totalHari;
  final int totalHarga;
  final String bankPembayaran;

  RentalOrder({
    required this.id,
    required this.kodeOrders,
    required this.namaPemesan,
    required this.email,
    required this.noTelpon,
    required this.keterangan,
    required this.jemput,
    required this.tujuan,
    required this.status,
    required this.waktu,
    required this.car,
    this.driver,
    required this.pakaiSopir,
    required this.dariTanggal,
    required this.sampaiTanggal,
    required this.sewaPerhari,
    required this.totalHari,
    required this.totalHarga,
    this.bankPembayaran = 'BCA (0320943647 a/n Robby Prihandaya)',
  });
}
