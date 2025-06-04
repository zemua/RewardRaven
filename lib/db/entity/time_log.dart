import 'package:equatable/equatable.dart';

class TimeLog extends Equatable {
  static final String _date_time_name = 'date_time';
  static final String _used_name = 'used';
  static final String _counted_name = 'counted';

  final DateTime dateTime;
  final Duration used;
  final Duration counted;

  TimeLog({required this.used, required this.counted, required this.dateTime});

  @override
  List<Object?> get props => [dateTime, used, counted];

  factory TimeLog.fromJson(Map<String, dynamic> json) {
    return TimeLog(
      dateTime: DateTime.parse(json[_date_time_name]),
      used: Duration(seconds: json[_used_name]),
      counted: Duration(seconds: json[_counted_name]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _date_time_name: dateTime.toIso8601String(),
      _used_name: used.inSeconds,
      _counted_name: counted.inSeconds
    };
  }
}
