import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../db/entity/app_group.dart';
import '../../../db/service/app_group_service.dart';

final GetIt locator = GetIt.instance;

class AddGroupScreen extends StatelessWidget {
  final TextEditingController _groupNameController;
  final AppGroupService appGroupService = locator<AppGroupService>();

  final GroupType groupType;

  final _logger = Logger();

  AddGroupScreen({super.key, required this.groupType})
      : _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Group'), // TODO use localization
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.groupName,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final groupName = _groupNameController.text;
                if (groupName.isNotEmpty) {
                  final newGroup = AppGroup(name: groupName, type: groupType);
                  _logger.i("Saving group: $newGroup");
                  appGroupService.saveGroup(newGroup);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.groupNameEmpty)),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.addGroup),
            ),
          ],
        ),
      ),
    );
  }
}
