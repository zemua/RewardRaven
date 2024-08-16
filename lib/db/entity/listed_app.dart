import 'package:equatable/equatable.dart';

class ListedApp extends Equatable {
  int? id;
  String identifier;
  String platform;
  String list;

  ListedApp({
    this.id,
    required this.identifier,
    required this.platform,
    required this.list,
  });

  String get compositeKey =>
      '${identifier}_${platform}'; // _databaseReference.child('listedApps').child(app.compositeKey).set(app.toJson());

  @override
  List<Object?> get props => [id, identifier, platform, list];

  factory ListedApp.fromJson(Map<String, dynamic> json) {
    return ListedApp(
      id: json['id'],
      identifier: json['identifier'],
      platform: json['platform'],
      list: json['list'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identifier': identifier,
      'platform': platform,
      'list': list,
    };
  }
}
