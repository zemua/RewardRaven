import 'package:equatable/equatable.dart';

class ListedApp extends Equatable {
  String identifier;
  String platform;
  AppStatus status;
  int? listId;

  ListedApp({
    required this.identifier,
    required this.platform,
    required this.status,
    this.listId,
  });

  String get compositeKey =>
      '${identifier}_${platform}'; // _databaseReference.child('listedApps').child(app.compositeKey).set(app.toJson());

  @override
  List<Object?> get props => [identifier, platform, status, listId];

  factory ListedApp.fromJson(Map<String, dynamic> json) {
    return ListedApp(
      identifier: json['identifier'],
      platform: json['platform'],
      listId: json['listId'],
      status: json['status'] != null
          ? AppStatus.values
              .firstWhere((e) => e.toString().split('.').last == json['status'])
          : AppStatus.UNKNOWN,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'platform': platform,
      'listId': listId,
      'status': status != null
          ? status.toString().split('.').last
          : AppStatus.UNKNOWN.toString().split('.').last,
    };
  }
}

enum AppStatus {
  POSITIVE,
  NEGATIVE,
  NEUTRAL,
  DEPENDS,
  UNKNOWN,
}
