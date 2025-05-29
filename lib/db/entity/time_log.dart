import 'package:equatable/equatable.dart';

class TimeLog extends Equatable {
  final DateTime dateTime;
  final Duration duration;

  TimeLog({required this.duration, required this.dateTime});

  @override
  List<Object?> get props => [dateTime, duration];

  factory TimeLog.fromJson(Map<String, dynamic> json) {
    return TimeLog(
      dateTime: DateTime.parse(json['date_time']),
      duration: Duration(seconds: json['duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_time': dateTime.toIso8601String(),
      'duration': duration.inSeconds,
    };
  }
}
