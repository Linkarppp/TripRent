import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/car.dart';
import '../theme/app_theme.dart';
import '../widgets/car_card.dart';
import 'car_detail_screen.dart';
import 'booking_sheet.dart';

class HomeScreen extends StatefulWidget {
  final Function(int targetIndex)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Semua';
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
        final allCars = TripRentStore.instance.cars;
        final featuredCars = allCars.where((c) => c.rating >= 4.85).toList();

        final filteredCars = allCars.where((car) {
          final matchCat = _selectedCategory == 'Semua' || car.category == _selectedCategory;
          final matchSearch = car.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              car.mesin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              car.termasuk.toLowerCase().contains(_searchQuery.toLowerCase());
          return matchCat && matchSearch;
        }).toList();

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Location & Profile Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: AppTheme.primaryLight, size: 16),
                                const SizedBox(width: 4),
                                const Text(
                                  'Padang, Sumatera Barat',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary, size: 16),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'TripRent Luxury',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        // Profile Avatar & Notification
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.cardColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.cardBorder),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.textPrimary, size: 22),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Tidak ada notifikasi baru.')),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Promotional Hero Banner
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0369A1), Color(0xFF1E3A8A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'PROMO BULAN INI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Diskon 20% Sewa\nArmada Supercar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Termasuk Supir & Pengantaran Bandara',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {
                                if (widget.onNavigateTab != null) {
                                  widget.onNavigateTab!(1); // Go to fleet
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0369A1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Jelajahi Sekarang',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Cari nama mobil, cc mesin, atau paket...',
                          hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryLight, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: AppTheme.textMuted, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),

                  // Category Selector Chips
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 16),
                    child: SizedBox(
                      height: 38,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (ctx, idx) {
                          final cat = _categories[idx];
                          final isSelected = _selectedCategory == cat;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primary : AppTheme.cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppTheme.primaryLight : AppTheme.cardBorder,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.primary.withValues(alpha: 0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Featured Luxury Carousel
                  if (_searchQuery.isEmpty && _selectedCategory == 'Semua') ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Armada Pilihan Unggulan',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (widget.onNavigateTab != null) {
                                widget.onNavigateTab!(1);
                              }
                            },
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: AppTheme.primaryLight,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 270,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: featuredCars.length,
                        itemBuilder: (ctx, idx) {
                          final car = featuredCars[idx];
                          return CarCard(
                            car: car,
                            isFeatured: true,
                            onTap: () => _navigateToDetail(car),
                            onBook: () => _openBooking(car),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Fleet List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCategory == 'Semua'
                              ? 'Semua Armada Tersedia (${filteredCars.length})'
                              : 'Kategori: $_selectedCategory (${filteredCars.length})',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Car list
                  if (filteredCars.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: const Column(
                        children: [
                          Icon(Icons.search_off, size: 48, color: AppTheme.textMuted),
                          SizedBox(height: 12),
                          Text(
                            'Tidak ada mobil yang cocok dengan pencarian.',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredCars.length,
                        itemBuilder: (ctx, idx) {
                          final car = filteredCars[idx];
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
            ),
          ),
        );
      },
    );
  }
}
