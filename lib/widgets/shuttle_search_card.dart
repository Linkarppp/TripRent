import 'package:flutter/material.dart';
import '../models/shuttle_schedule.dart';
import '../screens/shuttle_schedule_screen.dart';
import '../theme/app_theme.dart';
import 'formatters.dart';

class ShuttleSearchCard extends StatefulWidget {
  final VoidCallback? onSearchCompleted;

  const ShuttleSearchCard({super.key, this.onSearchCompleted});

  @override
  State<ShuttleSearchCard> createState() => _ShuttleSearchCardState();
}

class _ShuttleSearchCardState extends State<ShuttleSearchCard> {
  late String _selectedOrigin;
  late String _selectedDestination;
  DateTime _departureDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _returnDate;
  bool _isRoundTrip = false;
  int _passengerCount = 1;

  final List<String> _outlets = ShuttleDataHelper.outlets.map((o) => o.displayName).toList();

  @override
  void initState() {
    super.initState();
    _selectedOrigin = _outlets.first;
    _selectedDestination = _outlets.length > 2 ? _outlets[2] : _outlets.last;
  }

  void _swapOriginDestination() {
    setState(() {
      final temp = _selectedOrigin;
      _selectedOrigin = _selectedDestination;
      _selectedDestination = temp;
    });
  }

  Future<void> _pickDepartureDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _departureDate = picked;
        if (_returnDate != null && _returnDate!.isBefore(picked)) {
          _returnDate = picked.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _pickReturnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate ?? _departureDate.add(const Duration(days: 1)),
      firstDate: _departureDate,
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _returnDate = picked);
    }
  }

  void _submitSearch() {
    if (_selectedOrigin == _selectedDestination) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kota keberangkatan dan tujuan tidak boleh sama.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShuttleScheduleScreen(
          initialOrigin: _selectedOrigin,
          initialDestination: _selectedDestination,
          initialDate: _departureDate,
          initialPassengers: _passengerCount,
        ),
      ),
    );

    if (widget.onSearchCompleted != null) {
      widget.onSearchCompleted!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Kruzz / Arnes Style)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.airport_shuttle_rounded,
                      color: AppTheme.primaryLight,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pesan Tiket Shuttle TripRent',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Jadwal Harian & Pool Resmi Point-to-Point',
                        style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'RESMI',
                  style: TextStyle(
                    color: AppTheme.success,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 1. KEBERANGKATAN (OUTLET ASAL)
          const Text(
            'Keberangkatan',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppTheme.warning, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _outlets.contains(_selectedOrigin) ? _selectedOrigin : _outlets.first,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textMuted),
                      items: _outlets.map((o) {
                        return DropdownMenuItem(
                          value: o,
                          child: Text(
                            o,
                            style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedOrigin = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Swap Origin & Destination Button
          Center(
            child: InkWell(
              onTap: _swapOriginDestination,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.swap_vert_rounded,
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // 2. TUJUAN (OUTLET TUJUAN)
          const Text(
            'Tujuan',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, color: AppTheme.danger, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _outlets.contains(_selectedDestination) ? _selectedDestination : _outlets[1],
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textMuted),
                      items: _outlets.map((o) {
                        return DropdownMenuItem(
                          value: o,
                          child: Text(
                            o,
                            style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedDestination = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. TANGGAL PERGI & PULANG-PERGI TOGGLE (KRUZZ SHUTTLE STYLE)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tanggal Pergi',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
              ),
              Row(
                children: [
                  const Text('Pulang-Pergi', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  const SizedBox(width: 4),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: _isRoundTrip,
                      activeThumbColor: AppTheme.primaryLight,
                      onChanged: (val) {
                        setState(() {
                          _isRoundTrip = val;
                          if (val && _returnDate == null) {
                            _returnDate = _departureDate.add(const Duration(days: 1));
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Date Pickers Row
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _pickDepartureDate,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 16, color: AppTheme.warning),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            Formatters.dateShort(_departureDate),
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isRoundTrip) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: _pickReturnDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_repeat_rounded, size: 16, color: AppTheme.primaryLight),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _returnDate != null ? Formatters.dateShort(_returnDate!) : 'Pilih Tanggal',
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // 4. JUMLAH PENUMPANG (KRUZZ & ARNES STYLE)
          const Text(
            'Jumlah Penumpang',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded, color: AppTheme.primaryLight, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _passengerCount,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textMuted),
                      items: [1, 2, 3, 4, 5, 6].map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(
                            '$p Penumpang',
                            style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _passengerCount = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5. TOMBOL CARI JADWAL SHUTTLE (PROMINENT CALL TO ACTION)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitSearch,
              icon: const Icon(Icons.search_rounded, size: 20),
              label: const Text(
                'Cari Jadwal Shuttle',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
