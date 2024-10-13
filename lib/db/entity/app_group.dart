import 'package:equatable/equatable.dart';

class AppGroup extends Equatable {
  final String name;
  final GroupType type;
  final bool? preventClose;

  const AppGroup({
    required this.name,
    required this.type,
    this.preventClose,
  });

  @override
  List<Object?> get props => [name, type, preventClose];

  factory AppGroup.fromJson(Map<String, dynamic> json) {
    return AppGroup(
      name: json['name'],
      type: _parseAppGroupListType(json['type']),
      preventClose: json['preventClose'] ?? false,
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
      'preventClose': preventClose ?? false,
    };
  }
}

enum GroupType { positive, negative }
