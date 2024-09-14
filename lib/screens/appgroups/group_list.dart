import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

class AppGroupList extends StatelessWidget {
  final String titleBarMessage;

  const AppGroupList({
    required this.titleBarMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Text('This is a new widget'),
    );
  }
}
