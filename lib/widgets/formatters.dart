import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
  static final DateFormat _dateShortFormat = DateFormat('dd/MM/yyyy');

  static String rupiah(num amount) {
    return _currencyFormat.format(amount);
  }

  static String date(DateTime dt) {
    try {
      return _dateFormat.format(dt);
    } catch (_) {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  static String dateShort(DateTime dt) {
    return _dateShortFormat.format(dt);
  }

  static String dateMedium(DateTime dt) {
    return date(dt);
  }
}
