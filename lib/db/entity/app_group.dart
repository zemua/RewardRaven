import 'package:equatable/equatable.dart';

class AppGroup extends Equatable {
  String name;
  GroupType type;
  bool preventClose;

  AppGroup({
    required this.name,
    required this.type,
    required this.preventClose,
  }) : assert(type != null, 'type cannot be null');

  @override
  List<Object?> get props => [name, type, preventClose];

  factory AppGroup.fromJson(Map<String, dynamic> json) {
    return AppGroup(
      name: json['name'],
      type: _parseAppGroupListType(json['type']),
      preventClose: json['preventClose'],
    );
  }

  static GroupType _parseAppGroupListType(String? type) {
    return GroupType.values.firstWhere(
      (e) => e.toString().split('.').last == type,
      orElse: () => throw Exception('Invalid AppGroupListType: $type'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toString().split('.').last,
      'preventClose': preventClose,
    };
  }
}

enum GroupType { positive, negative }
