import 'package:equatable/equatable.dart';

class ListedApp extends Equatable {
  String identifier;
  String platform;
  int listId;

  ListedApp({
    required this.identifier,
    required this.platform,
    required this.listId,
  });

  String get compositeKey =>
      '${identifier}_${platform}'; // _databaseReference.child('listedApps').child(app.compositeKey).set(app.toJson());

  @override
  List<Object?> get props => [identifier, platform, listId];

  factory ListedApp.fromJson(Map<String, dynamic> json) {
    return ListedApp(
      identifier: json['identifier'],
      platform: json['platform'],
      listId: json['listId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'platform': platform,
      'listId': listId,
    };
  }
}
