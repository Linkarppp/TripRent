import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/car.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_guard.dart';
import '../widgets/car_card.dart';
import '../widgets/formatters.dart';
import 'car_detail_screen.dart';
import 'booking_sheet.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  String _selectedCategory = 'Semua';
  String _sortBy = 'Rekomendasi';
  bool _isGridView = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String _selectedDateRange = '24 - 25 Agu 2026';

  final List<String> _categories = CarCategory.filterList;

  final List<String> _sortOptions = [
    'Rekomendasi',
    'Tarif Terendah',
    'Tarif Tertinggi',
    'Tahun Terbaru',
    'Rating Tertinggi',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetail(Car car) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)),
    );
  }

  void _openBooking(Car car) async {
    final loggedIn = await AuthGuard.requireLogin(
      context,
      message: 'Silakan login terlebih dahulu untuk menyewa mobil ${car.nama}.',
    );
    if (!loggedIn || !mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingSheet(car: car),
    );
  }

  void _selectDate() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: now.add(const Duration(days: 1)),
        end: now.add(const Duration(days: 2)),
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange =
            '${Formatters.dateShort(picked.start)} - ${Formatters.dateShort(picked.end)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        var cars = List<Car>.from(TripRentStore.instance.cars);

        // Filter by category
        if (_selectedCategory != CarCategory.all) {
          cars = cars.where((c) => CarCategory.normalize(c.category) == _selectedCategory).toList();
        }

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          cars = cars.where((c) {
            return c.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                c.mesin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                c.termasuk.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
        }

        // Sort
        switch (_sortBy) {
          case 'Tarif Terendah':
            cars.sort((a, b) => a.hargaSewa.compareTo(b.hargaSewa));
            break;
          case 'Tarif Tertinggi':
            cars.sort((a, b) => b.hargaSewa.compareTo(a.hargaSewa));
            break;
          case 'Tahun Terbaru':
            cars.sort((a, b) => b.tahun.compareTo(a.tahun));
            break;
          case 'Rating Tertinggi':
            cars.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          default:
            break;
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Cari Mobil'),
            actions: [
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                  color: AppTheme.textPrimary,
                ),
                onPressed: () => setState(() => _isGridView = !_isGridView),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              // Search & Date Selector Card (Screen 4 Reference)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cardBorder),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    // Location Input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: AppTheme.primaryLight, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                              onChanged: (val) => setState(() => _searchQuery = val),
                              decoration: const InputDecoration(
                                hintText: 'Ketik kota / nama mobil...',
                                hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Icon(Icons.clear, color: AppTheme.textMuted, size: 16),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Date Input Row
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, color: AppTheme.primaryLight, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedDateRange,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(Icons.edit_calendar_outlined, color: AppTheme.textSecondary, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Categories Scroll (Screen 4 Reference)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  height: 38,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (ctx, idx) {
                      final cat = _categories[idx];
                      final isSel = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? AppTheme.primary : AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSel ? AppTheme.primary : AppTheme.cardBorder,
                            ),
                            boxShadow: isSel ? AppTheme.cardShadow : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (cat != CarCategory.all) ...[
                                Icon(
                                  CarCategory.getCategoryIcon(cat),
                                  size: 14,
                                  color: isSel ? Colors.white : AppTheme.primaryLight,
                                ),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                cat,
                                style: TextStyle(
                                  color: isSel ? Colors.white : AppTheme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Results Count & Sort Dropdown
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menampilkan ${cars.length} Mobil',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _sortBy,
                          dropdownColor: AppTheme.cardColor,
                          icon: const Icon(Icons.sort, color: AppTheme.primaryLight, size: 16),
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 11.5),
                          items: _sortOptions.map((s) {
                            return DropdownMenuItem<String>(
                              value: s,
                              child: Text(s),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _sortBy = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content List or Grid (Matching Screen 5 Horizontal Cards)
              Expanded(
                child: cars.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada mobil yang sesuai filter.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : _isGridView
                        ? GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.74,
                            ),
                            itemCount: cars.length,
                            itemBuilder: (ctx, idx) {
                              final car = cars[idx];
                              return _buildGridCard(car);
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                            itemCount: cars.length,
                            itemBuilder: (ctx, idx) {
                              final car = cars[idx];
                              return CarCard(
                                car: car,
                                isHorizontal: true,
                                onTap: () => _navigateToDetail(car),
                                onBook: () => _openBooking(car),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridCard(Car car) {
    return GestureDetector(
      onTap: () => _navigateToDetail(car),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.cardBorder),
          boxShadow: AppTheme.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    car.gambarUtama,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppTheme.surfaceLight,
                      child: const Center(
                        child: Icon(Icons.directions_car, color: AppTheme.textMuted, size: 36),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFF59E0B), size: 12),
                          const SizedBox(width: 2),
                          Text(
                            car.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.nama,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    car.kapasitas,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${Formatters.rupiah(car.hargaSewa)} /hari',
                    style: const TextStyle(
                      color: AppTheme.primaryLight,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
