import 'package:equatable/equatable.dart';

class TimeLog extends Equatable {
  final DateTime dateTime;
  final Duration used;
  final Duration counted;

  TimeLog({required this.used, required this.counted, required this.dateTime});

  @override
  List<Object?> get props => [dateTime, used, counted];

  factory TimeLog.fromJson(Map<String, dynamic> json) {
    return TimeLog(
      dateTime: DateTime.parse(json['date_time']),
      used: Duration(seconds: json['used']),
      counted: Duration(seconds: json['counted']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_time': dateTime.toIso8601String(),
      'used': used.inSeconds,
      'counted': counted.inSeconds
    };
  }
}
