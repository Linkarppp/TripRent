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
  final String status; // 'Pending' | 'Proses' | 'Selesai' | 'Dibatalkan'
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
  final bool isTicket;
  final String? ticketTitle;
  final String userId; // ID akun user pemesan
  final int? driverId; // ID driver yang ditugaskan
  final String driverTaskStatus; // 'Menunggu Konfirmasi' | 'Diterima' | 'Dalam Perjalanan' | 'Perjalanan Selesai' | 'Ditolak'
  final String paymentStatus; // 'Menunggu Verifikasi' | 'Lunas' | 'Ditolak'
  final String? buktiPembayaran;
  final int passengerCount;
  final String? seatNumbers;
  final String? paymentMethodType;
  final String? departureTime;

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
    this.isTicket = false,
    this.ticketTitle,
    this.userId = '1',
    this.driverId,
    this.driverTaskStatus = 'Menunggu Konfirmasi',
    this.paymentStatus = 'Lunas',
    this.buktiPembayaran,
    this.passengerCount = 1,
    this.seatNumbers,
    this.paymentMethodType = 'Transfer Bank',
    this.departureTime,
  });

  RentalOrder copyWith({
    int? id,
    String? kodeOrders,
    String? namaPemesan,
    String? email,
    String? noTelpon,
    String? keterangan,
    String? jemput,
    String? tujuan,
    String? status,
    DateTime? waktu,
    Car? car,
    Driver? driver,
    bool? pakaiSopir,
    DateTime? dariTanggal,
    DateTime? sampaiTanggal,
    int? sewaPerhari,
    int? totalHari,
    int? totalHarga,
    String? bankPembayaran,
    bool? isTicket,
    String? ticketTitle,
    String? userId,
    int? driverId,
    String? driverTaskStatus,
    String? paymentStatus,
    String? buktiPembayaran,
    int? passengerCount,
    String? seatNumbers,
    String? paymentMethodType,
    String? departureTime,
  }) {
    return RentalOrder(
      id: id ?? this.id,
      kodeOrders: kodeOrders ?? this.kodeOrders,
      namaPemesan: namaPemesan ?? this.namaPemesan,
      email: email ?? this.email,
      noTelpon: noTelpon ?? this.noTelpon,
      keterangan: keterangan ?? this.keterangan,
      jemput: jemput ?? this.jemput,
      tujuan: tujuan ?? this.tujuan,
      status: status ?? this.status,
      waktu: waktu ?? this.waktu,
      car: car ?? this.car,
      driver: driver ?? this.driver,
      pakaiSopir: pakaiSopir ?? this.pakaiSopir,
      dariTanggal: dariTanggal ?? this.dariTanggal,
      sampaiTanggal: sampaiTanggal ?? this.sampaiTanggal,
      sewaPerhari: sewaPerhari ?? this.sewaPerhari,
      totalHari: totalHari ?? this.totalHari,
      totalHarga: totalHarga ?? this.totalHarga,
      bankPembayaran: bankPembayaran ?? this.bankPembayaran,
      isTicket: isTicket ?? this.isTicket,
      ticketTitle: ticketTitle ?? this.ticketTitle,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      driverTaskStatus: driverTaskStatus ?? this.driverTaskStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      buktiPembayaran: buktiPembayaran ?? this.buktiPembayaran,
      passengerCount: passengerCount ?? this.passengerCount,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      paymentMethodType: paymentMethodType ?? this.paymentMethodType,
      departureTime: departureTime ?? this.departureTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kodeOrders': kodeOrders,
      'namaPemesan': namaPemesan,
      'email': email,
      'noTelpon': noTelpon,
      'keterangan': keterangan,
      'jemput': jemput,
      'tujuan': tujuan,
      'status': status,
      'waktu': waktu.toIso8601String(),
      'carId': car.id,
      'driverId': driverId ?? driver?.id,
      'pakaiSopir': pakaiSopir,
      'dariTanggal': dariTanggal.toIso8601String(),
      'sampaiTanggal': sampaiTanggal.toIso8601String(),
      'sewaPerhari': sewaPerhari,
      'totalHari': totalHari,
      'totalHarga': totalHarga,
      'bankPembayaran': bankPembayaran,
      'isTicket': isTicket,
      'ticketTitle': ticketTitle,
      'userId': userId,
      'driverTaskStatus': driverTaskStatus,
      'paymentStatus': paymentStatus,
      'buktiPembayaran': buktiPembayaran,
      'passengerCount': passengerCount,
      'seatNumbers': seatNumbers,
      'paymentMethodType': paymentMethodType,
      'departureTime': departureTime,
    };
  }
}
