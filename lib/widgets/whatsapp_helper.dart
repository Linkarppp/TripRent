import 'package:url_launcher/url_launcher.dart';

/// Helper class for WhatsApp integration.
/// All WhatsApp contact goes to the TripRent customer service number.
class WhatsAppHelper {
  /// Nomor WhatsApp utama TripRent (Layanan Pelanggan & Sopir)
  static const String triprentWhatsApp = '6281286943954';

  /// Open WhatsApp chat with a pre-filled message
  static Future<void> openChat({String? message}) async {
    final encodedMessage = message != null ? Uri.encodeComponent(message) : '';
    final url = Uri.parse('https://wa.me/$triprentWhatsApp${encodedMessage.isNotEmpty ? '?text=$encodedMessage' : ''}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
        return;
      }
    } catch (_) {}
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  /// Direct phone call to TripRent customer service
  static Future<void> callPhone([String phone = '081286943954']) async {
    final url = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (_) {}
  }

  /// Open WhatsApp to contact a driver (routed through TripRent CS)
  static Future<void> contactDriver({required String driverName}) async {
    await openChat(
      message: 'Halo TripRent, saya ingin menghubungi sopir *$driverName*. Mohon bantu hubungkan. Terima kasih 🙏',
    );
  }

  /// Open WhatsApp for customer service / general inquiry
  static Future<void> contactCS() async {
    await openChat(
      message: 'Halo Admin TripRent, saya butuh bantuan terkait layanan rental mobil / tiket perjalanan. Terima kasih 🙏',
    );
  }

  /// Open WhatsApp for customer service / general inquiry
  static Future<void> openCustomerService(dynamic context, {String? message}) async {
    await openChat(
      message: message ?? 'Halo Admin TripRent, saya butuh bantuan terkait layanan rental mobil / tiket perjalanan. Terima kasih 🙏',
    );
  }

  /// Open WhatsApp for booking confirmation
  static Future<void> confirmBooking({
    required String orderCode,
    required String carName,
    required String customerName,
  }) async {
    await openChat(
      message: 'Halo TripRent, saya *$customerName* ingin mengonfirmasi pesanan sewa mobil:\n\n'
          '🚗 Mobil: *$carName*\n'
          '📋 Kode Order: *$orderCode*\n\n'
          'Mohon proses pesanan saya. Terima kasih 🙏',
    );
  }

  /// Open WhatsApp for ticket booking confirmation
  static Future<void> confirmTicket({
    required String ticketRoute,
    required String customerName,
    required int seatCount,
  }) async {
    await openChat(
      message: 'Halo TripRent, saya *$customerName* ingin mengonfirmasi tiket perjalanan:\n\n'
          '🎫 Rute: *$ticketRoute*\n'
          '💺 Jumlah Kursi: *$seatCount*\n\n'
          'Mohon proses tiket saya. Terima kasih 🙏',
    );
  }

  /// Open WhatsApp chat with a specific phone number and message
  static Future<void> openWhatsApp({required String phone, String? message}) async {
    // Normalize phone number: remove non-digits, ensure starts with country code
    String normalizedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (normalizedPhone.startsWith('0')) {
      normalizedPhone = '62${normalizedPhone.substring(1)}';
    }
    if (!normalizedPhone.startsWith('62')) {
      normalizedPhone = '62$normalizedPhone';
    }
    final encodedMessage = message != null ? Uri.encodeComponent(message) : '';
    final url = Uri.parse('https://wa.me/$normalizedPhone${encodedMessage.isNotEmpty ? '?text=$encodedMessage' : ''}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
        return;
      }
    } catch (_) {}
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  /// Open WhatsApp with direct phone call (via tel:)
  static Future<void> callCS() async {
    final url = Uri.parse('tel:081286943954');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
