import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../widgets/formatters.dart';
import 'payment_method_selector.dart';
import 'shuttle_eticket_card.dart';

/// Modal dialog untuk memilih metode pembayaran dan konfirmasi pembayaran pesanan
void showPaymentCheckoutDialog({
  required BuildContext context,
  required RentalOrder order,
  VoidCallback? onPaymentSuccess,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => PaymentCheckoutSheet(
      order: order,
      onPaymentSuccess: onPaymentSuccess,
    ),
  );
}

class PaymentCheckoutSheet extends StatefulWidget {
  final RentalOrder order;
  final VoidCallback? onPaymentSuccess;

  const PaymentCheckoutSheet({
    super.key,
    required this.order,
    this.onPaymentSuccess,
  });

  @override
  State<PaymentCheckoutSheet> createState() => _PaymentCheckoutSheetState();
}

class _PaymentCheckoutSheetState extends State<PaymentCheckoutSheet> {
  PaymentSelection _currentSelection = const PaymentSelection(
    category: 'Transfer Bank',
    channel: 'BCA',
    accountNumber: '0320-9436-47',
    accountHolder: 'PT TripRent Nusantara',
    instructions: 'Transfer tepat hingga 3 digit terakhir untuk verifikasi otomatis instan.',
  );
  bool _isProcessing = false;

  void _handleConfirmPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    // Update payment status to Lunas in store
    TripRentStore.instance.verifyPayment(widget.order.kodeOrders, 'Lunas');

    // Retrieve updated order
    final updatedOrder = TripRentStore.instance.orders.firstWhere(
      (o) => o.kodeOrders == widget.order.kodeOrders,
      orElse: () => widget.order.copyWith(paymentStatus: 'Lunas'),
    );

    setState(() => _isProcessing = false);
    Navigator.pop(context); // Close checkout sheet

    if (widget.onPaymentSuccess != null) {
      widget.onPaymentSuccess!();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran berhasil dikonfirmasi! E-Tiket Anda telah terbit.'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Otomatis tampilkan E-Tiket jika tiket shuttle / travel
    if (updatedOrder.isTicket) {
      showShuttleETicketModal(context, updatedOrder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppTheme.cardBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.payment_rounded, color: AppTheme.primaryLight, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Pilih Metode Pembayaran',
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.order.kodeOrders,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryLight,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.warning.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Menunggu Pembayaran',
                                style: TextStyle(
                                  color: AppTheme.warning,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.order.isTicket
                              ? (widget.order.ticketTitle ?? widget.order.car.nama)
                              : widget.order.car.nama,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.order.jemput} → ${widget.order.tujuan}',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                        const Divider(color: AppTheme.cardBorder, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Tagihan', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            Text(
                              Formatters.rupiah(widget.order.totalHarga),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Metode Pembayaran Tersedia',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 4 Payment Methods Selector
                  PaymentMethodSelector(
                    initialSelection: _currentSelection,
                    onSelectionChanged: (sel) {
                      setState(() => _currentSelection = sel);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: AppTheme.cardBorder)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Metode Dipilih:', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        Text(
                          _currentSelection.summary,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _handleConfirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Konfirmasi Bayar',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
