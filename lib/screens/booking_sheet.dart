import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/driver.dart';
import '../models/order.dart';
import '../data/mock_database.dart';
import '../theme/app_theme.dart';
import '../widgets/formatters.dart';

class BookingSheet extends StatefulWidget {
  final Car car;
  final Function(RentalOrder createdOrder)? onBookingConfirmed;

  const BookingSheet({
    super.key,
    required this.car,
    this.onBookingConfirmed,
  });

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _startDate;
  late DateTime _endDate;
  bool _useDriver = true;
  Driver? _selectedDriver;

  final TextEditingController _nameController =
      TextEditingController(text: 'Rahmat Hidayat');
  final TextEditingController _phoneController =
      TextEditingController(text: '0812-3456-7890');
  final TextEditingController _emailController =
      TextEditingController(text: 'rahmat.hidayat@example.com');
  final TextEditingController _pickupController =
      TextEditingController(text: 'Bandara Internasional Minangkabau (BIM)');
  final TextEditingController _destinationController =
      TextEditingController(text: 'Pusat Kota Padang & Wisata Pantai');
  final TextEditingController _notesController =
      TextEditingController(text: 'Mohon siapkan mobil dalam kondisi bersih.');

  late String _selectedBank;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now().add(const Duration(days: 1));
    _endDate = _startDate.add(Duration(days: widget.car.durasi));
    final drivers = TripRentStore.instance.drivers;
    if (drivers.isNotEmpty) {
      _selectedDriver = drivers.first;
    }
    final banks = TripRentStore.instance.companyProfile.bankAccounts;
    _selectedBank = banks.isNotEmpty
        ? '${banks.first.namaBank} - ${banks.first.noRekening}'
        : 'Bank BCA (0320943647)';
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
      bankPembayaran: _selectedBank,
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
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.success,
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pemesanan Berhasil!',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kode Transaksi:\n${order.kodeOrders}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.primaryLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 14),
              Text(
                'Silakan transfer ke ${order.bankPembayaran} untuk konfirmasi pembayaran.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tutup & Cek Pesanan'),
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
                  const SizedBox(height: 18),

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
                              '${Formatters.rupiah(widget.car.hargaSewa)} /hari • ${widget.car.termasuk}',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gunakan Jasa Sopir',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '+ ${Formatters.rupiah(widget.car.hargaSopir)} /hari (Sopir Berpengalaman)',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
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
                  _buildInputField('Lokasi Penjemputan', _pickupController, Icons.location_on_outlined),
                  const SizedBox(height: 10),
                  _buildInputField('Lokasi Tujuan', _destinationController, Icons.flag_outlined),
                  const SizedBox(height: 10),
                  _buildInputField('Catatan Khusus (Opsional)', _notesController, Icons.notes_outlined, maxLines: 2),

                  const SizedBox(height: 20),
                  // Payment Bank Selector
                  const Text(
                    'Pilihan Rekening Pembayaran',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...TripRentStore.instance.companyProfile.bankAccounts.map((b) {
                    final desc = '${b.namaBank} - ${b.noRekening} (a/n ${b.pemilik})';
                    final isSel = _selectedBank == desc;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedBank = desc),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSel ? AppTheme.primary.withValues(alpha: 0.15) : AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSel ? AppTheme.primaryLight : AppTheme.cardBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSel ? AppTheme.primaryLight : AppTheme.textMuted,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.namaBank,
                                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${b.noRekening} a/n ${b.pemilik}',
                                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

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

                  // Submit Button
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
                        elevation: 6,
                        shadowColor: AppTheme.primary.withValues(alpha: 0.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Konfirmasi & Buat Pesanan',
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
