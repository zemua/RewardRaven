import 'package:flutter/material.dart';

import '../../../db/entity/app_group.dart';

class EditGroupScreen extends StatelessWidget {
  final AppGroup group;

  const EditGroupScreen({required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Group: ${group.name}'),
      ),
      body: Center(
        child: Text('Edit details for ${group.name}'),
      ),
    );
  }
}
