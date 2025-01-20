import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../db/entity/app_group.dart';

final GetIt locator = GetIt.instance;

class EditCondition extends StatelessWidget {
  final _logger = Logger();
  final AppGroup conditionedGroup;

  EditCondition({
    super.key,
    required this.conditionedGroup,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Condition'), // TODO use localization
      ),
      body: ListView(
        // TODO implement fields to be shown in this screen
        children: [
          ListTile(
            title: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Condition',
              ),
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Condition',
              ),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
