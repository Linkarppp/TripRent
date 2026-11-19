import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/formatters.dart';
import 'ticket_qr_code.dart';

/// Modal helper untuk menampilkan E-Tiket Shuttle secara instan
void showShuttleETicketModal(BuildContext context, RentalOrder order) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => ShuttleETicketSheet(order: order),
  );
}

/// ShuttleETicketSheet: BottomSheet / Dialog tampilan E-Tiket resmi TripRent
class ShuttleETicketSheet extends StatelessWidget {
  final RentalOrder order;

  const ShuttleETicketSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppTheme.cardBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header title bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.confirmation_num_rounded, color: AppTheme.primaryLight, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'E-Tiket Perjalanan Resmi',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Scrollable ticket card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
              child: ShuttleETicketCard(order: order),
            ),
          ),
        ],
      ),
    );
  }
}

/// ShuttleETicketCard: Komponen kartu E-Tiket dengan desain boarding-pass modern,
/// cutout perforated line, logo TripRent, QR code unik, dan detail penumpang.
class ShuttleETicketCard extends StatelessWidget {
  final RentalOrder order;

  const ShuttleETicketCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = Formatters.dateShort(order.dariTanggal);
    final departureTime = order.departureTime ?? '08:00 WIB';
    final seatText = (order.seatNumbers != null && order.seatNumbers!.isNotEmpty)
        ? order.seatNumbers!
        : 'Kursi Terkonfirmasi';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ==========================================
          // 1. TICKET HEADER (Logo & Booking Code)
          // ==========================================
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A), // TripRent Navy Blue
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Logo
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.directions_bus_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TRIPRENT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'Shuttle & Travel Pass',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Payment Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF10B981), width: 1.2),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 14),
                          SizedBox(width: 5),
                          Text(
                            'LUNAS',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Booking Code Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'KODE BOOKING',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.kodeOrders,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: order.kodeOrders));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kode booking berhasil disalin!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.copy_rounded, color: Colors.white, size: 13),
                            SizedBox(width: 4),
                            Text(
                              'Salin Kode',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. ROUTE & DEPARTURE SECTION
          // ==========================================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              children: [
                // Route Visual (Origin -> Destination)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'KEBERANGKATAN',
                            style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.jemput,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              departureTime,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          SizedBox(height: 14),
                          Icon(Icons.arrow_forward_rounded, color: AppTheme.primaryLight, size: 24),
                          SizedBox(height: 2),
                          Text(
                            'Direct Shuttle',
                            style: TextStyle(fontSize: 9, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'TUJUAN AKHIR',
                            style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.tujuan,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ==========================================
          // 3. PERFORATED CUTOUT DIVIDER LINE
          // ==========================================
          _buildPerforatedDivider(),

          // ==========================================
          // 4. PASSENGER & TICKET DETAILS
          // ==========================================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              children: [
                _buildInfoRow('Nama Penumpang', order.namaPemesan, Icons.person_outline_rounded),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(
                        'Jumlah Orang',
                        '${order.passengerCount} Penumpang',
                        Icons.group_outlined,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildInfoRow(
                        'Nomor Kursi',
                        seatText,
                        Icons.airline_seat_recline_extra_rounded,
                        valueColor: AppTheme.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(
                        'Armada Kendaraan',
                        order.car.nama,
                        Icons.airport_shuttle_outlined,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildInfoRow(
                        'Metode Bayar',
                        order.paymentMethodType ?? order.bankPembayaran.split(' ').first,
                        Icons.payment_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Total Tagihan Lunas',
                  Formatters.rupiah(order.totalHarga),
                  Icons.receipt_rounded,
                  valueColor: const Color(0xFF10B981),
                ),
              ],
            ),
          ),

          // ==========================================
          // 5. QR CODE SECTION
          // ==========================================
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              border: const Border(
                top: BorderSide(color: AppTheme.cardBorder, width: 1),
              ),
            ),
            child: Column(
              children: [
                TicketQrCodeWidget(
                  data: 'TRIPRENT:TICKET:${order.kodeOrders}:${order.namaPemesan}:${order.dariTanggal.millisecondsSinceEpoch}',
                  size: 160,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Pindai QR Code untuk Boarding',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tunjukkan QR Code ini kepada petugas outlet shuttle sebelum keberangkatan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Share / Save Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: 'E-Tiket TripRent:\n'
                                  'Kode: ${order.kodeOrders}\n'
                                  'Penumpang: ${order.namaPemesan}\n'
                                  'Rute: ${order.jemput} → ${order.tujuan}\n'
                                  'Jadwal: $formattedDate • $departureTime\n'
                                  'Kursi: $seatText\n'
                                  'Status: LUNAS',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Rincian e-tiket berhasil disalin ke clipboard!')),
                          );
                        },
                        icon: const Icon(Icons.share_rounded, size: 16),
                        label: const Text('Bagikan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textPrimary,
                          side: const BorderSide(color: AppTheme.cardBorder),
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
                            const SnackBar(
                              content: Text('E-Tiket tersimpan di aplikasi pada menu Pesanan Saya.'),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        },
                        icon: const Icon(Icons.save_alt_rounded, size: 16),
                        label: const Text('Simpan'),
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
          ),
        ],
      ),
    );
  }

  Widget _buildPerforatedDivider() {
    return Row(
      children: [
        // Left notch
        Container(
          width: 16,
          height: 32,
          decoration: const BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
          ),
        ),
        // Dashed divider line
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const dashWidth = 6.0;
              const dashSpace = 4.0;
              final dashCount = (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
              return Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: List.generate(dashCount, (_) {
                  return const SizedBox(
                    width: dashWidth,
                    height: 1.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: AppTheme.cardBorder),
                    ),
                  );
                }),
              );
            },
          ),
        ),
        // Right notch
        Container(
          width: 16,
          height: 32,
          decoration: const BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryLight),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppTheme.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
