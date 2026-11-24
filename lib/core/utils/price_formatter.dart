import 'package:intl/intl.dart';

class PriceFormatter {
  PriceFormatter._();

  static final NumberFormat _usdFormat = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _sypFormat = NumberFormat('#,##0', 'en_US');

  /// تنسيق السعر بالدولار الأمريكي: 12.50 $
  static String formatUsd(num amount) {
    return '${_usdFormat.format(amount)} \$';
  }

  /// تنسيق السعر بالليرة السورية: 165,000 ل.س
  static String formatSyp(num amount) {
    return '${_sypFormat.format(amount)} ل.س';
  }
}
