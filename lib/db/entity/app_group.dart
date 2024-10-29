import 'package:equatable/equatable.dart';

class AppGroup extends Equatable {
  final String? id;
  final String name;
  final GroupType type;
  final bool? preventClose;

  const AppGroup({
    this.id,
    required this.name,
    required this.type,
    this.preventClose,
  });

  @override
  List<Object?> get props => [name, type, preventClose];

  factory AppGroup.fromJson(
      {required Map<String, dynamic> json, required String id}) {
    return AppGroup(
      name: json['name'],
      type: _parseAppGroupListType(json['type']),
      preventClose: json['preventClose'] ?? false,
      id: id,
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
      'id': id,
    };
  }
}

enum GroupType { positive, negative }
