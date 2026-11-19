import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../theme/app_theme.dart';
import '../widgets/whatsapp_helper.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'admin_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const ProfileScreen({super.key, this.onNavigateTab});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Keluar', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun TripRent?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              TripRentStore.instance.logout();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anda telah berhasil keluar dari akun.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final profile = TripRentStore.instance.companyProfile;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
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
            Text(
              profile.namaWebsite,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.metaDeskripsi,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: AppTheme.cardBorder),
            const SizedBox(height: 10),
            _infoRow(Icons.location_on_outlined, 'Alamat Kantor', profile.alamat),
            const SizedBox(height: 10),
            _infoRow(
              Icons.phone_outlined,
              'Call Center / WhatsApp',
              profile.noTelp,
              onTap: () => WhatsAppHelper.contactCS(),
            ),
            const SizedBox(height: 10),
            _infoRow(Icons.email_outlined, 'Email Resmi', profile.email),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodsSheet(BuildContext context) {
    final banks = TripRentStore.instance.companyProfile.bankAccounts;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
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
              'Metode Pembayaran Resmi',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            ...banks.map((b) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.account_balance, color: AppTheme.primaryLight, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.namaBank, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(b.noRekening, style: const TextStyle(color: AppTheme.primaryLight, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('a/n ${b.pemilik}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: AppTheme.textSecondary, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Nomor rekening ${b.noRekening} berhasil disalin!')),
                          );
                        },
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _menuRow({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.primaryLight).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor ?? AppTheme.primaryLight, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor ?? AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted, size: 22),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppTheme.textPrimary, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengaturan aplikasi')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: TripRentStore.instance,
        builder: (context, _) {
          final currentUser = TripRentStore.instance.currentUser;
          final isLoggedIn = TripRentStore.instance.isLoggedIn && currentUser != null;
          final userPhoto = currentUser?.foto;
          final bool hasPhoto = isLoggedIn && userPhoto != null && userPhoto.isNotEmpty;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            child: Column(
              children: [
                // Centered User Header (Screen 10 Reference)
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: AppTheme.surfaceLight,
                            backgroundImage: hasPhoto ? NetworkImage(userPhoto) : null,
                            child: !hasPhoto
                                ? const Icon(Icons.person_rounded, size: 52, color: AppTheme.textMuted)
                                : null,
                          ),
                          if (isLoggedIn)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryLight,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.edit, color: Colors.white, size: 14),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isLoggedIn ? currentUser.namaLengkap : 'Tamu (Belum Masuk)',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isLoggedIn ? currentUser.email : 'Masuk untuk mengelola akun Anda',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      if (isLoggedIn) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.cardBorder),
                          ),
                          child: Text(
                            currentUser.level,
                            style: const TextStyle(
                              color: AppTheme.primaryLight,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Guest Login Card if not logged in
                if (!isLoggedIn) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.cardBorder),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: const Text('Masuk (Login)', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primary,
                              side: const BorderSide(color: AppTheme.cardBorder),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Daftar Baru', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Menu Card (Screen 10 Reference) - Dynamic per Role
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.cardBorder),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      // Pesanan Saya — tampil untuk user dan admin
                      if ((currentUser?.role ?? 'user') != 'driver') ...[
                        _menuRow(
                          icon: Icons.receipt_long_outlined,
                          title: 'Pesanan Saya',
                          subtitle: 'Riwayat & status pemesanan mobil/tiket',
                          onTap: () {
                            if (widget.onNavigateTab != null) {
                              widget.onNavigateTab!(2);
                            } else {
                              Navigator.pushNamed(context, '/orders');
                            }
                          },
                        ),
                      ],

                      // ============================================================
                      // DYNAMIC MENU BERDASARKAN ROLE
                      // ============================================================
                      ...() {
                        final role = currentUser?.role ?? 'user';

                        // ---- ROLE: ADMIN ----
                        if (role == 'admin') {
                          return <Widget>[
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.admin_panel_settings_rounded,
                              title: 'Panel Admin TripRent',
                              subtitle: 'Kelola armada, sopir, user, pesanan & laporan',
                              iconColor: AppTheme.success,
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppTheme.success),
                                ),
                                child: const Text(
                                  'ADMIN AKTIF',
                                  style: TextStyle(color: AppTheme.success, fontSize: 9.5, fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminScreen()),
                              ),
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.people_alt_rounded,
                              title: 'Kelola Akun Pengguna',
                              subtitle: 'Lihat, edit, nonaktifkan akun user',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminScreen()),
                              ),
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.verified_rounded,
                              title: 'Verifikasi Transaksi Pembayaran',
                              subtitle: 'Konfirmasi & validasi pembayaran masuk',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminScreen()),
                              ),
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.analytics_rounded,
                              title: 'Laporan Penjualan',
                              subtitle: 'Statistik pendapatan & performa armada',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminScreen()),
                              ),
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.account_balance_rounded,
                              title: 'Rekening Resmi Perusahaan',
                              subtitle: 'Nomor rekening bank TripRent',
                              onTap: () => _showPaymentMethodsSheet(context),
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.help_outline_rounded,
                              title: 'Bantuan & FAQ',
                              subtitle: 'Hubungi WhatsApp Call Center 24/7',
                              onTap: () => WhatsAppHelper.contactCS(),
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.info_outline_rounded,
                              title: 'Tentang TripRent',
                              subtitle: 'Profil perusahaan & ketentuan sewa',
                              onTap: () => _showAboutDialog(context),
                            ),
                          ];
                        }

                        // ---- ROLE: DRIVER / SUPIR ----
                        if (role == 'driver') {
                          return <Widget>[
                            _menuRow(
                              icon: Icons.toggle_on_rounded,
                              title: 'Status Ketersediaan Supir',
                              subtitle: 'Aktifkan atau nonaktifkan status siap tugas',
                              iconColor: AppTheme.success,
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.success),
                                ),
                                child: const Text('TERSEDIA', style: TextStyle(color: AppTheme.success, fontSize: 9.5, fontWeight: FontWeight.bold)),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: AppTheme.cardColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    title: const Text('Status Ketersediaan', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                                    content: const Text('Ubah status ketersediaan Anda sebagai supir aktif?', style: TextStyle(color: AppTheme.textSecondary)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Tidak Tersedia', style: TextStyle(color: AppTheme.error)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Status diperbarui: Tersedia untuk tugas.')),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.success,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Tersedia'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.assignment_turned_in_rounded,
                              title: 'Tugas Perjalanan Saya',
                              subtitle: 'Daftar pesanan yang ditugaskan kepada Anda',
                              iconColor: AppTheme.primaryLight,
                              trailing: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text('!', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              onTap: () {
                                if (widget.onNavigateTab != null) widget.onNavigateTab!(1);
                              },
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.history_rounded,
                              title: 'Riwayat Perjalanan Selesai',
                              subtitle: 'Semua perjalanan yang telah diselesaikan',
                              onTap: () {
                                if (widget.onNavigateTab != null) widget.onNavigateTab!(2);
                              },
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.badge_rounded,
                              title: 'Lisensi & SIM Driver',
                              subtitle: 'Nomor SIM dan dokumen pengemudi',
                              onTap: () {
                                final driver = TripRentStore.instance.currentDriver;
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: AppTheme.cardColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    title: const Text('Lisensi & SIM', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                                    content: Text(
                                      'Nomor SIM: ${driver?.noSim ?? '-'}\nAtas nama: ${driver?.nama ?? currentUser?.namaLengkap ?? '-'}',
                                      style: const TextStyle(color: AppTheme.textSecondary, height: 1.6),
                                    ),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.menu_book_rounded,
                              title: 'SOP & Panduan Pengemudi',
                              subtitle: 'Tata cara operasional supir TripRent',
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: AppTheme.cardColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    title: const Text('SOP Pengemudi TripRent', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                                    content: const SingleChildScrollView(
                                      child: Text(
                                        '1. Pastikan kendaraan bersih sebelum menjemput penumpang.\n'
                                        '2. Konfirmasi pesanan minimal 30 menit sebelum keberangkatan.\n'
                                        '3. Gunakan seragam dan tanda pengenal resmi TripRent.\n'
                                        '4. Patuhi peraturan lalu lintas dan keselamatan berkendara.\n'
                                        '5. Jaga komunikasi sopan dengan pelanggan.\n'
                                        '6. Update status perjalanan secara real-time di aplikasi.\n'
                                        '7. Laporkan kendala segera ke dispatcher TripRent.',
                                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, height: 1.6),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mengerti')),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.support_agent_rounded,
                              title: 'Dispatcher / CS TripRent',
                              subtitle: 'Hubungi dispatcher via WhatsApp',
                              iconColor: const Color(0xFF25D366),
                              onTap: () => WhatsAppHelper.contactCS(),
                            ),
                            const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                            _menuRow(
                              icon: Icons.info_outline_rounded,
                              title: 'Tentang TripRent',
                              subtitle: 'Profil perusahaan & ketentuan sewa',
                              onTap: () => _showAboutDialog(context),
                            ),
                          ];
                        }

                        // ---- ROLE: USER (default) ----
                        return <Widget>[
                          const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                          _menuRow(
                            icon: Icons.favorite_border_rounded,
                            title: 'Favorit',
                            subtitle: 'Daftar armada mobil yang disimpan',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Armada favorit tersimpan di akun Anda.')),
                              );
                            },
                          ),
                          const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                          _menuRow(
                            icon: Icons.payment_rounded,
                            title: 'Metode Pembayaran',
                            subtitle: 'Rekening bank resmi & konfirmasi',
                            onTap: () => _showPaymentMethodsSheet(context),
                          ),
                          const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                          _menuRow(
                            icon: Icons.help_outline_rounded,
                            title: 'Bantuan & FAQ',
                            subtitle: 'Hubungi WhatsApp Call Center 24/7',
                            onTap: () => WhatsAppHelper.contactCS(),
                          ),
                          const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                          _menuRow(
                            icon: Icons.info_outline_rounded,
                            title: 'Tentang TripRent',
                            subtitle: 'Profil perusahaan & ketentuan sewa',
                            onTap: () => _showAboutDialog(context),
                          ),
                        ];
                      }(),

                      // Logout Row
                      if (isLoggedIn) ...[
                        const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                        _menuRow(
                          icon: Icons.logout_rounded,
                          title: 'Keluar',
                          iconColor: AppTheme.error,
                          textColor: AppTheme.error,
                          onTap: () => _confirmLogout(context),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // WhatsApp Help Pill
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => WhatsAppHelper.contactCS(),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                    label: const Text('Layanan Pelanggan WhatsApp (081286943954)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
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

  Widget _infoRow(IconData icon, String label, String value, {VoidCallback? onTap}) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryLight),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
              Text(
                value,
                style: TextStyle(
                  color: onTap != null ? AppTheme.primaryLight : AppTheme.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          const Icon(Icons.open_in_new_rounded, size: 14, color: AppTheme.primaryLight),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: content,
        ),
      );
    }

    return content;
  }
}
