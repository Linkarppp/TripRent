import 'package:flutter/material.dart';
import '../../data/mock_database.dart';
import '../../models/order.dart';
import '../../models/driver.dart';
import '../../theme/app_theme.dart';
import '../../widgets/formatters.dart';
import '../../widgets/whatsapp_helper.dart';
import '../profile_screen.dart';

class DriverDashboard extends StatefulWidget {
  final VoidCallback? onLogout;

  const DriverDashboard({super.key, this.onLogout});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final driver = TripRentStore.instance.currentDriver;
        final driverTasks = TripRentStore.instance.driverTasks;

        final screens = [
          _DriverHomeScreen(
            driver: driver,
            tasks: driverTasks,
            onGoToTasks: () => _onTabSelected(1),
          ),
          _DriverTasksScreen(driver: driver, tasks: driverTasks),
          _DriverHistoryScreen(driver: driver, tasks: driverTasks),
          ProfileScreen(onNavigateTab: _onTabSelected),
        ];

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(
                top: BorderSide(color: AppTheme.cardBorder, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.speed_rounded, Icons.speed_outlined, 'Beranda'),
                    _buildTasksNavItem(1, Icons.assignment_rounded, Icons.assignment_outlined, 'Tugas', driverTasks),
                    _buildNavItem(2, Icons.history_rounded, Icons.history_outlined, 'Riwayat'),
                    _buildNavItem(3, Icons.person_rounded, Icons.person_outline_rounded, 'Profil'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? AppTheme.primaryLight : AppTheme.textMuted,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryLight : AppTheme.textMuted,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, List<RentalOrder> tasks) {
    final isSelected = _currentIndex == index;
    final activeTasksCount = tasks.where((t) => t.driverTaskStatus != 'Perjalanan Selesai' && t.driverTaskStatus != 'Ditolak').length;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  color: isSelected ? AppTheme.primaryLight : AppTheme.textMuted,
                  size: 22,
                ),
                if (activeTasksCount > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.danger,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$activeTasksCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryLight : AppTheme.textMuted,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1. BERANDA SUPIR (_DriverHomeScreen)
// ==========================================
class _DriverHomeScreen extends StatelessWidget {
  final Driver? driver;
  final List<RentalOrder> tasks;
  final VoidCallback onGoToTasks;

  const _DriverHomeScreen({
    required this.driver,
    required this.tasks,
    required this.onGoToTasks,
  });

  void _showAvailabilityDialog(BuildContext context, Driver drv) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 18),
            const Text(
              'Ubah Status Ketersediaan Supir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Status ini menentukan apakah Anda siap menerima penugasan perjalanan baru dari Admin.',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            _buildStatusOption(
              context,
              drv,
              'Tersedia',
              'Siap Bertugas (Online)',
              'Bisa menerima penugasan perjalanan kapan saja.',
              Icons.check_circle_rounded,
              AppTheme.success,
            ),
            const SizedBox(height: 12),
            _buildStatusOption(
              context,
              drv,
              'Dalam Perjalanan',
              'Sedang Bertugas (On Duty)',
              'Sedang aktif mengantar penumpang di rute.',
              Icons.directions_car_rounded,
              AppTheme.primaryLight,
            ),
            const SizedBox(height: 12),
            _buildStatusOption(
              context,
              drv,
              'Istirahat',
              'Istirahat / Libur (Offline)',
              'Tidak menerima penugasan baru sementara waktu.',
              Icons.do_not_disturb_on_rounded,
              AppTheme.textMuted,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    Driver drv,
    String statusKey,
    String title,
    String desc,
    IconData icon,
    Color color,
  ) {
    final isSelected = drv.statusKetersediaan == statusKey;
    return InkWell(
      onTap: () {
        TripRentStore.instance.updateDriverAvailability(drv.id, statusKey);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status ketersediaan berhasil diubah ke "$title"'),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppTheme.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppTheme.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drv = driver ??
        Driver(
          id: 1,
          nama: 'Robby Prihandaya',
          jenisKelamin: 'Laki-laki',
          tempatLahir: 'Padang',
          tanggalLahir: '1989-05-06',
          alamat: 'Jl. Angkasa Puri, Padang',
          keterangan: 'Driver Senior',
          foto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        );

    final activeTask = tasks.where((t) => t.driverTaskStatus == 'Dalam Perjalanan').firstOrNull ??
        tasks.where((t) => t.driverTaskStatus == 'Diterima').firstOrNull ??
        tasks.where((t) => t.driverTaskStatus == 'Menunggu Konfirmasi').firstOrNull;

    final completedCount = tasks.where((t) => t.driverTaskStatus == 'Perjalanan Selesai').length;

    Color statusBadgeColor = AppTheme.success;
    if (drv.statusKetersediaan == 'Dalam Perjalanan') {
      statusBadgeColor = AppTheme.primaryLight;
    } else if (drv.statusKetersediaan == 'Istirahat') {
      statusBadgeColor = AppTheme.textMuted;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Supir
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(drv.foto),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.shield_rounded, color: Colors.white, size: 12),
                                    SizedBox(width: 4),
                                    Text(
                                      'PORTAL SUPIR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            drv.nama,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            drv.noSim,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 16),
                // Ketersediaan switch trigger
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Kerja Saat Ini:',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: statusBadgeColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: statusBadgeColor.withValues(alpha: 0.6),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              drv.statusKetersediaan,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showAvailabilityDialog(context, drv),
                      icon: const Icon(Icons.tune_rounded, size: 15),
                      label: const Text('Ganti Status'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Statistik Ringkas Supir
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Trip Selesai',
                  '${drv.totalPerjalanan + completedCount}',
                  Icons.verified_rounded,
                  AppTheme.primaryLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Rating Performa',
                  '${drv.rating} ★',
                  Icons.star_rounded,
                  AppTheme.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Tugas Aktif',
                  '${tasks.where((t) => t.driverTaskStatus != "Perjalanan Selesai" && t.driverTaskStatus != "Ditolak").length}',
                  Icons.work_outline_rounded,
                  AppTheme.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tugas Berjalan Saat Ini (Highlight)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tugas Perjalanan Saat Ini',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onGoToTasks,
                child: const Text('Lihat Semua', style: TextStyle(color: AppTheme.primaryLight)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (activeTask != null)
            _buildActiveTaskCard(context, activeTask)
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.event_available_rounded,
                      color: AppTheme.primaryLight,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Belum Ada Tugas Aktif',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tetap aktifkan status "Tersedia" agar Admin dapat menugaskan perjalanan untuk Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Panduan Keselamatan & SOP Supir
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.security_rounded, color: AppTheme.primary, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SOP Pelayanan Supir TripRent',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Hadir 15 menit sebelum waktu jemput, pastikan kabin bersih, AC dingin, dan patuhi rambu keselamatan.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.cardBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTaskCard(BuildContext context, RentalOrder task) {
    Color badgeColor = AppTheme.warning;
    if (task.driverTaskStatus == 'Dalam Perjalanan') {
      badgeColor = AppTheme.primaryLight;
    } else if (task.driverTaskStatus == 'Diterima') {
      badgeColor = AppTheme.success;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: badgeColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.driverTaskStatus,
                  style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                task.kodeOrders,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Mobil & Waktu
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  task.car.gambarUtama,
                  width: 70,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 50,
                    color: AppTheme.surfaceLight,
                    child: const Icon(Icons.directions_car_rounded, color: AppTheme.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.car.nama,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${Formatters.dateShort(task.dariTanggal)} • ${task.totalHari} Hari',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppTheme.cardBorder),
          const SizedBox(height: 10),

          // Pelanggan & Rute
          Row(
            children: [
              const Icon(Icons.person_pin_rounded, color: AppTheme.primaryLight, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${task.namaPemesan} (${task.noTelpon})',
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppTheme.success, size: 20),
                tooltip: 'WhatsApp Pelanggan',
                onPressed: () {
                  WhatsAppHelper.openWhatsApp(
                    phone: task.noTelpon,
                    message: 'Halo Bapak/Ibu ${task.namaPemesan}, saya supir TripRent yang ditugaskan untuk perjalanan Anda (${task.car.nama}).',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.my_location_rounded, color: AppTheme.success, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Jemput: ${task.jemput}',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_rounded, color: AppTheme.danger, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tujuan: ${task.tujuan}',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tombol Update Status Perjalanan
          _buildTaskActionButtons(context, task),
        ],
      ),
    );
  }

  Widget _buildTaskActionButtons(BuildContext context, RentalOrder task) {
    if (task.driverTaskStatus == 'Menunggu Konfirmasi') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                TripRentStore.instance.updateDriverTaskStatus(task.kodeOrders, 'Ditolak');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Penugasan perjalanan ditolak.'),
                    backgroundColor: AppTheme.error,
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: const BorderSide(color: AppTheme.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Tolak'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                TripRentStore.instance.updateDriverTaskStatus(task.kodeOrders, 'Diterima');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tugas perjalanan diterima! Siap bertugas.'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Terima Tugas'),
            ),
          ),
        ],
      );
    } else if (task.driverTaskStatus == 'Diterima') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            TripRentStore.instance.updateDriverTaskStatus(task.kodeOrders, 'Dalam Perjalanan');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Perjalanan dimulai! Status Anda sekarang: Dalam Perjalanan.'),
                backgroundColor: AppTheme.primaryLight,
              ),
            );
          },
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Mulai Perjalanan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryLight,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      );
    } else if (task.driverTaskStatus == 'Dalam Perjalanan') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            TripRentStore.instance.updateDriverTaskStatus(task.kodeOrders, 'Perjalanan Selesai');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selamat! Perjalanan telah berhasil diselesaikan.'),
                backgroundColor: AppTheme.success,
              ),
            );
          },
          icon: const Icon(Icons.check_circle_rounded),
          label: const Text('Selesaikan Perjalanan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.success,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

// ==========================================
// 2. DAFTAR TUGAS SUPIR (_DriverTasksScreen)
// ==========================================
class _DriverTasksScreen extends StatelessWidget {
  final Driver? driver;
  final List<RentalOrder> tasks;

  const _DriverTasksScreen({required this.driver, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final activeTasks = tasks.where((t) => t.driverTaskStatus != 'Perjalanan Selesai' && t.driverTaskStatus != 'Ditolak').toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Tugas Perjalanan Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppTheme.cardBorder, height: 1),
        ),
      ),
      body: activeTasks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.assignment_turned_in_rounded, size: 48, color: AppTheme.primaryLight),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tidak Ada Tugas Baru',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Semua tugas telah diselesaikan atau belum ada penugasan baru dari Admin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: activeTasks.length,
              itemBuilder: (ctx, idx) {
                final task = activeTasks[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _DriverTaskCard(task: task),
                );
              },
            ),
    );
  }
}

