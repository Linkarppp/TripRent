import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/travel_ticket.dart';
import '../data/mock_database.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_guard.dart';
import '../widgets/car_card.dart';
import '../widgets/formatters.dart';
import '../widgets/whatsapp_helper.dart';
import 'car_detail_screen.dart';
import 'booking_sheet.dart';
import 'shuttle_schedule_screen.dart';
import 'fleet_screen.dart';
import 'login_screen.dart';
import '../widgets/shuttle_search_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = CarCategory.filterList;

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

  void _openTicketBooking({TravelTicket? ticket}) {
    if (ticket != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShuttleScheduleScreen(
            initialOrigin: ticket.origin,
            initialDestination: ticket.destination,
            initialDate: DateTime.now().add(const Duration(days: 1)),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShuttleScheduleScreen(
            initialDate: DateTime.now().add(const Duration(days: 1)),
          ),
        ),
      );
    }
  }

  void _showHelpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.headset_mic_rounded, color: AppTheme.primaryLight, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pusat Bantuan TripRent',
                          style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Layanan Pelanggan Siap Membantu 24 Jam',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chat_rounded, color: Color(0xFF25D366), size: 20),
                      ),
                      title: const Text('Chat WhatsApp Customer Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: const Text('0812-8694-3954 • Respon Cepat 24/7', style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.primaryLight),
                      onTap: () {
                        Navigator.pop(ctx);
                        WhatsAppHelper.openCustomerService(
                          context,
                          message: 'Halo Tim Layanan Pelanggan TripRent, saya ingin konsultasi sewa mobil atau tiket perjalanan.',
                        );
                      },
                    ),
                    const Divider(height: 16, color: AppTheme.cardBorder),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.phone_rounded, color: AppTheme.primaryLight, size: 20),
                      ),
                      title: const Text('Hubungi via Panggilan Telepon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: const Text('0812-8694-3954 • Layanan Darurat', style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.primaryLight),
                      onTap: () {
                        Navigator.pop(ctx);
                        WhatsAppHelper.callPhone('081286943954');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pertanyaan Sering Diajukan (FAQ)',
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildFaqItem('Syarat Sewa Lepas Kunci', 'Cukup lampirkan KTP asli, SIM A aktif, dan foto selfie. Verifikasi cepat dalam 5-10 menit.'),
              _buildFaqItem('Bisa Antar-Jemput Bandara & Hotel?', 'Ya, armada bisa diantar ke Bandara (BIM/Soekarno-Hatta) atau diantar langsung ke hotel tempat Anda menginap.'),
              _buildFaqItem('Metode Pembayaran', 'Mendukung Transfer Bank (BCA, Mandiri, BRI, BNI), E-Wallet (GoPay, OVO, Dana), dan QRIS instan.'),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.help_outline_rounded, size: 15, color: AppTheme.primaryLight),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppTheme.textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              answer,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11.5, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }

  void _showLongTermRentalDialog() {
    final cars = TripRentStore.instance.cars;
    Car selectedCar = cars.isNotEmpty ? cars.first : TripRentStore.instance.cars.first;
    String selectedDuration = '1 Bulan';
    int discountPercent = 20;
    bool withDriver = false;
    final nameCtrl = TextEditingController(text: TripRentStore.instance.currentUser?.namaLengkap ?? '');
    final phoneCtrl = TextEditingController(text: TripRentStore.instance.currentUser?.noTelp ?? '');
    final companyCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          final int baseMonthly = selectedCar.hargaSewa * 30;
          final int discountAmount = (baseMonthly * discountPercent ~/ 100);
          final int driverFee = withDriver ? 3500000 : 0;
          final int totalMonthly = baseMonthly - discountAmount + driverFee;

          return Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.shield_outlined, color: AppTheme.primaryLight, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rental Jangka Panjang',
                                style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Hemat hingga 35% untuk sewa bulanan & tahunan',
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Pilih Durasi
                    const Text('Pilih Durasi Sewa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        {'label': '1 Bulan', 'disc': 20},
                        {'label': '3 Bulan', 'disc': 25},
                        {'label': '6 Bulan', 'disc': 30},
                        {'label': '1 Tahun', 'disc': 35},
                      ].map((item) {
                        final isSel = selectedDuration == item['label'];
                        return InkWell(
                          onTap: () {
                            setSheetState(() {
                              selectedDuration = item['label'] as String;
                              discountPercent = item['disc'] as int;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? AppTheme.primary : AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSel ? AppTheme.primary : AppTheme.cardBorder),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  item['label'] as String,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : AppTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Diskon ${item['disc']}%',
                                  style: TextStyle(
                                    color: isSel ? const Color(0xFF38BDF8) : AppTheme.primaryLight,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Pilih Unit Mobil
                    const Text('Pilih Unit Armada', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Car>(
                          value: selectedCar,
                          isExpanded: true,
                          dropdownColor: AppTheme.cardColor,
                          items: cars.map((c) {
                            return DropdownMenuItem<Car>(
                              value: c,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      c.gambarUtama,
                                      width: 38,
                                      height: 26,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stack) => const Icon(Icons.directions_car, size: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '${c.nama} (${c.transmisi})',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${Formatters.rupiah(c.hargaSewa)}/hr',
                                    style: const TextStyle(fontSize: 11.5, color: AppTheme.primaryLight, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (c) {
                            if (c != null) {
                              setSheetState(() => selectedCar = c);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Opsi Supir
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dengan Supir Berpengalaman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                              Text('+ Rp 3.500.000 /bulan (Standar Dinas)', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                            ],
                          ),
                          Switch(
                            value: withDriver,
                            activeThumbColor: AppTheme.primaryLight,
                            onChanged: (val) => setSheetState(() => withDriver = val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Form Kontak
                    const Text('Informasi Pemohon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Nama Pemohon / PIC *',
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.cardBorder)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Nomor WhatsApp / HP *',
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.cardBorder)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: companyCtrl,
                      decoration: InputDecoration(
                        labelText: 'Nama Perusahaan / Instansi (Opsional)',
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.cardBorder)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rincian Biaya
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Column(
                        children: [
                          _summaryRow('Tarif Standar (30 Hari)', Formatters.rupiah(baseMonthly)),
                          _summaryRow('Diskon Jangka Panjang ($discountPercent%)', '- ${Formatters.rupiah(discountAmount)}', isGreen: true),
                          if (withDriver) _summaryRow('Layanan Supir Bulanan', Formatters.rupiah(driverFee)),
                          const Divider(height: 16, color: AppTheme.cardBorder),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total per Bulan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(
                                Formatters.rupiah(totalMonthly),
                                style: const TextStyle(color: AppTheme.primaryLight, fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tombol Aksi
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Silakan lengkapi Nama dan Nomor WhatsApp.')),
                            );
                            return;
                          }
                          Navigator.pop(ctx);
                          final instansi = companyCtrl.text.trim();
                          final message = 'Halo Admin TripRent, saya *${nameCtrl.text.trim()}*'
                              '${instansi.isNotEmpty ? ' dari *$instansi*' : ''} ingin mengajukan *Rental Jangka Panjang*:\n\n'
                              '🚗 Mobil: *${selectedCar.nama}*\n'
                              '⏱️ Durasi: *$selectedDuration* (Hemat $discountPercent%)\n'
                              '👨‍✈️ Supir: *${withDriver ? 'Dengan Supir' : 'Lepas Kunci'}*\n'
                              '💰 Estimasi: *${Formatters.rupiah(totalMonthly)}/bulan*\n'
                              '📱 WhatsApp: *${phoneCtrl.text.trim()}*\n\n'
                              'Mohon penawaran resmi dan prosedurnya. Terima kasih 🙏';
                          WhatsAppHelper.openCustomerService(context, message: message);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pengajuan rental jangka panjang berhasil diteruskan ke WhatsApp!')),
                          );
                        },
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: const Text('Kirim Pengajuan via WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isGreen ? AppTheme.success : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryLight,
                  size: 26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
              ),
            ],
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
        final allCars = TripRentStore.instance.cars;
        final featuredCars = allCars.where((c) => c.rating >= 4.85).toList();

        final filteredCars = allCars.where((car) {
          final matchCat = _selectedCategory == CarCategory.all ||
              CarCategory.normalize(car.category) == _selectedCategory;
          final matchSearch = car.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              car.mesin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              car.termasuk.toLowerCase().contains(_searchQuery.toLowerCase());
          return matchCat && matchSearch;
        }).toList();

        final currentUser = TripRentStore.instance.currentUser;
        final bool isLoggedIn = TripRentStore.instance.isLoggedIn && currentUser != null;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header: Greeting, Brand & Profile / Login
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TripRent Luxury',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isLoggedIn
                                    ? 'Halo, ${currentUser.namaLengkap.split(' ').first} 👋'
                                    : 'Selamat Datang 👋',
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Sewa mobil dengan mudah dan harga terbaik!',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.cardColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.cardBorder),
                                boxShadow: AppTheme.cardShadow,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.textPrimary, size: 20),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Tidak ada notifikasi baru.')),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (TripRentStore.instance.isLoggedIn)
                              GestureDetector(
                                onTap: () {
                                  if (widget.onNavigateTab != null) {
                                    widget.onNavigateTab!(3);
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    currentUser?.foto ??
                                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
                                  ),
                                ),
                              )
                            else
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                                icon: const Icon(Icons.login_rounded, size: 14),
                                label: const Text(
                                  'Masuk',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Search Bar with modern rounded look (Screen 3 Reference)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.cardBorder),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5),
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Cari mobil impian...',
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                      ),
                    ),
                  ),

                  // 4 Quick Service Actions (Screen 3 Reference)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickActionItem(
                          icon: Icons.directions_car_filled_rounded,
                          label: 'Sewa Mobil',
                          onTap: () {
                            if (widget.onNavigateTab != null) {
                              widget.onNavigateTab!(1);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const FleetScreen()),
                              );
                            }
                          },
                        ),
                        _buildQuickActionItem(
                          icon: Icons.shield_outlined,
                          label: 'Rental\nJangka Panjang',
                          onTap: _showLongTermRentalDialog,
                        ),
                        _buildQuickActionItem(
                          icon: Icons.airport_shuttle_rounded,
                          label: 'Tiket\nShuttle',
                          onTap: () => _openTicketBooking(),
                        ),
                        _buildQuickActionItem(
                          icon: Icons.headset_mic_rounded,
                          label: 'Bantuan',
                          onTap: _showHelpBottomSheet,
                        ),
                      ],
                    ),
                  ),

                  // Mobil Populer Section (Screen 3 Reference)
                  if (_searchQuery.isEmpty && _selectedCategory == 'Semua') ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mobil Populer',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (widget.onNavigateTab != null) {
                                widget.onNavigateTab!(1);
                              }
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'Lihat Semua',
                                  style: TextStyle(
                                    color: AppTheme.primaryLight,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(Icons.chevron_right_rounded, color: AppTheme.primaryLight, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 210,
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

                  // Promotional Hero Card (Screen 3 Reference: "Perjalanan lebih nyaman bersama TripRent")
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0284C7), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: AppTheme.floatShadow,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Perjalanan Lebih Nyaman\nBersama TripRent',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  if (widget.onNavigateTab != null) {
                                    widget.onNavigateTab!(1);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppTheme.primary,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Sewa Sekarang',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_rounded, size: 14),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=300&q=80',
                            width: 110,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.directions_car, color: Colors.white, size: 48),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category Selector Chips
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 14),
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
                                  color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                                ),
                                boxShadow: isSelected ? AppTheme.cardShadow : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (cat != CarCategory.all) ...[
                                    Icon(
                                      CarCategory.getCategoryIcon(cat),
                                      size: 14,
                                      color: isSelected ? Colors.white : AppTheme.primaryLight,
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(
                                    cat,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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

                  // Travel Ticket Booking Section (Kruzz & Arnes Shuttle in Real Life Reference)
                  if (_searchQuery.isEmpty && _selectedCategory == 'Semua') ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: ShuttleSearchCard(),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rute Shuttle Populer',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Pilih langsung rute keberangkatan favorit',
                                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () => _openTicketBooking(),
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
                      height: 120,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: TripRentStore.instance.tickets.length,
                        itemBuilder: (ctx, idx) {
                          final ticket = TripRentStore.instance.tickets[idx];
                          return Container(
                            width: 250,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.cardBorder),
                              boxShadow: AppTheme.cardShadow,
                            ),
                            child: InkWell(
                              onTap: () => _openTicketBooking(ticket: ticket),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppTheme.surfaceLight,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            ticket.category,
                                            style: const TextStyle(
                                              color: AppTheme.primaryLight,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        Formatters.rupiah(ticket.price),
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${ticket.origin} ➔ ${ticket.destination}',
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        ticket.vehicleName,
                                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 10.5),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Fleet Section Header
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
