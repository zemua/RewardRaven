import 'package:equatable/equatable.dart';

class ListedApp extends Equatable {
  String identifier;
  String platform;
  int listId;
  AppStatus status;

  ListedApp({
    required this.identifier,
    required this.platform,
    required this.listId,
    required this.status,
  });

  String get compositeKey =>
      '${identifier}_${platform}'; // _databaseReference.child('listedApps').child(app.compositeKey).set(app.toJson());

  @override
  List<Object?> get props => [identifier, platform, listId, status];

  factory ListedApp.fromJson(Map<String, dynamic> json) {
    return ListedApp(
      identifier: json['identifier'],
      platform: json['platform'],
      listId: json['listId'],
      status: AppStatus.values[json['status']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'platform': platform,
      'listId': listId,
      'status': status.index,
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