class _DriverTaskCard extends StatelessWidget {
  final RentalOrder task;

  const _DriverTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    Color badgeColor = AppTheme.warning;
    if (task.driverTaskStatus == 'Dalam Perjalanan') {
      badgeColor = AppTheme.primaryLight;
    } else if (task.driverTaskStatus == 'Diterima') {
      badgeColor = AppTheme.success;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.cardBorder),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.driverTaskStatus,
                  style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                task.kodeOrders,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Mobil
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  task.car.gambarUtama,
                  width: 70,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 50,
                    color: AppTheme.surfaceLight,
                    child: const Icon(Icons.directions_car_rounded, color: AppTheme.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.car.nama,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Tahun ${task.car.tahun} • Transmisi ${task.car.transmisi}',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.cardBorder),
          const SizedBox(height: 8),

          // Pelanggan
          Row(
            children: [
              const Icon(Icons.person_rounded, color: AppTheme.primaryLight, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pelanggan: ${task.namaPemesan}',
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.call_rounded, color: AppTheme.primaryLight, size: 18),
                onPressed: () {
                  WhatsAppHelper.openWhatsApp(
                    phone: task.noTelpon,
                    message: 'Halo ${task.namaPemesan}, saya supir penugasan Anda dari TripRent.',
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: Text(
              'No. Telepon: ${task.noTelpon}',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ),

          // Lokasi Rute
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle, size: 10, color: AppTheme.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Jemput: ${task.jemput}', style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary)),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: SizedBox(
                    height: 14,
                    child: VerticalDivider(color: AppTheme.cardBorder, thickness: 1),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 12, color: AppTheme.danger),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Tujuan: ${task.tujuan}', style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (task.keterangan.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Catatan: "${task.keterangan}"',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11.5, fontStyle: FontStyle.italic),
              ),
            ),

          // Aksi Tugas
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (task.driverTaskStatus == 'Menunggu Konfirmasi') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                TripRentStore.instance.updateDriverTaskStatus(task.kodeOrders, 'Ditolak');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: const BorderSide(color: AppTheme.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Tolak'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                TripRentStore.instance.updateDriverTaskStatus(task.kodeOrders, 'Diterima');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Terima'),
            ),
          ),
        ],
      );
    } else if (task.driverTaskStatus == 'Diterima') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            TripRentStore.instance.updateDriverTaskStatus(task.kodeOrders, 'Dalam Perjalanan');
          },
          icon: const Icon(Icons.navigation_rounded),
          label: const Text('Mulai Perjalanan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryLight,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    } else if (task.driverTaskStatus == 'Dalam Perjalanan') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            TripRentStore.instance.updateDriverTaskStatus(task.kodeOrders, 'Perjalanan Selesai');
          },
          icon: const Icon(Icons.check_circle_rounded),
          label: const Text('Selesaikan Perjalanan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.success,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

// ==========================================
// 3. RIWAYAT PERJALANAN (_DriverHistoryScreen)
// ==========================================
class _DriverHistoryScreen extends StatelessWidget {
  final Driver? driver;
  final List<RentalOrder> tasks;

  const _DriverHistoryScreen({required this.driver, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final history = tasks.where((t) => t.driverTaskStatus == 'Perjalanan Selesai' || t.status == 'Selesai').toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Riwayat Perjalanan Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: history.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppTheme.surfaceLight, shape: BoxShape.circle),
                      child: const Icon(Icons.history_rounded, size: 48, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 16),
                    const Text('Belum Ada Riwayat Perjalanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 6),
                    const Text('Perjalanan yang berhasil Anda selesaikan akan tercatat di sini.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: history.length,
              itemBuilder: (ctx, idx) {
                final item = history[idx];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.kodeOrders, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryLight, fontSize: 13)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Selesai', style: TextStyle(color: AppTheme.success, fontSize: 10.5, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(item.car.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text('Pelanggan: ${item.namaPemesan}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      Text('Rute: ${item.jemput} → ${item.tujuan}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Formatters.dateShort(item.dariTanggal), style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                          const Row(
                            children: [
                              Icon(Icons.star_rounded, color: AppTheme.warning, size: 16),
                              SizedBox(width: 4),
                              Text('5.0 (Puas)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
