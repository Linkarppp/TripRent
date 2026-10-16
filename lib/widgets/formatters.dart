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

  static String date(DateTime date) {
    try {
      return _dateFormat.format(date);
    } catch (_) {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  static String dateShort(DateTime date) {
    return _dateShortFormat.format(date);
  }
}
