import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../../db/entity/app_group.dart';

final GetIt locator = GetIt.instance;

class AddGroupScreen extends StatelessWidget {
  final GroupType groupType;

  const AddGroupScreen({super.key, required this.groupType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.groupName,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement group addition logic
              },
              child: Text(AppLocalizations.of(context)!.addGroup),
            ),
          ],
        ),
      ),
    );
  }
}
