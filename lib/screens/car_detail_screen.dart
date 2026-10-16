import 'package:flutter/material.dart';
import '../models/car.dart';
import '../theme/app_theme.dart';
import '../widgets/formatters.dart';
import 'booking_sheet.dart';

class CarDetailScreen extends StatefulWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  late String _activeImage;

  @override
  void initState() {
    super.initState();
    _activeImage = widget.car.gambarUtama;
  }

  void _openBookingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BookingSheet(car: widget.car),
    );
  }

  String _cleanHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final cleanDesc = _cleanHtml(car.keterangan);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Appbar with Image
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: AppTheme.surface,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Disimpan ke daftar favorit!')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        _activeImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppTheme.cardColor,
                          child: const Center(
                            child: Icon(Icons.directions_car, size: 72, color: AppTheme.textMuted),
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                              AppTheme.background,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Body Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail gallery if detailImages exist
                      if (car.detailImages.isNotEmpty) ...[
                        SizedBox(
                          height: 60,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: car.detailImages.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 10),
                            itemBuilder: (ctx, idx) {
                              final img = car.detailImages[idx];
                              final isSelected = _activeImage == img;
                              return GestureDetector(
                                onTap: () => setState(() => _activeImage = img),
                                child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? AppTheme.primaryLight : AppTheme.cardBorder,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(img, fit: BoxFit.cover),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Title & Badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    car.category,
                                    style: const TextStyle(
                                      color: AppTheme.primaryLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  car.nama,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: AppTheme.warning, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  car.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Key Specifications Grid
                      const Text(
                        'Spesifikasi Armada',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _specCard(Icons.speed, 'Mesin', car.mesin)),
                          const SizedBox(width: 10),
                          Expanded(child: _specCard(Icons.people_alt_outlined, 'Kapasitas', car.kapasitas)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _specCard(Icons.calendar_today_outlined, 'Tahun Rilis', car.tahun)),
                          const SizedBox(width: 10),
                          Expanded(child: _specCard(Icons.tune_outlined, 'Transmisi', car.transmisi)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Inclusion & Availability Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: Column(
                          children: [
                            _featureRow(
                              Icons.verified_outlined,
                              'Paket Termasuk',
                              car.termasuk,
                              AppTheme.success,
                            ),
                            const Divider(color: AppTheme.cardBorder, height: 20),
                            _featureRow(
                              Icons.airline_seat_recline_normal,
                              'Jasa Sopir Tambahan',
                              '${Formatters.rupiah(car.hargaSopir)} /hari (Opsional)',
                              AppTheme.primaryLight,
                            ),
                            const Divider(color: AppTheme.cardBorder, height: 20),
                            _featureRow(
                              Icons.inventory_2_outlined,
                              'Ketersediaan Unit',
                              '${car.stok} Unit Tersedia',
                              AppTheme.warning,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Description
                      const Text(
                        'Deskripsi & Keunggulan',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cleanDesc.isNotEmpty
                            ? cleanDesc
                            : 'Unit mobil terawat dalam kondisi prima, selalu melalui inspeksi ketat serta pembersihan berkala sebelum diserahterimakan.',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13.5,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Rental terms
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: AppTheme.primaryLight, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Ketentuan Sewa',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Wajib melampirkan KTP/SIM A asli untuk sewa lepas kunci.\n• Pengantaran dan penjemputan unit gratis untuk area Bandara Minangkabau & pusat kota Padang.\n• Pembatalan gratis hingga 24 jam sebelum jadwal keberangkatan.',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Fixed Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: BoxDecoration(
                color: AppTheme.surface.withValues(alpha: 0.96),
                border: const Border(
                  top: BorderSide(color: AppTheme.cardBorder),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
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
                          'Mulai Dari',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              Formatters.rupiah(car.hargaSewa),
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              ' /hari',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _openBookingSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          shadowColor: AppTheme.primary.withValues(alpha: 0.6),
                        ),
                        child: const Text(
                          'Sewa Mobil Sekarang',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryLight, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String title, String subtitle, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
