import 'package:flutter/material.dart';
import '../../data/mock_database.dart';
import '../../theme/app_theme.dart';
import '../admin_screen.dart';
import '../profile_screen.dart';
import '../login_screen.dart';

/// AdminDashboard: Dashboard utama khusus role Admin TripRent
/// Memiliki Bottom Navigation Bar dengan 5 menu:
/// 1. Dashboard (Statistik, Omset, Aksi Cepat)
/// 2. Armada (Manajemen Data Mobil)
/// 3. Pesanan (Manajemen Data Pesanan & Penugasan Supir)
/// 4. Supir (Manajemen Data Sopir & Akun)
/// 5. Profil (Profil Akun Admin & Pengaturan)
class AdminDashboard extends StatefulWidget {
  final bool bypassAuthForTesting;
  final VoidCallback? onLogout;

  const AdminDashboard({
    super.key,
    this.bypassAuthForTesting = false,
    this.onLogout,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentBottomIndex = 0;
  int _adminTabIndex = 0;

  void _onBottomTabSelected(int index) {
    setState(() {
      _currentBottomIndex = index;
      if (index == 0) {
        _adminTabIndex = 0; // Dashboard
      } else if (index == 1) {
        _adminTabIndex = 1; // Data Mobil / Armada
      } else if (index == 2) {
        _adminTabIndex = 4; // Pesanan
      } else if (index == 3) {
        _adminTabIndex = 2; // Data Sopir / Supir
      }
    });
  }

  void _onProfileNavigateTab(int targetTab) {
    if (targetTab >= 0 && targetTab <= 4) {
      _onBottomTabSelected(targetTab);
    }
  }

  Widget _buildUnauthorizedScreen(BuildContext context) {
    final user = TripRentStore.instance.currentUser;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard TripRent'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.error.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.gpp_bad_rounded,
                    color: AppTheme.error,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Akses Dibatasi - Khusus Admin',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  user == null
                      ? 'Silakan masuk menggunakan akun Administrator TripRent untuk mengakses dashboard ini.'
                      : 'Akun Anda (${user.namaLengkap} - ${user.level}) tidak memiliki izin akses Administrator.',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(
                            promptMessage: 'Masuk dengan akun Admin untuk membuka Dashboard Administrator.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Masuk sebagai Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final currentUser = TripRentStore.instance.currentUser;
        final isAuthorized = widget.bypassAuthForTesting ||
            (currentUser != null && currentUser.isAdmin);

        if (!isAuthorized) {
          return _buildUnauthorizedScreen(context);
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: IndexedStack(
            index: _currentBottomIndex == 4 ? 1 : 0,
            children: [
              // Tab 0-3: AdminScreen with synced tab index
              AdminScreen(
                bypassAuthForTesting: widget.bypassAuthForTesting,
                initialTabIndex: _adminTabIndex,
              ),
              // Tab 4: ProfileScreen for Admin
              ProfileScreen(
                onNavigateTab: _onProfileNavigateTab,
              ),
            ],
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.dashboard_rounded, Icons.dashboard_outlined, 'Dashboard'),
                    _buildNavItem(1, Icons.directions_car_filled_rounded, Icons.directions_car_outlined, 'Armada'),
                    _buildNavItem(2, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Pesanan'),
                    _buildNavItem(3, Icons.badge_rounded, Icons.badge_outlined, 'Supir'),
                    _buildNavItem(4, Icons.person_rounded, Icons.person_outline_rounded, 'Profil'),
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
    final isSelected = _currentBottomIndex == index;
    return GestureDetector(
      onTap: () => _onBottomTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
