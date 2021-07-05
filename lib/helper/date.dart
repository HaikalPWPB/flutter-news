import 'package:intl/intl.dart';

class Date {
  static DateFormat formatter = DateFormat('yyyy-MM-dd');

  static formatDate(date){
    final DateTime parsed = parseDate(date);
    final String formatted = formatter.format(parsed);
    return formatted;
  }

  static parseDate(data){
    final DateTime parsed = formatter.parse(data);
    return parsed;
  }
}