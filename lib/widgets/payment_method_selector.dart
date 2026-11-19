import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class PaymentSelection {
  final String category; // 'Transfer Bank' | 'E-Wallet' | 'Kartu Kredit/Debit' | 'QRIS'
  final String channel;  // 'BCA', 'GoPay', 'Visa', etc.
  final String accountNumber;
  final String accountHolder;
  final String instructions;

  const PaymentSelection({
    required this.category,
    required this.channel,
    required this.accountNumber,
    required this.accountHolder,
    required this.instructions,
  });

  String get summary => '$category ($channel)';
}

/// PaymentMethodSelector: Komponen pemilih 4 metode pembayaran utama TripRent
/// 1. Transfer Bank (BCA, BRI, BNI, Mandiri)
/// 2. E-Wallet (GoPay, OVO, DANA, ShopeePay)
/// 3. Kartu Kredit/Debit (Visa, Mastercard)
/// 4. QRIS (Semua Bank & E-Wallet)
class PaymentMethodSelector extends StatefulWidget {
  final PaymentSelection? initialSelection;
  final ValueChanged<PaymentSelection> onSelectionChanged;

  const PaymentMethodSelector({
    super.key,
    this.initialSelection,
    required this.onSelectionChanged,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late String _selectedCategory;
  late String _selectedChannel;

  final Map<String, List<Map<String, String>>> _channelsByCategory = {
    'Transfer Bank': [
      {'channel': 'BCA', 'number': '0320-9436-47', 'holder': 'PT TripRent Nusantara'},
      {'channel': 'BRI', 'number': '1034-01-002891-53-4', 'holder': 'PT TripRent Nusantara'},
      {'channel': 'BNI', 'number': '0819-2837-46', 'holder': 'PT TripRent Nusantara'},
      {'channel': 'Mandiri', 'number': '131-00-1928374-1', 'holder': 'PT TripRent Nusantara'},
    ],
    'E-Wallet': [
      {'channel': 'GoPay', 'number': '0812-8694-3954', 'holder': 'TripRent Pay'},
      {'channel': 'OVO', 'number': '0812-8694-3954', 'holder': 'TripRent Pay'},
      {'channel': 'DANA', 'number': '0812-8694-3954', 'holder': 'TripRent Pay'},
      {'channel': 'ShopeePay', 'number': '0812-8694-3954', 'holder': 'TripRent Pay'},
    ],
    'Kartu Kredit/Debit': [
      {'channel': 'Visa', 'number': '•••• •••• •••• 4242', 'holder': 'Visa Card 3D Secure'},
      {'channel': 'Mastercard', 'number': '•••• •••• •••• 5555', 'holder': 'Mastercard Identity Check'},
    ],
    'QRIS': [
      {'channel': 'QRIS Nasional', 'number': 'NMID: ID1020038491829', 'holder': 'TripRent Official Merchant'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialSelection?.category ?? 'Transfer Bank';
    _selectedChannel = widget.initialSelection?.channel ?? 'BCA';
  }

  void _notifySelection(String category, String channel) {
    setState(() {
      _selectedCategory = category;
      _selectedChannel = channel;
    });

    final channelList = _channelsByCategory[category] ?? [];
    final channelData = channelList.firstWhere(
      (c) => c['channel'] == channel,
      orElse: () => channelList.isNotEmpty
          ? channelList.first
          : {'channel': channel, 'number': '-', 'holder': 'TripRent'},
    );

    String instructions = '';
    if (category == 'Transfer Bank') {
      instructions = 'Transfer tepat hingga 3 digit terakhir untuk verifikasi otomatis instan.';
    } else if (category == 'E-Wallet') {
      instructions = 'Buka aplikasi $channel dan konfirmasi pembayaran dalam 15 menit.';
    } else if (category == 'Kartu Kredit/Debit') {
      instructions = 'Transaksi dilindungi enkripsi 256-bit dan OTP 3D-Secure.';
    } else {
      instructions = 'Pindai kode QRIS menggunakan mobile banking atau e-wallet apa saja.';
    }

    widget.onSelectionChanged(
      PaymentSelection(
        category: category,
        channel: channel,
        accountNumber: channelData['number'] ?? '-',
        accountHolder: channelData['holder'] ?? 'PT TripRent Nusantara',
        instructions: instructions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMethodCard(
          category: 'Transfer Bank',
          title: 'Transfer Bank',
          subtitle: 'BCA, BRI, BNI, Mandiri',
          icon: Icons.account_balance_rounded,
          badge: 'Verifikasi Otomatis',
        ),
        const SizedBox(height: 10),
        _buildMethodCard(
          category: 'E-Wallet',
          title: 'E-Wallet',
          subtitle: 'GoPay, OVO, DANA, ShopeePay',
          icon: Icons.account_balance_wallet_rounded,
          badge: 'Instan & Bebas Biaya',
        ),
        const SizedBox(height: 10),
        _buildMethodCard(
          category: 'Kartu Kredit/Debit',
          title: 'Kartu Kredit/Debit',
          subtitle: 'Visa, Mastercard',
          icon: Icons.credit_card_rounded,
          badge: '3D-Secure',
        ),
        const SizedBox(height: 10),
        _buildMethodCard(
          category: 'QRIS',
          title: 'QRIS',
          subtitle: 'Scan Semua Bank & Dompet Digital',
          icon: Icons.qr_code_scanner_rounded,
          badge: 'Paling Praktis',
        ),
      ],
    );
  }

  Widget _buildMethodCard({
    required String category,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
  }) {
    final isSelected = _selectedCategory == category;
    final channels = _channelsByCategory[category] ?? [];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : AppTheme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? AppTheme.primaryLight : AppTheme.cardBorder,
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.primaryLight.withValues(alpha: 0.14),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // Header Card with Radio Button
          InkWell(
            onTap: () {
              final defaultChannel = channels.isNotEmpty ? channels.first['channel']! : '';
              _notifySelection(category, defaultChannel);
            },
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Radio Button
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryLight : AppTheme.textMuted,
                        width: isSelected ? 6 : 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isSelected ? AppTheme.primaryLight : AppTheme.surfaceLight).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? AppTheme.primaryLight : AppTheme.textSecondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppTheme.textPrimary : AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    isSelected ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: isSelected ? AppTheme.primaryLight : AppTheme.textMuted,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Channel Options (when selected)
          if (isSelected) ...[
            const Divider(height: 1, indent: 16, endIndent: 16, color: AppTheme.cardBorder),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: _buildCategoryDetails(category, channels),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryDetails(String category, List<Map<String, String>> channels) {
    if (category == 'Transfer Bank' || category == 'E-Wallet') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category == 'Transfer Bank' ? 'Pilih Bank Tujuan:' : 'Pilih Dompet Digital:',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: channels.map((item) {
              final isChannelSel = _selectedChannel == item['channel'];
              return ChoiceChip(
                label: Text(
                  item['channel']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isChannelSel ? FontWeight.bold : FontWeight.w500,
                    color: isChannelSel ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
                selected: isChannelSel,
                onSelected: (_) => _notifySelection(category, item['channel']!),
                selectedColor: AppTheme.primary,
                backgroundColor: AppTheme.surfaceLight,
                side: BorderSide(
                  color: isChannelSel ? AppTheme.primary : AppTheme.cardBorder,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Current active account card with copy button
          Builder(
            builder: (ctx) {
              final active = channels.firstWhere(
                (c) => c['channel'] == _selectedChannel,
                orElse: () => channels.first,
              );
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category == 'Transfer Bank' ? 'Nomor Rekening ${active['channel']}' : 'Nomor Akun ${active['channel']}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            active['number']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryLight,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'a/n ${active['holder']}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 18, color: AppTheme.primaryLight),
                      tooltip: 'Salin Nomor',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: active['number']!.replaceAll('-', '')));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Nomor ${active['channel']} ${active['number']} berhasil disalin!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    } else if (category == 'Kartu Kredit/Debit') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: channels.map((item) {
              final isChannelSel = _selectedChannel == item['channel'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    item['channel']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isChannelSel ? FontWeight.bold : FontWeight.w500,
                      color: isChannelSel ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  selected: isChannelSel,
                  onSelected: (_) => _notifySelection(category, item['channel']!),
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.surfaceLight,
                  side: BorderSide(
                    color: isChannelSel ? AppTheme.primary : AppTheme.cardBorder,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: 20, color: AppTheme.success),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pembayaran aman dengan 3D Secure OTP & proteksi enkripsi bank berstandar PCI-DSS.',
                    style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // QRIS
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: const Row(
          children: [
            Icon(Icons.qr_code_2_rounded, size: 36, color: AppTheme.primaryLight),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QRIS Standar Pembayaran Nasional',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Dapat dipindai dari BCA Mobile, Livin\' Mandiri, BRImo, GoPay, OVO, DANA, ShopeePay & aplikasi lainnya.',
                    style: TextStyle(fontSize: 11, color: AppTheme.textMuted, height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
