import 'package:equatable/equatable.dart';

class GroupCondition extends Equatable {
  late String? id;
  final String conditionedGroupId;
  final String conditionalGroupId;
  final Duration usedTime;
  final int duringLastDays;

  GroupCondition({
    this.id,
    required this.conditionedGroupId,
    required this.conditionalGroupId,
    required this.usedTime,
    required this.duringLastDays,
  });

  @override
  List<Object?> get props => [
        id,
        conditionedGroupId,
        conditionalGroupId,
        usedTime,
        duringLastDays,
      ];

  factory GroupCondition.fromJson({required Map<String, dynamic> json}) {
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
    String? id,
    String? conditionedGroupId,
    String? conditionalGroupId,
    Duration? usedTime,
    int? duringLastDays,
  }) {
    return GroupCondition(
      id: id ?? this.id,
      conditionedGroupId: conditionedGroupId ?? this.conditionedGroupId,
      conditionalGroupId: conditionalGroupId ?? this.conditionalGroupId,
      usedTime: usedTime ?? this.usedTime,
      duringLastDays: duringLastDays ?? this.duringLastDays,
    );
  }
}
