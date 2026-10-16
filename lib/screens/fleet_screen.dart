import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/car.dart';
import '../theme/app_theme.dart';
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

  final List<String> _categories = [
    'Semua',
    'Supercar',
    'Luxury Sedan',
    'Executive',
    'SUV',
    'Sportivo',
    'Family Van',
  ];

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

  void _openBooking(Car car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingSheet(car: car),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        var cars = List<Car>.from(TripRentStore.instance.cars);

        // Filter
        if (_selectedCategory != 'Semua') {
          cars = cars.where((c) => c.category == _selectedCategory).toList();
        }
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
            title: const Text('Katalog Armada'),
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
              // Search & Sort Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: const InputDecoration(
                            hintText: 'Cari armada mobil...',
                            hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                            prefixIcon: Icon(Icons.search, color: AppTheme.primaryLight, size: 18),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Sort Dropdown
                    Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _sortBy,
                          dropdownColor: AppTheme.cardColor,
                          icon: const Icon(Icons.sort, color: AppTheme.primaryLight, size: 18),
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12),
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

              // Categories scroll
              SizedBox(
                height: 36,
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
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSel ? AppTheme.primaryLight : AppTheme.cardBorder,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSel ? Colors.white : AppTheme.textSecondary,
                            fontSize: 11.5,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Results Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Menampilkan ${cars.length} Mobil',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Content List or Grid
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
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.68,
                            ),
                            itemCount: cars.length,
                            itemBuilder: (ctx, idx) {
                              final car = cars[idx];
                              return _buildGridCard(car);
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            itemCount: cars.length,
                            itemBuilder: (ctx, idx) {
                              final car = cars[idx];
                              return CarCard(
                                car: car,
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
                    errorBuilder: (_, _, _) => Container(color: AppTheme.surfaceLight),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: AppTheme.warning, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            car.rating.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${car.tahun} • ${car.mesin}',
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    Formatters.rupiah(car.hargaSewa),
                    style: const TextStyle(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
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
