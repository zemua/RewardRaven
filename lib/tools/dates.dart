import 'package:intl/intl.dart';

final DateFormat _dateFormat = new DateFormat("yyyy-MM-dd");

String toDateOnly(DateTime date) {
  return _dateFormat.format(date);
}
