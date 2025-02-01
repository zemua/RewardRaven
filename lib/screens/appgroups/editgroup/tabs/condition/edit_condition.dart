import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../db/entity/app_group.dart';
import '../../../../../db/entity/group_condition.dart';
import '../../../../../db/service/app_group_service.dart';
import '../../../../../db/service/group_condition_service.dart';

final GetIt locator = GetIt.instance;

class EditCondition extends StatelessWidget {
  // TODO stateful widget?
  final _logger = Logger();
  final groupConditionService = locator<GroupConditionService>();
  final groupService = locator<AppGroupService>();
  final AppGroup conditionedGroup;
  final GroupCondition? condition;

  EditCondition({
    super.key,
    required this.conditionedGroup,
    this.condition,
  });

  @override
  Widget build(BuildContext context) {
    String? conditionalGroupId = condition?.conditionalGroupId;
    Duration usedTime = condition?.usedTime ?? const Duration(minutes: 15);
    int duringLastDays = condition?.duringLastDays ?? 0;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(condition == null
            ? AppLocalizations.of(context)!.addCondition
            : AppLocalizations.of(context)!.editCondition),
      ),
      body: ListView(
        // TODO implement fields to be shown in this screen
        children: [
          ListTile(
            title: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.conditionalGroup,
              ),
              value: conditionalGroupId,
              onChanged: (String? newValue) {
                conditionalGroupId = newValue!;
              },
              items: <String>[
                'usedTime',
                'duringLastDays',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
