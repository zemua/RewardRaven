import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reward_raven/screens/appgroups/editgroup/tabs/group_app_list.dart';
import 'package:reward_raven/screens/appgroups/editgroup/tabs/group_conditions.dart';

import '../../../db/entity/app_group.dart';
import '../../apps/app_list_type.dart';

class EditGroupScreen extends StatelessWidget {
  final AppListType listType;
  final AppGroup group;

  const EditGroupScreen(
      {required this.group, required this.listType, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("${AppLocalizations.of(context)!.editGroup}: ${group.name}"),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.apps),
              Tab(text: AppLocalizations.of(context)!.randomChecks),
              Tab(text: AppLocalizations.of(context)!.conditions),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: buildAppList(group, listType)),
            Center(
                child: Text(
                    'Random checks included in this group')), // TODO implement tab
            Center(
                child:
                    buildConditionsList(group, listType)), // TODO implement tab
          ],
        ),
      ),
    );
  }
}
