import 'package:equatable/equatable.dart';

class GroupCondition extends Equatable {
  final String conditionedGroupId;
  final String conditionalGroupId;
  final Duration usedTime;
  final int duringLastDays;

  const GroupCondition({
    required this.conditionedGroupId,
    required this.conditionalGroupId,
    required this.usedTime,
    required this.duringLastDays,
  });

  @override
  List<Object?> get props => [
        conditionedGroupId,
        conditionalGroupId,
        usedTime,
        duringLastDays,
      ];

  factory GroupCondition.fromJson(Map<String, dynamic> json) {
    return GroupCondition(
      conditionedGroupId: json['conditionedGroupId'],
      conditionalGroupId: json['conditionalGroupId'],
      usedTime: Duration(milliseconds: json['usedTime']),
      duringLastDays: json['duringLastDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conditionedGroupId': conditionedGroupId,
      'conditionalGroupId': conditionalGroupId,
      'usedTime': usedTime.inMilliseconds,
      'duringLastDays': duringLastDays,
    };
  }

  GroupCondition copyWith({
    String? conditionedGroupId,
    String? conditionalGroupId,
    Duration? usedTime,
    int? duringLastDays,
  }) {
    return GroupCondition(
      conditionedGroupId: conditionedGroupId ?? this.conditionedGroupId,
      conditionalGroupId: conditionalGroupId ?? this.conditionalGroupId,
      usedTime: usedTime ?? this.usedTime,
      duringLastDays: duringLastDays ?? this.duringLastDays,
    );
  }
}
