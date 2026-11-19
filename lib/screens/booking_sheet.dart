import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/driver.dart';
import '../models/order.dart';
import '../data/mock_database.dart';
import '../theme/app_theme.dart';
import '../widgets/formatters.dart';
import '../widgets/location_autocomplete_field.dart';
import '../widgets/payment_method_selector.dart';

class BookingSheet extends StatefulWidget {
  final Car car;
  final bool? initialUseDriver;
  final Function(RentalOrder createdOrder)? onBookingConfirmed;

  const BookingSheet({
    super.key,
    required this.car,
    this.initialUseDriver,
    this.onBookingConfirmed,
  });

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _startDate;
  late DateTime _endDate;
  late bool _useDriver;
  Driver? _selectedDriver;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  final TextEditingController _pickupController =
      TextEditingController(text: 'Bandara Internasional Minangkabau (BIM)');
  final TextEditingController _destinationController =
      TextEditingController(text: 'Pusat Kota Padang & Wisata Pantai');
  final TextEditingController _notesController =
      TextEditingController(text: 'Mohon siapkan mobil dalam kondisi bersih.');

  PaymentSelection _selectedPayment = const PaymentSelection(
    category: 'Transfer Bank',
    channel: 'BCA',
    accountNumber: '1234567890',
    accountHolder: 'TripRent',
    instructions: 'Transfer ke rekening BCA di atas, lalu konfirmasi pembayaran.',
  );

