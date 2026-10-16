import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../theme/app_theme.dart';

class DriversScreen extends StatelessWidget {
  const DriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drivers = TripRentStore.instance.drivers;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Tim Sopir Profesional'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        itemCount: drivers.length,
        itemBuilder: (ctx, idx) {
          final driver = drivers[idx];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppTheme.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundImage: NetworkImage(driver.foto),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  driver.nama,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
                                ),
                                child: const Text(
                                  'Siap Bertugas',
                                  style: TextStyle(
                                    color: AppTheme.success,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${driver.jenisKelamin} • Asal ${driver.tempatLahir}',
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppTheme.warning, size: 16),
                              const SizedBox(width: 3),
                              Text(
                                driver.rating.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.verified, color: AppTheme.primaryLight, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${driver.totalPerjalanan} Perjalanan',
                                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: AppTheme.cardBorder, height: 1),
                const SizedBox(height: 12),

                Text(
                  driver.keterangan,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        driver.alamat,
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Menghubungi ${driver.nama} (${driver.noHp})...')),
                          );
                        },
                        icon: const Icon(Icons.chat_outlined, size: 16),
                        label: const Text('WhatsApp', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.success,
                          side: BorderSide(color: AppTheme.success.withValues(alpha: 0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Memulai panggilan ke ${driver.nama}...')),
                          );
                        },
                        icon: const Icon(Icons.call, size: 16),
                        label: const Text('Panggil Sopir', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
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
