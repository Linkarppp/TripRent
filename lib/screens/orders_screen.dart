import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/formatters.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedStatus = 'Semua';

  final List<String> _statusFilters = ['Semua', 'Proses', 'Selesai', 'Pending'];

  void _showInvoiceDialog(RentalOrder order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppTheme.cardBorder),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Detail Pesanan',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildStatusBadge(order.status),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kode: ${order.kodeOrders}',
                style: const TextStyle(color: AppTheme.primaryLight, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _dialogRow('Pemesan', order.namaPemesan),
              _dialogRow('No. Telpon', order.noTelpon),
              _dialogRow('Email', order.email),
              _dialogRow('Mobil', order.car.nama),
              _dialogRow('Layanan', order.pakaiSopir ? 'Dengan Sopir (${order.driver?.nama ?? "Driver"})' : 'Lepas Kunci'),
              _dialogRow('Periode', '${Formatters.dateShort(order.dariTanggal)} - ${Formatters.dateShort(order.sampaiTanggal)} (${order.totalHari} Hari)'),
              _dialogRow('Penjemputan', order.jemput),
              _dialogRow('Tujuan', order.tujuan),
              if (order.keterangan.isNotEmpty) _dialogRow('Catatan', order.keterangan),
              const Divider(color: AppTheme.cardBorder, height: 20),
              _dialogRow('Rekening', order.bankPembayaran),
              _dialogRow('Total Tagihan', Formatters.rupiah(order.totalHarga), isBold: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: AppTheme.primaryLight)),
          ),
        ],
      ),
    );
  }

  Widget _dialogRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isBold ? AppTheme.success : AppTheme.textPrimary,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'proses':
        color = AppTheme.primaryLight;
        break;
      case 'selesai':
        color = AppTheme.success;
        break;
      case 'pending':
        color = AppTheme.warning;
        break;
      default:
        color = AppTheme.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final allOrders = TripRentStore.instance.orders;
        final filteredOrders = _selectedStatus == 'Semua'
            ? allOrders
            : allOrders.where((o) => o.status.toLowerCase() == _selectedStatus.toLowerCase()).toList();

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('Pesanan & Riwayat Sewa'),
          ),
          body: Column(
            children: [
              // Filter Chips
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: _statusFilters.map((st) {
                    final isSel = _selectedStatus == st;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedStatus = st),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? AppTheme.primary : AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSel ? AppTheme.primaryLight : AppTheme.cardBorder,
                            ),
                          ),
                          child: Text(
                            st,
                            style: TextStyle(
                              color: isSel ? Colors.white : AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Orders List
              Expanded(
                child: filteredOrders.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 54, color: AppTheme.textMuted),
                            SizedBox(height: 12),
                            Text('Belum ada pesanan pada kategori ini.',
                                style: TextStyle(color: AppTheme.textSecondary)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                        itemCount: filteredOrders.length,
                        itemBuilder: (ctx, idx) {
                          final order = filteredOrders[idx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.cardBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Code + Status
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order.kodeOrders,
                                      style: const TextStyle(
                                        color: AppTheme.primaryLight,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    _buildStatusBadge(order.status),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(color: AppTheme.cardBorder, height: 1),
                                const SizedBox(height: 12),

                                // Car Info
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        order.car.gambarUtama,
                                        width: 65,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          width: 65,
                                          height: 50,
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
                                            order.car.nama,
                                            style: const TextStyle(
                                              color: AppTheme.textPrimary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            'Pemesan: ${order.namaPemesan}',
                                            style: const TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Route Info
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceLight.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.my_location, size: 14, color: AppTheme.primaryLight),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              order.jemput,
                                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 14, color: AppTheme.danger),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              order.tujuan,
                                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Dates & Driver tag
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 12, color: AppTheme.textMuted),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${Formatters.dateShort(order.dariTanggal)} - ${Formatters.dateShort(order.sampaiTanggal)} (${order.totalHari}h)',
                                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.cardBorder,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        order.pakaiSopir ? 'Dengan Sopir' : 'Lepas Kunci',
                                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // Price & Action Button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Total Pembayaran',
                                            style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                                        Text(
                                          Formatters.rupiah(order.totalHarga),
                                          style: const TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    OutlinedButton(
                                      onPressed: () => _showInvoiceDialog(order),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppTheme.primaryLight,
                                        side: const BorderSide(color: AppTheme.cardBorder),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      child: const Text('Detail Invoice', style: TextStyle(fontSize: 12)),
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
          ),
        );
      },
    );
  }
}
