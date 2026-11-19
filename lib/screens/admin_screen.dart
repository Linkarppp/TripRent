import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/car.dart';
import '../models/driver.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';
import '../widgets/formatters.dart';
import '../widgets/whatsapp_helper.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  final bool bypassAuthForTesting;
  final int initialTabIndex;

  const AdminScreen({
    super.key,
    this.bypassAuthForTesting = false,
    this.initialTabIndex = 0,
  });

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _carSearchController = TextEditingController();
  final TextEditingController _driverSearchController = TextEditingController();
  final TextEditingController _userSearchController = TextEditingController();
  final TextEditingController _orderSearchController = TextEditingController();

  String _carSearchQuery = '';
  String _driverSearchQuery = '';
  String _userSearchQuery = '';
  String _orderSearchQuery = '';
  String _orderStatusFilter = 'Semua';
  String _reportPeriod = 'Semua Waktu';

  @override
  void initState() {
    super.initState();
    final startIdx = (widget.initialTabIndex >= 0 && widget.initialTabIndex < 7)
        ? widget.initialTabIndex
        : 0;
    _tabController = TabController(length: 7, vsync: this, initialIndex: startIdx);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(AdminScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex &&
        widget.initialTabIndex >= 0 &&
        widget.initialTabIndex < 7) {
      _tabController.animateTo(widget.initialTabIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _carSearchController.dispose();
    _driverSearchController.dispose();
    _userSearchController.dispose();
    _orderSearchController.dispose();
    super.dispose();
  }

  // --- CAR DIALOG (ADD & EDIT) ---
  void _showCarFormDialog({Car? carToEdit}) {
    final isEdit = carToEdit != null;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: carToEdit?.nama ?? '');
    final rentalPriceController = TextEditingController(
        text: carToEdit != null ? carToEdit.hargaSewa.toString() : '');
    final driverPriceController = TextEditingController(
        text: carToEdit != null ? carToEdit.hargaSopir.toString() : '150000');
    final engineController =
        TextEditingController(text: carToEdit?.mesin ?? '2000 cc');
    final yearController =
        TextEditingController(text: carToEdit?.tahun ?? '2024');
    final capacityController =
        TextEditingController(text: carToEdit?.kapasitas ?? '5 Orang');
    final stockController =
        TextEditingController(text: carToEdit != null ? carToEdit.stok.toString() : '2');
    final descController =
        TextEditingController(text: carToEdit?.keterangan ?? '');
    final imageController = TextEditingController(
        text: carToEdit?.gambarUtama ??
            'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80');

    String selectedCategory = CarCategory.normalize(carToEdit?.category);
    String selectedTransmission = carToEdit?.transmisi ?? 'Otomatis';
    String selectedIncluded = carToEdit?.termasuk ?? 'Mobil Saja';

    final categories = CarCategory.list;

    final transmissions = [
      'Otomatis',
      'Manual',
      'Dual-Clutch Auto',
    ];

    final includedOptions = [
      'Mobil Saja',
      'Mobil + BBM',
      'Mobil + Sopir',
      'Mobil + Sopir + BBM',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isEdit ? Icons.edit_note_rounded : Icons.add_circle_outline_rounded,
                              color: AppTheme.primaryLight,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isEdit ? 'Edit Data Mobil' : 'Tambah Mobil Baru',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppTheme.textMuted),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppTheme.cardBorder, height: 1),

                  // Form Fields
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          // Nama Mobil
                          _buildLabel('Nama Mobil'),
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5),
                            decoration: _inputDecoration('Misal: Toyota Alphard Transformer'),
                            validator: (v) => v!.trim().isEmpty ? 'Nama mobil wajib diisi' : null,
                          ),
                          const SizedBox(height: 14),

                          // Kategori & Transmisi
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Kategori'),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: _dropdownContainerDecoration(),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedCategory,
                                          isExpanded: true,
                                          dropdownColor: AppTheme.cardColor,
                                          items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)))).toList(),
                                          onChanged: (val) {
                                            if (val != null) setModalState(() => selectedCategory = val);
                                          },
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
                                    _buildLabel('Transmisi'),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: _dropdownContainerDecoration(),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedTransmission,
                                          isExpanded: true,
                                          dropdownColor: AppTheme.cardColor,
                                          items: transmissions.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)))).toList(),
                                          onChanged: (val) {
                                            if (val != null) setModalState(() => selectedTransmission = val);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Harga Sewa & Biaya Sopir
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Tarif Sewa / Hari (Rp)'),
                                    TextFormField(
                                      controller: rentalPriceController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5),
                                      decoration: _inputDecoration('Misal: 450000'),
                                      validator: (v) {
                                        if (v!.trim().isEmpty) return 'Tarif wajib diisi';
                                        if (int.tryParse(v.trim()) == null) return 'Harus angka';
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Tarif Sopir / Hari (Rp)'),
                                    TextFormField(
                                      controller: driverPriceController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5),
                                      decoration: _inputDecoration('Misal: 150000'),
                                      validator: (v) {
                                        if (v!.trim().isEmpty) return 'Biaya sopir wajib diisi';
                                        if (int.tryParse(v.trim()) == null) return 'Harus angka';
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Tahun, CC Mesin, Kapasitas, Stok
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Tahun'),
                                    TextFormField(
                                      controller: yearController,
                                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                      decoration: _inputDecoration('2024'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Kapasitas'),
                                    TextFormField(
                                      controller: capacityController,
                                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                      decoration: _inputDecoration('7 Orang'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Stok Unit'),
                                    TextFormField(
                                      controller: stockController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                      decoration: _inputDecoration('2'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Paket Termasuk
                          _buildLabel('Paket Layanan Termasuk'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: _dropdownContainerDecoration(),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedIncluded,
                                isExpanded: true,
                                dropdownColor: AppTheme.cardColor,
                                items: includedOptions.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)))).toList(),
                                onChanged: (val) {
                                  if (val != null) setModalState(() => selectedIncluded = val);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Mesin
                          _buildLabel('Kapasitas Mesin (CC)'),
                          TextFormField(
                            controller: engineController,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                            decoration: _inputDecoration('Misal: 2500 cc Hybrid'),
                          ),
                          const SizedBox(height: 14),

                          // Image URL
                          _buildLabel('URL Gambar Mobil (Online)'),
                          TextFormField(
                            controller: imageController,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                            decoration: _inputDecoration('https://images.unsplash.com/...'),
                            onChanged: (_) => setModalState(() {}),
                          ),
                          const SizedBox(height: 8),
                          if (imageController.text.trim().isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageController.text.trim(),
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  height: 80,
                                  color: AppTheme.cardColor,
                                  alignment: Alignment.center,
                                  child: const Text('Pratinjau gambar tidak tersedia', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                                ),
                              ),
                            ),
                          const SizedBox(height: 14),

                          // Deskripsi
                          _buildLabel('Keterangan / Fasilitas'),
                          TextFormField(
                            controller: descController,
                            maxLines: 3,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                            decoration: _inputDecoration('Deskripsi performa, interior, kenyamanan armada...'),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Save Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppTheme.cardColor,
                      border: Border(top: BorderSide(color: AppTheme.cardBorder)),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            final name = nameController.text.trim();
                            final rentPrice = int.parse(rentalPriceController.text.trim());
                            final driverPrice = int.parse(driverPriceController.text.trim());
                            final engine = engineController.text.trim().isEmpty ? '2000 cc' : engineController.text.trim();
                            final year = yearController.text.trim().isEmpty ? '2024' : yearController.text.trim();
                            final capacity = capacityController.text.trim().isEmpty ? '5 Orang' : capacityController.text.trim();
                            final stock = int.tryParse(stockController.text.trim()) ?? 1;
                            final desc = descController.text.trim().isEmpty ? 'Armada nyaman dan bersih siap menemani perjalanan Anda.' : descController.text.trim();
                            final img = imageController.text.trim().isEmpty
                                ? 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80'
                                : imageController.text.trim();

                            final slug = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');

                            if (isEdit) {
                              final updated = carToEdit.copyWith(
                                nama: name,
                                namaSeo: slug,
                                hargaSewa: rentPrice,
                                hargaSopir: driverPrice,
                                category: selectedCategory,
                                transmisi: selectedTransmission,
                                termasuk: selectedIncluded,
                                mesin: engine,
                                tahun: year,
                                kapasitas: capacity,
                                stok: stock,
                                keterangan: desc,
                                gambarUtama: img,
                              );
                              TripRentStore.instance.updateCar(updated);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Mobil "$name" berhasil diperbarui!')),
                              );
                            } else {
                              final newCar = Car(
                                id: DateTime.now().millisecondsSinceEpoch % 100000,
                                nama: name,
                                namaSeo: slug,
                                hargaSewa: rentPrice,
                                hargaSopir: driverPrice,
                                durasi: 1,
                                termasuk: selectedIncluded,
                                mesin: engine,
                                tahun: year,
                                kapasitas: capacity,
                                stok: stock,
                                keterangan: desc,
                                gambarUtama: img,
                                category: selectedCategory,
                                transmisi: selectedTransmission,
                                rating: 5.0,
                                hits: 0,
                                detailImages: [img],
                              );
                              TripRentStore.instance.addCar(newCar);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Mobil "$name" berhasil ditambahkan!')),
                              );
                            }

                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            isEdit ? 'Simpan Perubahan' : 'Tambahkan Mobil',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
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

  // --- DRIVER DIALOG (ADD & EDIT) ---
  void _showDriverFormDialog({Driver? driverToEdit}) {
    final isEdit = driverToEdit != null;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: driverToEdit?.nama ?? '');
    final phoneController = TextEditingController(text: driverToEdit?.noHp ?? '0812-');
    final pobController = TextEditingController(text: driverToEdit?.tempatLahir ?? 'Padang');
    final dobController = TextEditingController(text: driverToEdit?.tanggalLahir ?? '1990-05-15');
    final addressController = TextEditingController(text: driverToEdit?.alamat ?? '');
    final descController = TextEditingController(text: driverToEdit?.keterangan ?? '');
    final photoController = TextEditingController(
        text: driverToEdit?.foto ??
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80');
    final usernameController = TextEditingController(
        text: isEdit ? '' : 'supir_${DateTime.now().millisecondsSinceEpoch % 1000}');
    final passwordController = TextEditingController(text: isEdit ? '' : 'driver123');

    String selectedGender = driverToEdit?.jenisKelamin ?? 'Laki-laki';
    bool isAvailable = driverToEdit?.tersedia ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isEdit ? Icons.edit_note_rounded : Icons.person_add_rounded,
                              color: AppTheme.primaryLight,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isEdit ? 'Edit Data Sopir' : 'Tambah Sopir Baru',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppTheme.textMuted),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppTheme.cardBorder, height: 1),

                  // Form Fields
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          _buildLabel('Nama Lengkap Sopir'),
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5),
                            decoration: _inputDecoration('Misal: Ahmad Zaki'),
                            validator: (v) => v!.trim().isEmpty ? 'Nama sopir wajib diisi' : null,
                          ),
                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Jenis Kelamin'),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: _dropdownContainerDecoration(),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedGender,
                                          isExpanded: true,
                                          dropdownColor: AppTheme.cardColor,
                                          items: ['Laki-laki', 'Perempuan'].map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)))).toList(),
                                          onChanged: (val) {
                                            if (val != null) setModalState(() => selectedGender = val);
                                          },
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
                                    _buildLabel('Nomor WhatsApp / HP'),
                                    TextFormField(
                                      controller: phoneController,
                                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5),
                                      decoration: _inputDecoration('0812-xxxx-xxxx'),
                                      validator: (v) => v!.trim().isEmpty ? 'Nomor HP wajib diisi' : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Tempat Lahir'),
                                    TextFormField(
                                      controller: pobController,
                                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                      decoration: _inputDecoration('Kota kelahiran'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Tanggal Lahir'),
                                    TextFormField(
                                      controller: dobController,
                                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                      decoration: _inputDecoration('YYYY-MM-DD'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          _buildLabel('Alamat Tempat Tinggal'),
                          TextFormField(
                            controller: addressController,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                            decoration: _inputDecoration('Alamat domisili saat ini...'),
                          ),
                          const SizedBox(height: 14),

                          _buildLabel('URL Foto Profil'),
                          TextFormField(
                            controller: photoController,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                            decoration: _inputDecoration('https://images.unsplash.com/...'),
                            onChanged: (_) => setModalState(() {}),
                          ),
                          const SizedBox(height: 8),
                          if (photoController.text.trim().isNotEmpty)
                            Center(
                              child: CircleAvatar(
                                radius: 36,
                                backgroundImage: NetworkImage(photoController.text.trim()),
                              ),
                            ),
                          const SizedBox(height: 14),

                          _buildLabel('Keterangan & Pengalaman Lisensi'),
                          TextFormField(
                            controller: descController,
                            maxLines: 3,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                            decoration: _inputDecoration('Lisensi SIM, pengalaman mengemudi, rute yang dikuasai...'),
                          ),
                          const SizedBox(height: 14),

                          if (!isEdit) ...[
                            const Divider(color: AppTheme.cardBorder, height: 28),
                            const Text(
                              'Akun Login Supir',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Akun ini digunakan supir untuk login ke aplikasi TripRent Driver.',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 11.5),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Username Supir'),
                                      TextFormField(
                                        controller: usernameController,
                                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                        decoration: _inputDecoration('supir123'),
                                        validator: (v) => (!isEdit && (v == null || v.trim().isEmpty)) ? 'Username wajib diisi' : null,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Password Akun'),
                                      TextFormField(
                                        controller: passwordController,
                                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                                        decoration: _inputDecoration('driver123'),
                                        validator: (v) => (!isEdit && (v == null || v.trim().isEmpty)) ? 'Password wajib diisi' : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Switch Status
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Status: Siap Bertugas', style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                                Switch(
                                  value: isAvailable,
                                  activeThumbColor: AppTheme.success,
                                  onChanged: (val) => setModalState(() => isAvailable = val),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Save Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppTheme.cardColor,
                      border: Border(top: BorderSide(color: AppTheme.cardBorder)),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            final name = nameController.text.trim();
                            final phone = phoneController.text.trim();
                            final pob = pobController.text.trim().isEmpty ? 'Padang' : pobController.text.trim();
                            final dob = dobController.text.trim().isEmpty ? '1990-01-01' : dobController.text.trim();
                            final address = addressController.text.trim().isEmpty ? 'Padang, Sumatera Barat' : addressController.text.trim();
                            final desc = descController.text.trim().isEmpty ? 'Driver ramah dan berpengalaman menguasai rute.' : descController.text.trim();
                            final photo = photoController.text.trim().isEmpty
                                ? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80'
                                : photoController.text.trim();

                            if (isEdit) {
                              final updated = driverToEdit.copyWith(
                                nama: name,
                                jenisKelamin: selectedGender,
                                noHp: phone,
                                tempatLahir: pob,
                                tanggalLahir: dob,
                                alamat: address,
                                keterangan: desc,
                                foto: photo,
                                tersedia: isAvailable,
                              );
                              TripRentStore.instance.updateDriver(updated);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sopir "$name" berhasil diperbarui!')),
                              );
                            } else {
                              final newDriver = Driver(
                                id: DateTime.now().millisecondsSinceEpoch % 100000,
                                nama: name,
                                jenisKelamin: selectedGender,
                                tempatLahir: pob,
                                tanggalLahir: dob,
                                alamat: address,
                                keterangan: desc,
                                foto: photo,
                                noHp: phone,
                                rating: 5.0,
                                totalPerjalanan: 1,
                                tersedia: isAvailable,
                              );
                              TripRentStore.instance.addDriver(
                                newDriver,
                                username: usernameController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sopir "$name" berhasil ditambahkan!')),
                              );
                            }

                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            isEdit ? 'Simpan Perubahan' : 'Tambahkan Sopir',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
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

  // --- DELETE CONFIRMATION ---
  void _confirmDelete({required String title, required String message, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.cardBorder),
        ),
        title: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // UI Helper Widgets
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12.5),
      filled: true,
      fillColor: AppTheme.cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryLight, width: 1.5),
      ),
    );
  }

  BoxDecoration _dropdownContainerDecoration() {
    return BoxDecoration(
      color: AppTheme.cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.cardBorder),
    );
  }

  Widget _buildDialogTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    String? Function(String?)? validator, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
        prefixIcon: Icon(icon, color: AppTheme.primaryLight, size: 18),
        filled: true,
        fillColor: AppTheme.cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryLight),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = TripRentStore.instance.currentUser;
    final isAuthorized = widget.bypassAuthForTesting ||
        (currentUser != null && currentUser.isAdmin);

    if (!isAuthorized) {
      return _buildUnauthorizedScreen(context);
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Panel Admin TripRent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
            tooltip: 'Keluar dari Akun Admin',
            onPressed: _confirmAdminLogout,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppTheme.primaryLight,
          labelColor: AppTheme.primaryLight,
          unselectedLabelColor: AppTheme.textMuted,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_rounded), text: 'Dashboard'),
            Tab(icon: Icon(Icons.directions_car_filled_rounded), text: 'Data Mobil'),
            Tab(icon: Icon(Icons.badge_rounded), text: 'Data Sopir'),
            Tab(icon: Icon(Icons.people_alt_rounded), text: 'Data User'),
            Tab(icon: Icon(Icons.receipt_long_rounded), text: 'Pesanan'),
            Tab(icon: Icon(Icons.paid_rounded), text: 'Transaksi'),
            Tab(icon: Icon(Icons.analytics_rounded), text: 'Laporan Penjualan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildCarsTab(),
          _buildDriversTab(),
          _buildUsersTab(),
          _buildOrdersTab(),
          _buildTransactionsTab(),
          _buildReportsTab(),
        ],
      ),
      floatingActionButton: _tabController.index > 3
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                if (_tabController.index == 0 || _tabController.index == 1) {
                  _showCarFormDialog();
                } else if (_tabController.index == 2) {
                  _showDriverFormDialog();
                } else if (_tabController.index == 3) {
                  _showUserFormDialog();
                }
              },
              backgroundColor: AppTheme.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                (_tabController.index == 0 || _tabController.index == 1)
                    ? 'Tambah Mobil'
                    : (_tabController.index == 2 ? 'Tambah Sopir' : 'Tambah User'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  void _confirmAdminLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Akun Admin',
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari Panel Administrator?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              TripRentStore.instance.logout();
              Navigator.of(context).popUntil((route) => route.isFirst);
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

  // --- UNAUTHORIZED / ACCESS DENIED SCREEN ---
  Widget _buildUnauthorizedScreen(BuildContext context) {
    final user = TripRentStore.instance.currentUser;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Panel Admin TripRent'),
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
                    border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: AppTheme.error,
                    size: 54,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Akses Ditolak',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Halaman Khusus Administrator',
                  style: TextStyle(
                    color: AppTheme.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user == null
                      ? 'Silakan masuk menggunakan akun Administrator untuk dapat mengelola armada, sopir, data pengguna, manajemen pesanan, dan laporan penjualan.'
                      : 'Akun Anda saat ini (${user.namaLengkap} - ${user.level}) bukan merupakan akun Administrator. Anda tidak memiliki izin untuk membuka halaman ini.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (user != null) {
                        TripRentStore.instance.logout();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(
                            promptMessage: 'Masuk dengan akun Admin (misal: robby@triprent.com atau admin@triprent.com).',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: Text(
                      user == null ? 'Login Akun Admin' : 'Ganti Akun ke Admin',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali ke Aplikasi', style: TextStyle(color: AppTheme.textMuted)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- USER FORM DIALOG (ADD & EDIT) ---
  void _showUserFormDialog({User? userToEdit}) {
    final isEdit = userToEdit != null;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: userToEdit?.namaLengkap ?? '');
    final emailController = TextEditingController(text: userToEdit?.email ?? '');
    final usernameController = TextEditingController(text: userToEdit?.username ?? '');
    final phoneController = TextEditingController(text: userToEdit?.noTelp ?? '');
    final passwordController = TextEditingController(text: userToEdit?.password ?? '');

    String selectedRole = userToEdit?.role ?? 'user';
    String selectedLevel = userToEdit?.level ?? (selectedRole == 'admin' ? 'Administrator' : 'VIP Member');

    final roles = ['user', 'admin'];
    final levels = [
      'Administrator',
      'Super Admin & Owner',
      'VIP Member',
      'Member',
      'Member Baru',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isEdit ? Icons.person_outline_rounded : Icons.person_add_rounded,
                      color: AppTheme.primaryLight,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEdit ? 'Edit Data Pengguna' : 'Tambah Pengguna Baru',
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDialogTextField('Nama Lengkap', nameController, Icons.badge_outlined, (v) => v!.trim().isEmpty ? 'Wajib diisi' : null),
                        const SizedBox(height: 12),
                        _buildDialogTextField('Email', emailController, Icons.email_outlined, (v) => v!.trim().isEmpty ? 'Wajib diisi' : null, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 12),
                        _buildDialogTextField('Username', usernameController, Icons.alternate_email_rounded, (v) => v!.trim().isEmpty ? 'Wajib diisi' : null),
                        const SizedBox(height: 12),
                        _buildDialogTextField('Nomor WhatsApp / HP', phoneController, Icons.phone_outlined, (v) => v!.trim().isEmpty ? 'Wajib diisi' : null, keyboardType: TextInputType.phone),
                        const SizedBox(height: 12),
                        _buildDialogTextField('Kata Sandi', passwordController, Icons.lock_outline_rounded, (v) => v!.trim().isEmpty ? 'Wajib diisi' : null),
                        const SizedBox(height: 14),

                        // Role Selector
                        const Text('Role / Hak Akses', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: _dropdownContainerDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedRole,
                              isExpanded: true,
                              dropdownColor: AppTheme.cardColor,
                              items: roles.map((r) => DropdownMenuItem(
                                value: r,
                                child: Text(r == 'admin' ? '🛡️ Administrator (Admin)' : '👤 Pengguna Biasa (Member)', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)),
                              )).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() {
                                    selectedRole = val;
                                    if (val == 'admin' && !selectedLevel.toLowerCase().contains('admin')) {
                                      selectedLevel = 'Administrator';
                                    } else if (val == 'user' && selectedLevel.toLowerCase().contains('admin')) {
                                      selectedLevel = 'VIP Member';
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Level Selector
                        const Text('Level Keanggotaan', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: _dropdownContainerDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedLevel,
                              isExpanded: true,
                              dropdownColor: AppTheme.cardColor,
                              items: levels.map((l) => DropdownMenuItem(
                                value: l,
                                child: Text(l, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)),
                              )).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() => selectedLevel = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal', style: TextStyle(color: AppTheme.textMuted)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final updatedUser = User(
                        id: userToEdit?.id ?? '${DateTime.now().millisecondsSinceEpoch}',
                        username: usernameController.text.trim(),
                        email: emailController.text.trim(),
                        namaLengkap: nameController.text.trim(),
                        noTelp: phoneController.text.trim(),
                        password: passwordController.text.trim(),
                        level: selectedLevel,
                        role: selectedRole,
                        foto: userToEdit?.foto ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
                      );

                      if (isEdit) {
                        TripRentStore.instance.updateUser(updatedUser);
                      } else {
                        TripRentStore.instance.addUser(updatedUser);
                      }

                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEdit ? 'Data pengguna berhasil diperbarui.' : 'Pengguna baru berhasil ditambahkan.'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Pengguna'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- USERS LIST TAB ---
  Widget _buildUsersTab() {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final allUsers = TripRentStore.instance.users;
        final filteredUsers = allUsers.where((u) {
          final q = _userSearchQuery.toLowerCase();
          return u.namaLengkap.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q) ||
              u.username.toLowerCase().contains(q) ||
              u.noTelp.contains(q) ||
              u.level.toLowerCase().contains(q);
        }).toList();

        final adminCount = allUsers.where((u) => u.isAdmin).length;
        final memberCount = allUsers.length - adminCount;

        return Column(
          children: [
            // Search Bar & Stats
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: TextField(
                        controller: _userSearchController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                        onChanged: (v) => setState(() => _userSearchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Cari nama, email, username...',
                          hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryLight, size: 18),
                          suffixIcon: _userSearchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 16, color: AppTheme.textMuted),
                                  onPressed: () {
                                    _userSearchController.clear();
                                    setState(() => _userSearchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showUserFormDialog(),
                    icon: const Icon(Icons.person_add, size: 16),
                    label: const Text('Input', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Summary Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _statusPill('Total: ${allUsers.length}', AppTheme.surfaceLight, AppTheme.textPrimary),
                  const SizedBox(width: 8),
                  _statusPill('🛡️ Admin: $adminCount', AppTheme.primary.withValues(alpha: 0.15), AppTheme.primaryLight),
                  const SizedBox(width: 8),
                  _statusPill('👤 Member: $memberCount', AppTheme.surfaceLight, AppTheme.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Users List
            Expanded(
              child: filteredUsers.isEmpty
                  ? _buildEmptyState(Icons.people_outline, 'Pengguna Tidak Ditemukan', 'Belum ada data pengguna yang cocok dengan pencarian.')
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: filteredUsers.length,
                      itemBuilder: (ctx, idx) {
                        final u = filteredUsers[idx];
                        final isCurrent = TripRentStore.instance.currentUser?.id == u.id;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: u.isAdmin
                                  ? AppTheme.primaryLight.withValues(alpha: 0.35)
                                  : AppTheme.cardBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppTheme.surfaceLight,
                                backgroundImage: u.foto != null ? NetworkImage(u.foto!) : null,
                                child: u.foto == null
                                    ? Text(
                                        u.namaLengkap.isNotEmpty ? u.namaLengkap[0].toUpperCase() : 'U',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryLight),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            u.namaLengkap,
                                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13.5, fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isCurrent) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: AppTheme.success.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text('Akun Anda', style: TextStyle(color: AppTheme.success, fontSize: 9.5, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '@${u.username} • ${u.email}',
                                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: u.isAdmin
                                                ? AppTheme.primary.withValues(alpha: 0.2)
                                                : AppTheme.surfaceLight,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: u.isAdmin
                                                  ? AppTheme.primaryLight.withValues(alpha: 0.4)
                                                  : AppTheme.cardBorder,
                                            ),
                                          ),
                                          child: Text(
                                            u.isAdmin ? '🛡️ ADMIN' : '👤 MEMBER',
                                            style: TextStyle(
                                              color: u.isAdmin ? AppTheme.primaryLight : AppTheme.textSecondary,
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(u.noTelp, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10.5)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryLight, size: 20),
                                onPressed: () => _showUserFormDialog(userToEdit: u),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppTheme.error, size: 20),
                                onPressed: () {
                                  if (isCurrent) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Anda tidak dapat menghapus akun Anda sendiri saat sedang login.'),
                                        backgroundColor: AppTheme.warning,
                                      ),
                                    );
                                    return;
                                  }
                                  _confirmDelete(
                                    title: 'Hapus Pengguna',
                                    message: 'Apakah Anda yakin ingin menghapus akun "${u.namaLengkap}" (${u.email})?',
                                    onConfirm: () {
                                      TripRentStore.instance.deleteUser(u.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Akun "${u.namaLengkap}" berhasil dihapus.')),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // --- ORDERS MANAGEMENT TAB (PROSES - PENDING - SELESAI - BATAL) ---
  Widget _buildOrdersTab() {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final allOrders = TripRentStore.instance.orders;
        final filteredOrders = allOrders.where((o) {
          final matchesStatus = _orderStatusFilter == 'Semua' || o.status.toLowerCase() == _orderStatusFilter.toLowerCase();
          final q = _orderSearchQuery.toLowerCase();
          final matchesQuery = q.isEmpty ||
              o.kodeOrders.toLowerCase().contains(q) ||
              o.namaPemesan.toLowerCase().contains(q) ||
              o.noTelpon.contains(q) ||
              o.car.nama.toLowerCase().contains(q) ||
              (o.ticketTitle?.toLowerCase().contains(q) ?? false);
          return matchesStatus && matchesQuery;
        }).toList();

        final pendingCount = allOrders.where((o) => o.status == 'Pending').length;
        final prosesCount = allOrders.where((o) => o.status == 'Proses').length;
        final selesaiCount = allOrders.where((o) => o.status == 'Selesai').length;
        final batalCount = allOrders.where((o) => o.status == 'Dibatalkan').length;

        return Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: TextField(
                  controller: _orderSearchController,
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                  onChanged: (v) => setState(() => _orderSearchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Cari kode order, nama pemesan, mobil/tiket...',
                    hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryLight, size: 18),
                    suffixIcon: _orderSearchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16, color: AppTheme.textMuted),
                            onPressed: () {
                              _orderSearchController.clear();
                              setState(() => _orderSearchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Horizontal Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _orderFilterChip('Semua', 'Semua (${allOrders.length})'),
                  const SizedBox(width: 6),
                  _orderFilterChip('Pending', '⏳ Pending ($pendingCount)', color: AppTheme.warning),
                  const SizedBox(width: 6),
                  _orderFilterChip('Proses', '🔄 Proses ($prosesCount)', color: AppTheme.primaryLight),
                  const SizedBox(width: 6),
                  _orderFilterChip('Selesai', '✅ Selesai ($selesaiCount)', color: AppTheme.success),
                  const SizedBox(width: 6),
                  _orderFilterChip('Dibatalkan', '❌ Batal ($batalCount)', color: AppTheme.error),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Orders List
            Expanded(
              child: filteredOrders.isEmpty
                  ? _buildEmptyState(Icons.receipt_long_outlined, 'Tidak Ada Pesanan', 'Tidak ditemukan pesanan dengan status atau kata kunci yang dipilih.')
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: filteredOrders.length,
                      itemBuilder: (ctx, idx) {
                        final order = filteredOrders[idx];
                        return _buildOrderCard(order);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _orderFilterChip(String statusKey, String label, {Color? color}) {
    final isSelected = _orderStatusFilter == statusKey;
    final chipColor = color ?? AppTheme.primaryLight;
    return InkWell(
      onTap: () => setState(() => _orderStatusFilter = statusKey),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withValues(alpha: 0.2) : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? chipColor : AppTheme.cardBorder,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? chipColor : AppTheme.textSecondary,
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(RentalOrder order) {
    Color statusBg;
    Color statusColor;
    IconData statusIcon;

    switch (order.status) {
      case 'Selesai':
        statusBg = AppTheme.success.withValues(alpha: 0.15);
        statusColor = AppTheme.success;
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      case 'Pending':
        statusBg = AppTheme.warning.withValues(alpha: 0.15);
        statusColor = AppTheme.warning;
        statusIcon = Icons.hourglass_top_rounded;
        break;
      case 'Dibatalkan':
        statusBg = AppTheme.error.withValues(alpha: 0.15);
        statusColor = AppTheme.error;
        statusIcon = Icons.cancel_outlined;
        break;
      default: // Proses
        statusBg = AppTheme.primary.withValues(alpha: 0.15);
        statusColor = AppTheme.primaryLight;
        statusIcon = Icons.sync_rounded;
    }

    final isTicket = order.isTicket;
    final itemTitle = isTicket ? (order.ticketTitle ?? 'Tiket Perjalanan') : order.car.nama;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Code & Status Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isTicket ? AppTheme.accent.withValues(alpha: 0.15) : AppTheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isTicket ? '🎫 TIKET TRAVEL' : '🚗 SEWA MOBIL',
                  style: TextStyle(
                    color: isTicket ? AppTheme.accent : AppTheme.primaryLight,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.kodeOrders,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      order.status,
                      style: TextStyle(color: statusColor, fontSize: 10.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            itemTitle,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          // Customer info
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: AppTheme.textMuted),
              const SizedBox(width: 6),
              Text(
                '${order.namaPemesan} (${order.noTelpon})',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11.5),
              ),
              const Spacer(),
              InkWell(
                onTap: () => WhatsAppHelper.openChat(
                  message: 'Halo ${order.namaPemesan}, kami dari TripRent ingin mengonfirmasi pesanan Anda dengan kode ${order.kodeOrders}.',
                ),
                child: const Row(
                  children: [
                    Icon(Icons.chat_outlined, size: 14, color: AppTheme.success),
                    SizedBox(width: 4),
                    Text('Chat WA', style: TextStyle(color: AppTheme.success, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Route info
          Row(
            children: [
              const Icon(Icons.route_outlined, size: 14, color: AppTheme.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${order.jemput} ➔ ${order.tujuan}',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.badge_rounded, size: 15, color: AppTheme.primaryLight),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    order.pakaiSopir
                        ? (order.driver != null
                            ? 'Supir: ${order.driver!.nama} (${order.driverTaskStatus})'
                            : 'Membutuhkan Supir (Belum Ditugaskan)')
                        : 'Sewa Lepas Kunci (Tanpa Supir)',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () => _showAssignDriverDialog(order),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.driver == null ? 'Tentukan Supir' : 'Ganti',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.payment_rounded, size: 14, color: AppTheme.textMuted),
              const SizedBox(width: 6),
              const Text('Status Pembayaran: ', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              Text(
                order.paymentStatus,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: order.paymentStatus == 'Lunas' ? AppTheme.success : AppTheme.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppTheme.cardBorder),
          const SizedBox(height: 10),

          // Bottom Action Row: Total Price & Status Changing Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                  Text(
                    Formatters.rupiah(order.totalHarga),
                    style: const TextStyle(color: AppTheme.primaryLight, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  // Change Status Popup
                  PopupMenuButton<String>(
                    tooltip: 'Ubah Status Pesanan',
                    color: AppTheme.cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (newStatus) {
                      TripRentStore.instance.updateOrderStatus(order.kodeOrders, newStatus);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Status pesanan "${order.kodeOrders}" diubah menjadi: $newStatus'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'Proses',
                        child: Row(children: [Icon(Icons.sync_rounded, color: AppTheme.primaryLight, size: 16), SizedBox(width: 8), Text('Set: Proses')]),
                      ),
                      const PopupMenuItem(
                        value: 'Pending',
                        child: Row(children: [Icon(Icons.hourglass_top_rounded, color: AppTheme.warning, size: 16), SizedBox(width: 8), Text('Set: Pending')]),
                      ),
                      const PopupMenuItem(
                        value: 'Selesai',
                        child: Row(children: [Icon(Icons.check_circle_outline_rounded, color: AppTheme.success, size: 16), SizedBox(width: 8), Text('Set: Selesai')]),
                      ),
                      const PopupMenuItem(
                        value: 'Dibatalkan',
                        child: Row(children: [Icon(Icons.cancel_outlined, color: AppTheme.error, size: 16), SizedBox(width: 8), Text('Set: Dibatalkan')]),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.edit_note_rounded, size: 15, color: AppTheme.primaryLight),
                          SizedBox(width: 4),
                          Text('Ubah Status', style: TextStyle(color: AppTheme.primaryLight, fontSize: 11, fontWeight: FontWeight.bold)),
                          Icon(Icons.arrow_drop_down, size: 16, color: AppTheme.primaryLight),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppTheme.error, size: 18),
                    tooltip: 'Hapus Pesanan',
                    onPressed: () {
                      _confirmDelete(
                        title: 'Hapus Pesanan',
                        message: 'Apakah Anda yakin ingin menghapus data pesanan "${order.kodeOrders}"?',
                        onConfirm: () {
                          TripRentStore.instance.deleteOrder(order.kodeOrders);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pesanan "${order.kodeOrders}" berhasil dihapus.')),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAssignDriverDialog(RentalOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final drivers = TripRentStore.instance.drivers.where((d) => d.isAktif).toList();
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              Text(
                'Tentukan Supir untuk ${order.kodeOrders}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text('Pilih supir yang tersedia untuk penugasan perjalanan ini:',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const SizedBox(height: 16),
              if (drivers.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('Belum ada supir aktif.')),
                )
              else
                ...drivers.map((drv) {
                  final isCurrent = order.driver?.id == drv.id;
                  Color statusCol = AppTheme.success;
                  if (drv.statusKetersediaan == 'Dalam Perjalanan') statusCol = AppTheme.primaryLight;
                  if (drv.statusKetersediaan == 'Istirahat') statusCol = AppTheme.textMuted;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isCurrent ? AppTheme.surfaceLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isCurrent ? AppTheme.primaryLight : AppTheme.cardBorder),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(drv.foto)),
                      title: Text(drv.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Row(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: statusCol, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text('${drv.statusKetersediaan} • ★ ${drv.rating}', style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          TripRentStore.instance.assignDriverToOrder(order.kodeOrders, drv.id);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Supir ${drv.nama} berhasil ditugaskan ke pesanan ${order.kodeOrders}!'),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCurrent ? AppTheme.success : AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        child: Text(isCurrent ? 'Terpilih' : 'Pilih Supir'),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // --- KELOLA TRANSAKSI & PEMBAYARAN TAB ---
  Widget _buildTransactionsTab() {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final txns = TripRentStore.instance.transactions;
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.cardBorder),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Pendapatan Terverifikasi', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(Formatters.rupiah(TripRentStore.instance.totalRevenue), style: const TextStyle(color: AppTheme.success, fontSize: 17, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(height: 36, width: 1, color: AppTheme.cardBorder),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Menunggu Verifikasi', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(Formatters.rupiah(TripRentStore.instance.totalPendingPaymentRevenue), style: const TextStyle(color: AppTheme.warning, fontSize: 17, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: txns.isEmpty
                  ? _buildEmptyState(Icons.receipt_long_rounded, 'Belum Ada Transaksi', 'Transaksi pembayaran dari pelanggan akan tampil di sini.')
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      itemCount: txns.length,
                      itemBuilder: (ctx, idx) {
                        final txn = txns[idx];
                        Color badgeColor = AppTheme.warning;
                        if (txn.status == 'Lunas') {
                          badgeColor = AppTheme.success;
                        } else if (txn.status == 'Ditolak') {
                          badgeColor = AppTheme.error;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppTheme.cardBorder),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(txn.orderCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryLight)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: badgeColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(txn.status, style: TextStyle(color: badgeColor, fontSize: 10.5, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(txn.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
                              const SizedBox(height: 2),
                              Text('${txn.itemName} • ${txn.paymentMethod}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                              const SizedBox(height: 10),
                              const Divider(height: 1, color: AppTheme.cardBorder),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Nominal Pembayaran', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                                      Text(Formatters.rupiah(txn.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
                                    ],
                                  ),
                                  if (txn.status != 'Lunas')
                                    Row(
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            TripRentStore.instance.verifyPayment(txn.orderCode, 'Ditolak');
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppTheme.error,
                                            side: const BorderSide(color: AppTheme.error),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            textStyle: const TextStyle(fontSize: 11),
                                          ),
                                          child: const Text('Tolak'),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            TripRentStore.instance.verifyPayment(txn.orderCode, 'Lunas');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.success,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          child: const Text('Verifikasi Lunas'),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // --- SALES REPORT & ANALYTICS TAB ---
  Widget _buildReportsTab() {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final store = TripRentStore.instance;
        final allOrders = store.orders;

        final totalRevenue = store.totalRevenue;
        final completedRevenue = store.totalCompletedRevenue;
        final carRevenue = store.totalCarRentalsRevenue;
        final ticketRevenue = store.totalTicketsRevenue;

        final completedCount = store.countCompletedOrders;
        final processCount = store.countProcessOrders;
        final pendingCount = store.countPendingOrders;
        final cancelledCount = store.countCancelledOrders;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Period Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Laporan & Analisis Penjualan',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _reportPeriod,
                      dropdownColor: AppTheme.cardColor,
                      items: ['Semua Waktu', 'Bulan Ini', 'Minggu Ini', 'Hari Ini'].map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 11.5)),
                      )).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _reportPeriod = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Big Revenue Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL PENDAPATAN (OMSET)',
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.trending_up_rounded, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Aktif', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Formatters.rupiah(totalRevenue),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Dari ${allOrders.length} total pesanan tercatat di sistem',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Two-column Revenue Breakdown
            Row(
              children: [
                Expanded(
                  child: _buildReportMetricCard(
                    title: 'Sewa Mobil',
                    amount: Formatters.rupiah(carRevenue),
                    icon: Icons.directions_car_filled_rounded,
                    accentColor: AppTheme.primaryLight,
                    subtitle: 'Rental Harian & Lepas Kunci',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildReportMetricCard(
                    title: 'Tiket Travel',
                    amount: Formatters.rupiah(ticketRevenue),
                    icon: Icons.confirmation_number_rounded,
                    accentColor: AppTheme.accent,
                    subtitle: 'Shuttle & Travel Antar Kota',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Completed Revenue Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.check_circle_outline_rounded, color: AppTheme.success, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pendapatan Pesanan Selesai', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                        Text(
                          Formatters.rupiah(completedRevenue),
                          style: const TextStyle(color: AppTheme.success, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$completedCount Selesai',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Status Distribution Summary
            const Text(
              'Distribusi Status Pesanan',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _statusMiniCard('Selesai', completedCount, AppTheme.success, Icons.check_circle_outline)),
                const SizedBox(width: 8),
                Expanded(child: _statusMiniCard('Proses', processCount, AppTheme.primaryLight, Icons.sync_rounded)),
                const SizedBox(width: 8),
                Expanded(child: _statusMiniCard('Pending', pendingCount, AppTheme.warning, Icons.hourglass_top)),
                const SizedBox(width: 8),
                Expanded(child: _statusMiniCard('Batal', cancelledCount, AppTheme.error, Icons.cancel_outlined)),
              ],
            ),
            const SizedBox(height: 24),

            // Detailed Transactions List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rincian Transaksi Penjualan',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${allOrders.length} Transaksi',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11.5),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...allOrders.map((order) {
              final isTicket = order.isTicket;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
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
                        color: isTicket ? AppTheme.accent.withValues(alpha: 0.15) : AppTheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isTicket ? Icons.confirmation_number_outlined : Icons.directions_car_filled_outlined,
                        color: isTicket ? AppTheme.accent : AppTheme.primaryLight,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTicket ? (order.ticketTitle ?? 'Tiket Perjalanan') : order.car.nama,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12.5, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${order.namaPemesan} • ${Formatters.dateShort(order.waktu)}',
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Formatters.rupiah(order.totalHarga),
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12.5, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.status,
                          style: TextStyle(
                            color: order.status == 'Selesai'
                                ? AppTheme.success
                                : (order.status == 'Pending' ? AppTheme.warning : AppTheme.primaryLight),
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  Widget _buildReportMetricCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color accentColor,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(color: accentColor, fontSize: 11.5, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(amount, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _statusMiniCard(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 9.5)),
        ],
      ),
    );
  }

  Widget _statusPill(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 54, color: AppTheme.textMuted.withValues(alpha: 0.5)),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // --- 1. DASHBOARD STATISTIK UTAMA (ADMIN) ---
  Widget _buildDashboardTab() {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final store = TripRentStore.instance;
        final totalCars = store.cars.length;
        final activeCars = store.countActiveCars;
        final totalUsers = store.countUsers;
        final totalDrivers = store.drivers.length;
        final availableDrivers = store.countAvailableDrivers;
        final totalBookings = store.countAllBookings;
        final totalTransactions = store.countAllTransactions;
        final totalRevenue = store.totalRevenue;
        final completedRevenue = store.totalCompletedRevenue;
        final pendingPayment = store.totalPendingPaymentRevenue;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Welcome Banner
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DASHBOARD ADMINISTRATOR',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  store.currentUser?.namaLengkap ?? 'Admin TripRent',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.success.withValues(alpha: 0.5)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, color: AppTheme.success, size: 8),
                              SizedBox(width: 6),
                              Text(
                                'Sistem Aktif',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Estimasi Omset',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              Formatters.rupiah(totalRevenue),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Omset Selesai',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              Formatters.rupiah(completedRevenue),
                              style: const TextStyle(
                                color: Color(0xFF6EE7B7),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // SECTION: STATISTIK UTAMA (5 METRIK WAJIB SESUAI SPESIFIKASI)
              const Text(
                'Statistik Utama TripRent',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ringkasan real-time 5 pilar operasional sistem TripRent',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 14),

              // 1. TOTAL MOBIL & 2. TOTAL PENGGUNA
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Mobil',
                      value: '$totalCars Armada',
                      subtitle: '$activeCars aktif • ${totalCars - activeCars} nonaktif',
                      icon: Icons.directions_car_filled_rounded,
                      color: AppTheme.primaryLight,
                      onTap: () => _tabController.animateTo(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Pengguna',
                      value: '$totalUsers User',
                      subtitle: 'Pelanggan terdaftar',
                      icon: Icons.people_alt_rounded,
                      color: const Color(0xFF0EA5E9),
                      onTap: () => _tabController.animateTo(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 3. TOTAL SUPIR & 4. TOTAL PEMESANAN
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Supir',
                      value: '$totalDrivers Sopir',
                      subtitle: '$availableDrivers siap • ${totalDrivers - availableDrivers} on duty',
                      icon: Icons.badge_rounded,
                      color: const Color(0xFF10B981),
                      onTap: () => _tabController.animateTo(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Pemesanan',
                      value: '$totalBookings Order',
                      subtitle: '${store.countProcessOrders} proses • ${store.countCompletedOrders} selesai',
                      icon: Icons.receipt_long_rounded,
                      color: const Color(0xFFF59E0B),
                      onTap: () => _tabController.animateTo(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 5. TOTAL TRANSAKSI (CARD UTAMA)
              _buildStatCard(
                title: 'Total Transaksi & Pembayaran',
                value: '$totalTransactions Transaksi Tercatat',
                subtitle: 'Menunggu Verifikasi: ${store.transactions.where((t) => t.isPending).length} • Pending: ${Formatters.rupiah(pendingPayment)}',
                icon: Icons.paid_rounded,
                color: const Color(0xFF6366F1),
                isFullWidth: true,
                onTap: () => _tabController.animateTo(5),
              ),
              const SizedBox(height: 24),

              // SECTION: DISTRIBUSI STATUS PEMESANAN
              const Text(
                'Distribusi Status Pesanan',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _statusMiniCard('Selesai', store.countCompletedOrders, AppTheme.success, Icons.check_circle_outline)),
                  const SizedBox(width: 8),
                  Expanded(child: _statusMiniCard('Proses', store.countProcessOrders, AppTheme.primaryLight, Icons.sync_rounded)),
                  const SizedBox(width: 8),
                  Expanded(child: _statusMiniCard('Pending', store.countPendingOrders, AppTheme.warning, Icons.hourglass_top)),
                  const SizedBox(width: 8),
                  Expanded(child: _statusMiniCard('Batal', store.countCancelledOrders, AppTheme.error, Icons.cancel_outlined)),
                ],
              ),
              const SizedBox(height: 24),

              // SECTION: PINTASAN MANAJEMEN CEPAT
              const Text(
                'Pintasan Manajemen Cepat',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cardBorder),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    _buildShortcutRow(
                      icon: Icons.add_circle_outline_rounded,
                      title: 'Tambah Armada Mobil Baru',
                      subtitle: 'Tambahkan data mobil, tarif harian & foto',
                      color: AppTheme.primaryLight,
                      onTap: () {
                        _tabController.animateTo(1);
                        _showCarFormDialog();
                      },
                    ),
                    const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                    _buildShortcutRow(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Tambah Akun Mitra Supir',
                      subtitle: 'Registrasikan supir dan buatkan akun login',
                      color: const Color(0xFF10B981),
                      onTap: () {
                        _tabController.animateTo(2);
                        _showDriverFormDialog();
                      },
                    ),
                    const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                    _buildShortcutRow(
                      icon: Icons.assignment_ind_rounded,
                      title: 'Tugaskan Supir ke Pemesanan',
                      subtitle: 'Pilih pesanan ber-sopir dan tetapkan driver',
                      color: const Color(0xFFF59E0B),
                      onTap: () => _tabController.animateTo(4),
                    ),
                    const Divider(height: 1, indent: 56, color: AppTheme.cardBorder),
                    _buildShortcutRow(
                      icon: Icons.verified_user_rounded,
                      title: 'Verifikasi Pembayaran User',
                      subtitle: 'Konfirmasi bukti transfer bank pelanggan',
                      color: const Color(0xFF6366F1),
                      onTap: () => _tabController.animateTo(5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.cardBorder),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textMuted, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
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
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  // --- CARS LIST TAB ---
  Widget _buildCarsTab() {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final allCars = TripRentStore.instance.cars;
        final filteredCars = allCars.where((c) {
          final q = _carSearchQuery.toLowerCase();
          return c.nama.toLowerCase().contains(q) ||
              c.category.toLowerCase().contains(q) ||
              c.mesin.toLowerCase().contains(q);
        }).toList();

        return Column(
          children: [
            // Search & Counter
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: TextField(
                        controller: _carSearchController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                        onChanged: (v) => setState(() => _carSearchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Cari mobil atau kategori...',
                          hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryLight, size: 18),
                          suffixIcon: _carSearchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 16, color: AppTheme.textMuted),
                                  onPressed: () {
                                    _carSearchController.clear();
                                    setState(() => _carSearchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showCarFormDialog(),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Input', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: filteredCars.isEmpty
                  ? const Center(
                      child: Text('Tidak ada mobil ditemukan', style: TextStyle(color: AppTheme.textMuted)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                      itemCount: filteredCars.length,
                      itemBuilder: (ctx, idx) {
                        final car = filteredCars[idx];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppTheme.cardBorder),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  car.gambarUtama,
                                  width: 80,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 80,
                                    height: 60,
                                    color: AppTheme.surfaceLight,
                                    child: const Icon(Icons.directions_car, color: AppTheme.textMuted),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car.nama,
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${car.category} • ${car.transmisi}',
                                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${Formatters.rupiah(car.hargaSewa)} /hari (Sopir: ${Formatters.rupiah(car.hargaSopir)})',
                                      style: const TextStyle(
                                        color: AppTheme.primaryLight,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryLight, size: 20),
                                onPressed: () => _showCarFormDialog(carToEdit: car),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppTheme.error, size: 20),
                                onPressed: () {
                                  _confirmDelete(
                                    title: 'Hapus Mobil',
                                    message: 'Apakah Anda yakin ingin menghapus "${car.nama}" dari daftar armada?',
                                    onConfirm: () {
                                      TripRentStore.instance.deleteCar(car.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Mobil "${car.nama}" berhasil dihapus.')),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // --- DRIVERS LIST TAB ---
  Widget _buildDriversTab() {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final allDrivers = TripRentStore.instance.drivers;
        final filteredDrivers = allDrivers.where((d) {
          final q = _driverSearchQuery.toLowerCase();
          return d.nama.toLowerCase().contains(q) ||
              d.alamat.toLowerCase().contains(q) ||
              d.noHp.contains(q);
        }).toList();

        return Column(
          children: [
            // Search & Add
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: TextField(
                        controller: _driverSearchController,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                        onChanged: (v) => setState(() => _driverSearchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Cari nama sopir, no HP...',
                          hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryLight, size: 18),
                          suffixIcon: _driverSearchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 16, color: AppTheme.textMuted),
                                  onPressed: () {
                                    _driverSearchController.clear();
                                    setState(() => _driverSearchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _showDriverFormDialog(),
                    icon: const Icon(Icons.person_add, size: 16),
                    label: const Text('Input', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: filteredDrivers.isEmpty
                  ? const Center(
                      child: Text('Tidak ada data sopir ditemukan', style: TextStyle(color: AppTheme.textMuted)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                      itemCount: filteredDrivers.length,
                      itemBuilder: (ctx, idx) {
                        final driver = filteredDrivers[idx];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppTheme.cardBorder),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundImage: NetworkImage(driver.foto),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            driver.nama,
                                            style: const TextStyle(
                                              color: AppTheme.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: driver.tersedia
                                                ? AppTheme.success.withValues(alpha: 0.15)
                                                : AppTheme.warning.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            driver.tersedia ? 'Tersedia' : 'Sibuk',
                                            style: TextStyle(
                                              color: driver.tersedia ? AppTheme.success : AppTheme.warning,
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${driver.jenisKelamin} • ${driver.noHp}',
                                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      driver.keterangan,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryLight, size: 20),
                                onPressed: () => _showDriverFormDialog(driverToEdit: driver),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppTheme.error, size: 20),
                                onPressed: () {
                                  _confirmDelete(
                                    title: 'Hapus Sopir',
                                    message: 'Apakah Anda yakin ingin menghapus data sopir "${driver.nama}"?',
                                    onConfirm: () {
                                      TripRentStore.instance.deleteDriver(driver.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Data sopir "${driver.nama}" berhasil dihapus.')),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
