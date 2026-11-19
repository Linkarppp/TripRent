import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/order.dart';
import '../models/travel_ticket.dart';
import '../theme/app_theme.dart';
import '../widgets/formatters.dart';
import '../widgets/location_autocomplete_field.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/shuttle_eticket_card.dart';
import 'shuttle_schedule_screen.dart';

class TicketBookingSheet extends StatefulWidget {
  final TravelTicket? initialTicket;

  const TicketBookingSheet({super.key, this.initialTicket});

  @override
  State<TicketBookingSheet> createState() => _TicketBookingSheetState();
}

class _TicketBookingSheetState extends State<TicketBookingSheet> {
  final _formKey = GlobalKey<FormState>();

  late TravelTicket _selectedTicket;
  late String _selectedTime;
  late DateTime _travelDate;
  int _seatCount = 1;

  bool _isCustomRoute = false;
  late final TextEditingController _originController;
  late final TextEditingController _destinationController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pickupNoteController =
      TextEditingController(text: 'Titik jemput: Di depan lobi');

  PaymentSelection _selectedPayment = const PaymentSelection(
    category: 'Transfer Bank',
    channel: 'BCA',
    accountNumber: '0320-9436-47',
    accountHolder: 'PT TripRent Nusantara',
    instructions: 'Transfer tepat hingga 3 digit terakhir untuk verifikasi otomatis instan.',
  );

  @override
  void initState() {
    super.initState();
    final tickets = TripRentStore.instance.tickets;
    _selectedTicket = widget.initialTicket ?? tickets.first;
    _selectedTime = _selectedTicket.departureTimes.first;
    _travelDate = DateTime.now().add(const Duration(days: 1));

    _originController = TextEditingController(text: _selectedTicket.origin);
    _destinationController = TextEditingController(text: _selectedTicket.destination);

    final user = TripRentStore.instance.currentUser;
    if (user != null) {
      _nameController.text = user.namaLengkap;
      _phoneController.text = user.noTelp;
      _emailController.text = user.email;
    } else {
      _nameController.text = '';
      _phoneController.text = '';
      _emailController.text = '';
    }
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _pickupNoteController.dispose();
    super.dispose();
  }