  @override
  void initState() {
    super.initState();
    if (widget.initialUseDriver != null) {
      _useDriver = widget.initialUseDriver!;
    } else {
      final termasukLower = widget.car.termasuk.toLowerCase();
      final includesDriver = termasukLower.contains('supir') ||
          termasukLower.contains('sopir') ||
          termasukLower.contains('driver');
      // Jika keterangan mobil "Mobil Saja" / "Lepas Kunci", jangan auto-aktifkan sopir
      _useDriver = includesDriver;
    }
    final user = TripRentStore.instance.currentUser;
    _nameController = TextEditingController(text: user?.namaLengkap ?? '');
    _phoneController = TextEditingController(text: user?.noTelp ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _startDate = DateTime.now().add(const Duration(days: 1));
    _endDate = _startDate.add(Duration(days: widget.car.durasi));
    final drivers = TripRentStore.instance.drivers;
    if (drivers.isNotEmpty) {
      _selectedDriver = drivers.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _pickupController.dispose();
    _destinationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _rentalDays {
    final diff = _endDate.difference(_startDate).inDays;
    return diff > 0 ? diff : 1;
  }

  int get _carRentalCost => widget.car.hargaSewa * _rentalDays;
  int get _driverCost =>
      _useDriver ? (widget.car.hargaSopir * _rentalDays) : 0;
  int get _totalCost => _carRentalCost + _driverCost;

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: AppTheme.cardColor,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _submitBooking() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final orderCode =
        'TRX-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

    final newOrder = RentalOrder(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      kodeOrders: orderCode,
      namaPemesan: _nameController.text.trim(),
      email: _emailController.text.trim(),
      noTelpon: _phoneController.text.trim(),
      keterangan: _notesController.text.trim(),
      jemput: _pickupController.text.trim(),
      tujuan: _destinationController.text.trim(),
      status: 'Proses',
      waktu: now,
      car: widget.car,
      driver: _useDriver ? _selectedDriver : null,
      pakaiSopir: _useDriver,
      dariTanggal: _startDate,
      sampaiTanggal: _endDate,
      sewaPerhari: widget.car.hargaSewa,
      totalHari: _rentalDays,
      totalHarga: _totalCost,
      bankPembayaran: '${_selectedPayment.category} (${_selectedPayment.channel})',
      userId: TripRentStore.instance.currentUser?.id ?? 'guest',
      driverId: _useDriver ? _selectedDriver?.id : null,
      driverTaskStatus: 'Menunggu Konfirmasi',
      paymentStatus: 'Menunggu Verifikasi',
      paymentMethodType: _selectedPayment.category,
    );

    TripRentStore.instance.addOrder(newOrder);

    Navigator.pop(context);

    if (widget.onBookingConfirmed != null) {
      widget.onBookingConfirmed!(newOrder);
    }

    _showSuccessReceipt(context, newOrder);
  }

  void _showSuccessReceipt(BuildContext context, RentalOrder order) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppTheme.cardBorder),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryLight.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Pesanan Berhasil!',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Terima kasih telah menggunakan TripRent. Detail pesanan telah dikirim melalui email dan WhatsApp.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Text(
                  'No. Transaksi: ${order.kodeOrders}',
                  style: const TextStyle(
                    color: AppTheme.primaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _receiptRow('Mobil', order.car.nama),
                    _receiptRow('Durasi', '${order.totalHari} Hari'),
                    _receiptRow('Layanan', order.pakaiSopir ? 'Dengan Sopir' : 'Lepas Kunci'),
                    const Divider(color: AppTheme.cardBorder, height: 16),
                    _receiptRow('Total Biaya', Formatters.rupiah(order.totalHarga), isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Lihat Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                    side: const BorderSide(color: AppTheme.cardBorder),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Kembali ke Beranda', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _receiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          Text(
            value,
            style: TextStyle(
              color: isBold ? AppTheme.success : AppTheme.textPrimary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBorder,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Title Bar (Screen 7 Reference)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ringkasan Pesanan',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppTheme.textMuted, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Header with Car Summary
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.car.gambarUtama,
                          width: 70,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 70,
                            height: 50,
                            color: AppTheme.cardColor,
                            child: const Icon(Icons.directions_car, color: AppTheme.textMuted),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.car.nama,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _useDriver
                                  ? '${Formatters.rupiah(widget.car.hargaSewa + widget.car.hargaSopir)} /hari • Mobil + Sopir'
                                  : '${Formatters.rupiah(widget.car.hargaSewa)} /hari • ${widget.car.termasuk.toLowerCase().contains("mobil saja") ? "Mobil Saja (Lepas Kunci)" : widget.car.termasuk}',
                              style: const TextStyle(
                                color: AppTheme.primaryLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppTheme.cardBorder),
                  const SizedBox(height: 16),

                  // Date Range Picker Button
                  const Text(
                    'Jadwal Sewa Mobil',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectDateRange,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_rounded,
                                  color: AppTheme.primaryLight, size: 20),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${Formatters.dateShort(_startDate)} - ${Formatters.dateShort(_endDate)}',
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '$_rentalDays Hari Sewa',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.edit_calendar_rounded,
                              color: AppTheme.textSecondary, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Driver Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Gunakan Jasa Sopir',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _useDriver
                                        ? AppTheme.primary.withValues(alpha: 0.15)
                                        : AppTheme.cardColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _useDriver ? AppTheme.primaryLight : AppTheme.cardBorder,
                                    ),
                                  ),
                                  child: Text(
                                    _useDriver ? 'Aktif' : 'Lepas Kunci',
                                    style: TextStyle(
                                      color: _useDriver ? AppTheme.primaryLight : AppTheme.textMuted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _useDriver
                                  ? '+ ${Formatters.rupiah(widget.car.hargaSopir)} /hari (Sopir Berpengalaman)'
                                  : 'Opsional (+ ${Formatters.rupiah(widget.car.hargaSopir)} /hari jika ingin sopir)',
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _useDriver,
                        activeThumbColor: AppTheme.primaryLight,
                        onChanged: (val) {
                          setState(() {
                            _useDriver = val;
                          });
                        },
                      ),
                    ],
                  ),

                  // Select Driver Dropdown if active
                  if (_useDriver && TripRentStore.instance.drivers.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Driver>(
                          value: _selectedDriver,
                          isExpanded: true,
                          dropdownColor: AppTheme.cardColor,
                          items: TripRentStore.instance.drivers.map((drv) {
                            return DropdownMenuItem<Driver>(
                              value: drv,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundImage: NetworkImage(drv.foto),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${drv.nama} (★ ${drv.rating})',
                                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedDriver = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Customer Form
                  const Text(
                    'Informasi Pemesan & Rute',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInputField('Nama Pemesan', _nameController, Icons.person_outline),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField('No. WhatsApp/HP', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField('Email', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LocationAutocompleteField(
                    label: 'Lokasi Penjemputan',
                    controller: _pickupController,
                    icon: Icons.location_on_outlined,
                    hintText: 'Contoh: Indramayu, Bandara BIM, Hotel...',
                  ),
                  const SizedBox(height: 10),
                  LocationAutocompleteField(
                    label: 'Lokasi Tujuan',
                    controller: _destinationController,
                    icon: Icons.flag_outlined,
                    hintText: 'Contoh: Padang, Bukittinggi, Jakarta...',
                  ),
                  const SizedBox(height: 10),
                  _buildInputField('Catatan Khusus (Opsional)', _notesController, Icons.notes_outlined, maxLines: 2),

                  const SizedBox(height: 20),
                  // Payment Method Selector
                  PaymentMethodSelector(
                    initialSelection: _selectedPayment,
                    onSelectionChanged: (sel) {
                      setState(() => _selectedPayment = sel);
                    },
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.cardBorder),
                  const SizedBox(height: 12),

                  // Cost Calculation Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Column(
                      children: [
                        _costRow('Sewa Mobil ($_rentalDays hari)', Formatters.rupiah(_carRentalCost)),
                        if (_useDriver)
                          _costRow('Sopir (${Formatters.rupiah(widget.car.hargaSopir)} x $_rentalDays hari)', Formatters.rupiah(_driverCost)),
                        const Divider(color: AppTheme.cardBorder, height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pembayaran',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              Formatters.rupiah(_totalCost),
                              style: const TextStyle(
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit Button (Screen 7 & 8 Reference)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Lanjut ke Pembayaran',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
        prefixIcon: Icon(icon, color: AppTheme.primaryLight, size: 18),
        filled: true,
        fillColor: AppTheme.cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryLight),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.danger),
        ),
      ),
    );
  }

  Widget _costRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          Text(amount, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
