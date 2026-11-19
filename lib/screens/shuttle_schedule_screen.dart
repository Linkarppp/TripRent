import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/order.dart';
import '../models/shuttle_schedule.dart';
import '../theme/app_theme.dart';
import '../widgets/formatters.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/shuttle_eticket_card.dart';

class ShuttleScheduleScreen extends StatefulWidget {
  final String initialOrigin;
  final String initialDestination;
  final DateTime initialDate;
  final int initialPassengers;

  const ShuttleScheduleScreen({
    super.key,
    this.initialOrigin = 'Padang (Pool Tunggul Hitam)',
    this.initialDestination = 'Bukittinggi (Pool Jam Gadang)',
    required this.initialDate,
    this.initialPassengers = 1,
  });

  @override
  State<ShuttleScheduleScreen> createState() => _ShuttleScheduleScreenState();
}

class _ShuttleScheduleScreenState extends State<ShuttleScheduleScreen> {
  late String _origin;
  late String _destination;
  late DateTime _selectedDate;
  late int _passengers;
  String _selectedTimeFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _origin = widget.initialOrigin;
    _destination = widget.initialDestination;
    _selectedDate = widget.initialDate;
    _passengers = widget.initialPassengers;
  }

  void _swapRoute() {
    setState(() {
      final temp = _origin;
      _origin = _destination;
      _destination = temp;
    });
  }

  List<ShuttleSchedule> _getFilteredSchedules() {
    final all = ShuttleDataHelper.getSchedules(
      origin: _origin,
      destination: _destination,
      date: _selectedDate,
      passengers: _passengers,
    );

    if (_selectedTimeFilter == 'Semua') return all;
    return all.where((s) => s.timeOfDayCategory == _selectedTimeFilter).toList();
  }

  void _showModifySearchDialog() {
    String tempOrigin = _origin;
    String tempDestination = _destination;
    DateTime tempDate = _selectedDate;
    int tempPassengers = _passengers;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final outlets = ShuttleDataHelper.outlets.map((o) => o.displayName).toList();

            return Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ubah Rute & Jadwal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppTheme.textMuted),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Asal
                  const Text('Keberangkatan / Outlet Asal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: outlets.contains(tempOrigin) ? tempOrigin : outlets.first,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.primaryLight),
                        items: outlets.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary)))).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => tempOrigin = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Swap Button
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.swap_vert_rounded, color: AppTheme.primaryLight, size: 28),
                      onPressed: () {
                        setModalState(() {
                          final t = tempOrigin;
                          tempOrigin = tempDestination;
                          tempDestination = t;
                        });
                      },
                    ),
                  ),

                  // Tujuan
                  const Text('Tujuan / Outlet Tujuan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: outlets.contains(tempDestination) ? tempDestination : outlets[1],
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.primaryLight),
                        items: outlets.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary)))).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => tempDestination = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tanggal & Penumpang
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tanggal Pergi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: tempDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 90)),
                                );
                                if (picked != null) {
                                  setModalState(() => tempDate = picked);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppTheme.cardBorder),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppTheme.primaryLight),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        Formatters.dateShort(tempDate),
                                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jumlah Penumpang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppTheme.cardBorder),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: tempPassengers,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.primaryLight),
                                  items: [1, 2, 3, 4, 5, 6].map((p) => DropdownMenuItem(value: p, child: Text('$p Orang', style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary)))).toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => tempPassengers = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Terapkan Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _origin = tempOrigin;
                          _destination = tempDestination;
                          _selectedDate = tempDate;
                          _passengers = tempPassengers;
                        });
                        Navigator.pop(ctx);
                      },
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Terapkan Perubahan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openBookingSheet(ShuttleSchedule schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ShuttleBookingSheet(
        schedule: schedule,
        date: _selectedDate,
        passengers: _passengers,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedules = _getFilteredSchedules();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Jadwal Keberangkatan Shuttle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppTheme.cardBorder, height: 1),
        ),
      ),
      body: Column(
        children: [
          // Pinned Route Summary Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.trip_origin_rounded, size: 14, color: AppTheme.success),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _origin,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: SizedBox(
                              height: 12,
                              child: VerticalDivider(color: AppTheme.cardBorder, thickness: 1.5),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 15, color: AppTheme.danger),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _destination,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.swap_horiz_rounded, color: AppTheme.primaryLight),
                      tooltip: 'Tukar Rute',
                      onPressed: _swapRoute,
                    ),
                    OutlinedButton.icon(
                      onPressed: _showModifySearchDialog,
                      icon: const Icon(Icons.tune_rounded, size: 14),
                      label: const Text('Ubah'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(color: AppTheme.cardBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppTheme.cardBorder),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.primaryLight),
                        const SizedBox(width: 6),
                        Text(
                          Formatters.dateShort(_selectedDate),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.people_alt_rounded, size: 14, color: AppTheme.primaryLight),
                        const SizedBox(width: 6),
                        Text(
                          '$_passengers Penumpang',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    Text(
                      '${schedules.length} Jadwal Tersedia',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.primaryLight),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Date Strip Picker (Hari Ini, Besok, Lusa)
          _buildDateSelectorStrip(),

          // Time Filter Chips
          _buildTimeFilterChips(),

          // Schedules List
          Expanded(
            child: schedules.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: AppTheme.surfaceLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.event_busy_rounded, size: 48, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tidak Ada Jadwal Tersedia',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tidak ditemukan jadwal untuk kategori "$_selectedTimeFilter" pada tanggal yang dipilih. Coba pilih waktu atau tanggal lain.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: schedules.length,
                    itemBuilder: (ctx, idx) {
                      final item = schedules[idx];
                      return _buildScheduleCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectorStrip() {
    final now = DateTime.now();
    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (ctx, idx) {
          final date = now.add(Duration(days: idx));
          final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;

          String dayName = idx == 0 ? 'Hari Ini' : (idx == 1 ? 'Besok' : _getDayName(date.weekday));

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedDate = date),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$dayName, ${date.day}/${date.month}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Sen';
      case 2:
        return 'Sel';
      case 3:
        return 'Rab';
      case 4:
        return 'Kam';
      case 5:
        return 'Jum';
      case 6:
        return 'Sab';
      case 7:
      default:
        return 'Min';
    }
  }

  Widget _buildTimeFilterChips() {
    final filters = ['Semua', 'Pagi', 'Siang', 'Sore', 'Malam'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: filters.map((f) {
          final isSel = _selectedTimeFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(f),
              selected: isSel,
              selectedColor: AppTheme.primaryLight.withValues(alpha: 0.15),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSel ? AppTheme.primaryLight : AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isSel ? AppTheme.primaryLight : AppTheme.cardBorder),
              ),
              onSelected: (val) {
                if (val) setState(() => _selectedTimeFilter = f);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScheduleCard(ShuttleSchedule schedule) {
    final totalPrice = schedule.price * _passengers;
    final isFewSeats = schedule.availableSeats <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Departure Time, Route arrow, Arrival Time & Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    schedule.departureTime,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_right_alt_rounded, color: AppTheme.primaryLight, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    schedule.arrivalTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  schedule.duration,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Vehicle Name & Seat Counter Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_bus_rounded, size: 16, color: AppTheme.primaryLight),
                  const SizedBox(width: 6),
                  Text(
                    schedule.vehicleName,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isFewSeats ? AppTheme.danger.withValues(alpha: 0.12) : AppTheme.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isFewSeats ? 'Sisa ${schedule.availableSeats} Kursi!' : 'Tersedia ${schedule.availableSeats} Kursi',
                  style: TextStyle(
                    color: isFewSeats ? AppTheme.danger : AppTheme.success,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Facilities row
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: schedule.facilities.map((f) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  f,
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppTheme.cardBorder),
          const SizedBox(height: 12),

          // Price & Select Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Formatters.rupiah(schedule.price)} / kursi',
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Formatters.rupiah(totalPrice),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                  if (_passengers > 1)
                    Text(
                      'Total ($_passengers Penumpang)',
                      style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                    ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _openBookingSheet(schedule),
                icon: const Icon(Icons.event_seat_rounded, size: 16),
                label: const Text('Pilih Kursi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MODAL SEAT SELECTION & PASSENGER CONFIRMATION SHEET
// ============================================================================
class _ShuttleBookingSheet extends StatefulWidget {
  final ShuttleSchedule schedule;
  final DateTime date;
  final int passengers;

  const _ShuttleBookingSheet({
    required this.schedule,
    required this.date,
    required this.passengers,
  });

  @override
  State<_ShuttleBookingSheet> createState() => _ShuttleBookingSheetState();
}

class _ShuttleBookingSheetState extends State<_ShuttleBookingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _noteController = TextEditingController(text: 'Di depan lobi pool keberangkatan');

  final List<int> _selectedSeatNumbers = [];
  PaymentSelection _selectedPayment = const PaymentSelection(
    category: 'Transfer Bank',
    channel: 'BCA',
    accountNumber: '0320-9436-47',
    accountHolder: 'PT TripRent Nusantara',
    instructions: 'Transfer tepat hingga 3 digit terakhir untuk verifikasi otomatis instan.',
  );
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = TripRentStore.instance.currentUser;
    if (user != null) {
      _nameController.text = user.namaLengkap;
      _phoneController.text = user.noTelp;
      _emailController.text = user.email;
    }

    // Auto-select first available seats according to passenger count
    for (int i = 1; i <= widget.schedule.totalSeats; i++) {
      if (!widget.schedule.occupiedSeats.contains(i)) {
        _selectedSeatNumbers.add(i);
        if (_selectedSeatNumbers.length == widget.passengers) break;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleSeat(int seatNumber) {
    if (widget.schedule.occupiedSeats.contains(seatNumber)) return;

    setState(() {
      if (_selectedSeatNumbers.contains(seatNumber)) {
        _selectedSeatNumbers.remove(seatNumber);
      } else {
        if (_selectedSeatNumbers.length < widget.passengers) {
          _selectedSeatNumbers.add(seatNumber);
        } else {
          // Replace last selected
          _selectedSeatNumbers.removeLast();
          _selectedSeatNumbers.add(seatNumber);
        }
      }
    });
  }

  void _confirmBooking() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSeatNumbers.length < widget.passengers) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan pilih ${_passengersCountText()} terlebih dahulu.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    final orderCode =
        'SHU-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

    final associatedCar = TripRentStore.instance.cars.firstWhere(
      (c) => c.category == 'Family Van' || c.category == 'Executive',
      orElse: () => TripRentStore.instance.cars.first,
    );

    final totalHarga = widget.schedule.price * widget.passengers;
    final seatText = _selectedSeatNumbers.join(', ');

    final newOrder = RentalOrder(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      kodeOrders: orderCode,
      namaPemesan: _nameController.text.trim(),
      email: _emailController.text.trim(),
      noTelpon: _phoneController.text.trim(),
      keterangan: 'Shuttle ${widget.schedule.routeTitle} | Kursi: [$seatText] | Jam: ${widget.schedule.departureTime} WIB | Catatan: ${_noteController.text.trim()}',
      jemput: widget.schedule.originOutlet,
      tujuan: widget.schedule.destinationOutlet,
      status: 'Proses',
      waktu: now,
      car: associatedCar,
      driver: TripRentStore.instance.drivers.isNotEmpty ? TripRentStore.instance.drivers.first : null,
      pakaiSopir: true,
      dariTanggal: widget.date,
      sampaiTanggal: widget.date,
      sewaPerhari: widget.schedule.price,
      totalHari: 1,
      totalHarga: totalHarga,
      bankPembayaran: '${_selectedPayment.category} (${_selectedPayment.channel})',
      isTicket: true,
      ticketTitle: widget.schedule.routeTitle,
      userId: TripRentStore.instance.currentUser?.id ?? 'guest',
      driverId: TripRentStore.instance.drivers.isNotEmpty ? TripRentStore.instance.drivers.first.id : null,
      driverTaskStatus: 'Menunggu Konfirmasi',
      paymentStatus: 'Menunggu Verifikasi',
      passengerCount: widget.passengers,
      seatNumbers: 'Kursi $seatText',
      paymentMethodType: _selectedPayment.category,
      departureTime: '${widget.schedule.departureTime} WIB',
    );

    TripRentStore.instance.addOrder(newOrder);

    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pop(context); // close sheet

    _showSuccessDialog(newOrder, seatText);
  }

  String _passengersCountText() => '${widget.passengers} kursi';

  void _showSuccessDialog(RentalOrder order, String seatText) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 44),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pemesanan Shuttle Berhasil!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'Kode Tiket: ${order.kodeOrders}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryLight, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _dialogRow('Rute', widget.schedule.routeTitle),
                  _dialogRow('Jadwal', '${Formatters.dateShort(widget.date)}, ${widget.schedule.departureTime} WIB'),
                  _dialogRow('Nomor Kursi', 'Kursi $seatText'),
                  _dialogRow('Armada', widget.schedule.vehicleName),
                  _dialogRow('Pemesan', order.namaPemesan),
                  const Divider(color: AppTheme.cardBorder, height: 16),
                  _dialogRow('Total Tagihan', Formatters.rupiah(order.totalHarga), isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Silakan lakukan pembayaran via ${order.bankPembayaran} untuk menerbitkan e-tiket Anda.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context); // return to previous screen
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      side: const BorderSide(color: AppTheme.cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Bayar Nanti'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                      // Konfirmasi lunas otomatis
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? AppTheme.primaryLight : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.schedule.price * widget.passengers;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle & Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(color: AppTheme.cardBorder, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.schedule.routeTitle,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                        Text(
                          '${Formatters.dateShort(widget.date)} • ${widget.schedule.departureTime} WIB (${widget.schedule.vehicleName})',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.cardBorder),

          // Scrollable Form & Seat Map
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Visual Seat Selector Section
                    const Text('Pilih Nomor Kursi Shuttle', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 4),
                    Text(
                      'Pilih ${widget.passengers} kursi yang Anda inginkan (Tersedia ${_selectedSeatNumbers.length}/${widget.passengers} dipilih)',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 14),

                    // Visual Van Layout
                    _buildVanSeatMap(),
                    const SizedBox(height: 20),
                    const Divider(color: AppTheme.cardBorder),
                    const SizedBox(height: 14),

                    // Data Pemesan Form
                    const Text('Informasi Kontak Pemesan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                      decoration: _inputDeco('Nama Lengkap Penumpang', Icons.person_outline_rounded),
                      validator: (v) => v!.trim().isEmpty ? 'Nama pemesan wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                            decoration: _inputDeco('No. WhatsApp / HP', Icons.phone_outlined),
                            validator: (v) => v!.trim().isEmpty ? 'No. HP wajib diisi' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                            decoration: _inputDeco('Email Pemesan', Icons.email_outlined),
                            validator: (v) => v!.trim().isEmpty ? 'Email wajib diisi' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _noteController,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                      decoration: _inputDeco('Catatan Titik Kumpul / Jemput', Icons.notes_rounded),
                    ),
                    const SizedBox(height: 20),

                    // Pilihan Metode Pembayaran
                    const Text('Pilihan Metode Pembayaran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 10),
                    PaymentMethodSelector(
                      initialSelection: _selectedPayment,
                      onSelectionChanged: (sel) {
                        setState(() => _selectedPayment = sel);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar (Price & Confirmation)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppTheme.cardBorder)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Bayar (${widget.passengers} Tiket)', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        Text(
                          Formatters.rupiah(totalPrice),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryLight),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Konfirmasi & Pesan', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVanSeatMap() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          // Legend row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _legendItem(Colors.white, AppTheme.cardBorder, 'Tersedia'),
              _legendItem(AppTheme.primary, AppTheme.primary, 'Pilihan Anda'),
              _legendItem(AppTheme.textMuted.withValues(alpha: 0.3), Colors.transparent, 'Terisi'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.cardBorder),
          const SizedBox(height: 16),

          // Front Cabin (Supir + Seat 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.4)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.airline_seat_recline_normal_rounded, color: AppTheme.primary, size: 24),
                    SizedBox(height: 2),
                    Text('Supir', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_upward_rounded, color: AppTheme.textMuted, size: 20),
              _buildSeatButton(1),
            ],
          ),
          const SizedBox(height: 14),

          // Row 2 (Seats 2, 3, 4)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSeatButton(2),
              _buildSeatButton(3),
              _buildSeatButton(4),
            ],
          ),
          const SizedBox(height: 12),

          // Row 3 (Seats 5, 6, 7)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSeatButton(5),
              _buildSeatButton(6),
              _buildSeatButton(7),
            ],
          ),
          const SizedBox(height: 12),

          // Row 4 (Seats 8, 9, 10)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSeatButton(8),
              _buildSeatButton(9),
              _buildSeatButton(10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color fill, Color border, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
      ],
    );
  }

  Widget _buildSeatButton(int seatNumber) {
    final isOccupied = widget.schedule.occupiedSeats.contains(seatNumber);
    final isSelected = _selectedSeatNumbers.contains(seatNumber);

    Color bgColor = Colors.white;
    Color textColor = AppTheme.textPrimary;
    Color borderColor = AppTheme.cardBorder;

    if (isOccupied) {
      bgColor = AppTheme.textMuted.withValues(alpha: 0.2);
      textColor = AppTheme.textMuted;
      borderColor = Colors.transparent;
    } else if (isSelected) {
      bgColor = AppTheme.primary;
      textColor = Colors.white;
      borderColor = AppTheme.primary;
    }

    return InkWell(
      onTap: isOccupied ? null : () => _toggleSeat(seatNumber),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow: isSelected
              ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              Icons.event_seat_rounded,
              color: isSelected ? Colors.white : (isOccupied ? AppTheme.textMuted : AppTheme.primaryLight),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              'Kursi $seatNumber',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12.5),
      prefixIcon: Icon(icon, color: AppTheme.primaryLight, size: 20),
      filled: true,
      fillColor: AppTheme.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.cardBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.cardBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primaryLight, width: 1.5)),
    );
  }
}