  int get _totalPrice => _selectedTicket.price * _seatCount;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _travelDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
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
      setState(() => _travelDate = picked);
    }
  }

  void _submitTicketOrder() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final orderCode =
        'TKT-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

    final associatedCar = TripRentStore.instance.cars.firstWhere(
      (c) => c.category == 'Family Van' || c.category == 'Executive',
      orElse: () => TripRentStore.instance.cars.first,
    );

    final effectiveOrigin = _isCustomRoute ? _originController.text.trim() : _selectedTicket.origin;
    final effectiveDestination = _isCustomRoute ? _destinationController.text.trim() : _selectedTicket.destination;
    final effectiveTitle = _isCustomRoute
        ? '$effectiveOrigin ➔ $effectiveDestination'
        : _selectedTicket.title;

    final newOrder = RentalOrder(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      kodeOrders: orderCode,
      namaPemesan: _nameController.text.trim(),
      email: _emailController.text.trim(),
      noTelpon: _phoneController.text.trim(),
      keterangan: 'Tiket Perjalanan: $effectiveTitle | Jam: $_selectedTime | Jumlah Kursi: $_seatCount | Catatan: ${_pickupNoteController.text.trim()}',
      jemput: effectiveOrigin,
      tujuan: effectiveDestination,
      status: 'Proses',
      waktu: now,
      car: associatedCar,
      driver: TripRentStore.instance.drivers.isNotEmpty ? TripRentStore.instance.drivers.first : null,
      pakaiSopir: true,
      dariTanggal: _travelDate,
      sampaiTanggal: _travelDate,
      sewaPerhari: _selectedTicket.price,
      totalHari: 1,
      totalHarga: _totalPrice,
      bankPembayaran: '${_selectedPayment.category} (${_selectedPayment.channel})',
      isTicket: true,
      ticketTitle: effectiveTitle,
      userId: TripRentStore.instance.currentUser?.id ?? 'guest',
      driverId: TripRentStore.instance.drivers.isNotEmpty ? TripRentStore.instance.drivers.first.id : null,
      driverTaskStatus: 'Menunggu Konfirmasi',
      paymentStatus: 'Menunggu Verifikasi',
      passengerCount: _seatCount,
      seatNumbers: 'Kursi Terkonfirmasi',
      paymentMethodType: _selectedPayment.category,
      departureTime: '$_selectedTime WIB',
    );

    TripRentStore.instance.addOrder(newOrder);

    Navigator.pop(context);
    _showSuccessTicketDialog(context, newOrder);
  }

  void _showSuccessTicketDialog(BuildContext context, RentalOrder order) {
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
                  Icons.confirmation_num_rounded,
                  color: AppTheme.success,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pembelian Tiket Berhasil!',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Kode Tiket:\n${order.kodeOrders}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.primaryLight,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
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
                    _dialogRow('Rute', _selectedTicket.title),
                    _dialogRow('Jadwal', '${Formatters.dateShort(_travelDate)}, $_selectedTime WIB'),
                    _dialogRow('Armada', _selectedTicket.vehicleName),
                    _dialogRow('Penumpang', '$_seatCount Orang (${order.namaPemesan})'),
                    const Divider(color: AppTheme.cardBorder, height: 16),
                    _dialogRow('Total Bayar', Formatters.rupiah(order.totalHarga), isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Silakan lakukan pembayaran via ${order.bankPembayaran} untuk validasi e-tiket Anda.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: const BorderSide(color: AppTheme.cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Bayar Nanti'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        TripRentStore.instance.verifyPayment(order.kodeOrders, 'Lunas');
                        final lunasOrder = order.copyWith(paymentStatus: 'Lunas');
                        showShuttleETicketModal(context, lunasOrder);
                      },
                      icon: const Icon(Icons.confirmation_num_rounded, size: 16),
                      label: const Text('Buka E-Tiket', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dialogRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isBold ? AppTheme.primaryLight : AppTheme.textPrimary,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                fontSize: isBold ? 13 : 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tickets = TripRentStore.instance.tickets;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Drag Handle & Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.cardBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.confirmation_num_rounded, color: AppTheme.primaryLight, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Beli Tiket Perjalanan',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.textMuted),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppTheme.cardBorder, height: 1),

                // Form body
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Real Life Shuttle Schedule & Seat Picker Banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.airport_shuttle_rounded, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cari Jadwal Shuttle Lengkap',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Pilih jam keberangkatan & nomor kursi interaktif',
                                    style: TextStyle(color: Colors.white70, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShuttleScheduleScreen(
                                      initialOrigin: _selectedTicket.origin,
                                      initialDestination: _selectedTicket.destination,
                                      initialDate: _travelDate,
                                      initialPassengers: _seatCount,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Cek Jadwal'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Pilih Layanan Tiket & Mode Rute
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pilih Rute & Layanan Tiket',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isCustomRoute = !_isCustomRoute;
                                if (!_isCustomRoute) {
                                  _originController.text = _selectedTicket.origin;
                                  _destinationController.text = _selectedTicket.destination;
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    _isCustomRoute ? Icons.list_alt_rounded : Icons.edit_location_alt_rounded,
                                    size: 15,
                                    color: AppTheme.primaryLight,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isCustomRoute ? 'Pilih Paket Rute' : 'Input Rute Sendiri',
                                    style: const TextStyle(
                                      color: AppTheme.primaryLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Jika mode paket rute: Dropdown pilihan
                      if (!_isCustomRoute) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.cardBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<TravelTicket>(
                              value: _selectedTicket,
                              isExpanded: true,
                              dropdownColor: AppTheme.cardColor,
                              items: tickets.map((t) {
                                return DropdownMenuItem<TravelTicket>(
                                  value: t,
                                  child: Text(
                                    '${t.title} (${Formatters.rupiah(t.price)})',
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedTicket = val;
                                    _originController.text = val.origin;
                                    _destinationController.text = val.destination;
                                    if (!val.departureTimes.contains(_selectedTime)) {
                                      _selectedTime = val.departureTimes.first;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Jika mode input rute sendiri (seperti Traveloka)
                      if (_isCustomRoute) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4), width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Rute Kustom (Traveloka Style)',
                                      style: TextStyle(
                                        color: AppTheme.primaryLight,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.swap_vert_rounded, color: AppTheme.primaryLight, size: 20),
                                    tooltip: 'Tukar Asal & Tujuan',
                                    onPressed: () {
                                      setState(() {
                                        final temp = _originController.text;
                                        _originController.text = _destinationController.text;
                                        _destinationController.text = temp;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LocationAutocompleteField(
                                label: 'Kota / Titik Keberangkatan (Asal)',
                                controller: _originController,
                                icon: Icons.trip_origin_rounded,
                                hintText: 'Ketik kota asal, bandara, terminal...',
                              ),
                              const SizedBox(height: 10),
                              LocationAutocompleteField(
                                label: 'Kota / Titik Kedatangan (Tujuan)',
                                controller: _destinationController,
                                icon: Icons.location_on_rounded,
                                hintText: 'Ketik kota tujuan, hotel, alamat...',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Ticket Card Info Preview (Traveloka Ticket Card)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _selectedTicket.category,
                                    style: const TextStyle(
                                      color: AppTheme.primaryLight,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  Formatters.rupiah(_selectedTicket.price),
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const Text(
                                  ' /kursi',
                                  style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.trip_origin_rounded, size: 14, color: AppTheme.primaryLight),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _isCustomRoute ? _originController.text : _selectedTicket.origin,
                                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(Icons.more_vert, size: 12, color: AppTheme.textMuted),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.error),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _isCustomRoute ? _destinationController.text : _selectedTicket.destination,
                                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Armada: ${_selectedTicket.vehicleName} • Estimasi: ${_selectedTicket.estimatedDuration}',
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Travel Date
                      const Text(
                        'Tanggal Keberangkatan',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.cardBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_rounded, color: AppTheme.primaryLight, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                Formatters.dateMedium(_travelDate),
                                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              const Text('Ubah', style: TextStyle(color: AppTheme.primaryLight, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Departure Time Selection
                      const Text(
                        'Pilih Jam Keberangkatan',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedTicket.departureTimes.map((time) {
                          final isSelected = _selectedTime == time;
                          return ChoiceChip(
                            label: Text('$time WIB'),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedTime = time);
                            },
                            selectedColor: AppTheme.primary,
                            backgroundColor: AppTheme.cardColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            side: BorderSide(
                              color: isSelected ? AppTheme.primaryLight : AppTheme.cardBorder,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Seat Quantity Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah Kursi / Tiket',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Maksimal 6 kursi per transaksi',
                                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16, color: AppTheme.textPrimary),
                                  onPressed: _seatCount > 1 ? () => setState(() => _seatCount--) : null,
                                ),
                                Text(
                                  '$_seatCount Kursi',
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16, color: AppTheme.textPrimary),
                                  onPressed: _seatCount < 6 ? () => setState(() => _seatCount++) : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Passenger Info
                      const Text(
                        'Data Pemesan / Penumpang',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap Pemesan',
                          labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          prefixIcon: const Icon(Icons.person_outline, color: AppTheme.primaryLight, size: 18),
                          filled: true,
                          fillColor: AppTheme.cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.cardBorder),
                          ),
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: 'Nomor WhatsApp / HP',
                          labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          prefixIcon: const Icon(Icons.phone_outlined, color: AppTheme.primaryLight, size: 18),
                          filled: true,
                          fillColor: AppTheme.cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.cardBorder),
                          ),
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Nomor HP wajib diisi' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: 'Email Konfirmasi Tiket',
                          labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.primaryLight, size: 18),
                          filled: true,
                          fillColor: AppTheme.cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.cardBorder),
                          ),
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Email wajib diisi' : null,
                      ),
                      const SizedBox(height: 20),

                      // 4 Metode Pembayaran Tersedia
                      const Text(
                        'Pilihan Metode Pembayaran',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PaymentMethodSelector(
                        initialSelection: _selectedPayment,
                        onSelectionChanged: (sel) {
                          setState(() => _selectedPayment = sel);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Bottom Checkout Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                  decoration: const BoxDecoration(
                    color: AppTheme.cardColor,
                    border: Border(top: BorderSide(color: AppTheme.cardBorder)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Total Pembayaran',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                            ),
                            Text(
                              Formatters.rupiah(_totalPrice),
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitTicketOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Beli Tiket Sekarang',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
