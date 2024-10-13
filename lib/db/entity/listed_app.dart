import 'package:equatable/equatable.dart';

class ListedApp extends Equatable {
  final String identifier;
  final String platform;
  final AppStatus status;
  final int? listId;

  const ListedApp({
    required this.identifier,
    required this.platform,
    required this.status,
    this.listId,
  });

  @override
  List<Object?> get props => [identifier, platform, status, listId];

  factory ListedApp.fromJson(Map<String, dynamic> json) {
    return ListedApp(
      identifier: json['identifier'],
      platform: json['platform'],
      listId: json['listId'],
      status: _parseAppStatus(json['status']),
    );
  }

  static AppStatus _parseAppStatus(String? statusJson) {
    if (statusJson == null) {
      return AppStatus.unknown;
    }
    final statusString = statusJson.toString().split('.').last;
    return AppStatus.values.firstWhere(
      (e) => e.toString().split('.').last == statusString,
      orElse: () => AppStatus.unknown,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'platform': platform,
      'listId': listId,
      'status': _formatStatus(status),
    };
  }

  static String _formatStatus(AppStatus? status) {
    return status != null
        ? status.toString().split('.').last
        : AppStatus.unknown.toString().split('.').last;
  }
}

enum AppStatus {
  positive,
  negative,
  neutral,
  depends,
  unknown,
}
