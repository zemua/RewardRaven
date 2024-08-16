import 'package:equatable/equatable.dart';

class ListedApp extends Equatable {
  String identifier;
  String platform;
  String list;

  ListedApp({
    required this.identifier,
    required this.platform,
    required this.list,
  });

  String get compositeKey =>
      '${identifier}_${platform}'; // _databaseReference.child('listedApps').child(app.compositeKey).set(app.toJson());

  @override
  List<Object?> get props => [identifier, platform, list];

  factory ListedApp.fromJson(Map<String, dynamic> json) {
    return ListedApp(
      identifier: json['identifier'],
      platform: json['platform'],
      list: json['list'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'platform': platform,
      'list': list,
    };
  }
}
