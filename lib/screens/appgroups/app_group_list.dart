import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../db/entity/app_group.dart';
import '../../db/service/app_group_service.dart';
import 'addgroup/add_group.dart';
import 'app_group_list_type.dart';
import 'editgroup/edit_group.dart';

final GetIt locator = GetIt.instance;

// TODO verify system apps are listed
// TODO first fetch apps from db, then one-by-one from the system using id, instead of fetching all at once
class AppGroupList extends StatelessWidget {
  final String titleBarMessage;
  final AppGroupListType listType;

  const AppGroupList({
    required this.titleBarMessage,
    required this.listType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final groupService = locator<AppGroupService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(titleBarMessage),
      ),
      body: StreamBuilder<List<AppGroup>>(
        stream: groupService.streamGroups(listType.toGroupType()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (snapshot.error is TimeoutException) {
              return Center(
                  child: Text(
                      AppLocalizations.of(context)!.noElementsOrNetworkError));
            } else {
              return Center(
                  child: Text(
                      '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
            }
          } else {
            final groups = snapshot.data ?? [];
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(group.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditGroupScreen(
                              group: group, listType: listType.toAppListType()),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddGroupScreen(
                      groupType: listType.toGroupType(),
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
