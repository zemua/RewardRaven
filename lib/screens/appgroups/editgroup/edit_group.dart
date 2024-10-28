import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';

import '../../../db/entity/app_group.dart';
import '../../../db/entity/listed_app.dart';
import '../../../db/service/listed_app_service.dart';
import '../../../service/app/apps_fetcher.dart';
import '../../apps/app_list.dart';
import '../../apps/app_list_type.dart';

final GetIt locator = GetIt.instance;

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
              Tab(text: AppLocalizations.of(context)!.options),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: _buildAppList(listType)),
            Center(child: Text('Random checks included in this group')),
            Center(child: Text('Options for this group')),
          ],
        ),
      ),
    );
  }
}

FutureBuilder<List<AppInfo>> _buildAppList(AppListType listType) {
  final appsFetcher = locator<AppsFetcher>();
  final listedAppService = locator<ListedAppService>();
  return FutureBuilder<List<AppInfo>>(
    future: appsFetcher.fetchInstalledApps(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(
            child: Text(
                '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text(AppLocalizations.of(context)!.noAppsFound));
      } else {
        final apps = snapshot.data!;
        return FutureBuilder<List<ListedApp>>(
          future: listedAppService.fetchListedAppsByType(listType),
          builder: (context, dbSnapshot) {
            if (dbSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (dbSnapshot.hasError) {
              return Center(
                  child: Text(
                      '${AppLocalizations.of(context)!.error}: ${dbSnapshot.error}'));
            } else if (!dbSnapshot.hasData || dbSnapshot.data!.isEmpty) {
              return Center(
                  child: Text(AppLocalizations.of(context)!.noAppsFound));
            } else {
              final listedApps = dbSnapshot.data!;
              final filteredApps = apps
                  .where((app) => listedApps.any(
                      (listedApp) => listedApp.identifier == app.packageName))
                  .toList();
              return ListView.builder(
                itemCount: filteredApps.length,
                itemBuilder: (context, index) {
                  return AppListItem(
                      app: filteredApps[index], listType: listType);
                },
              );
            }
          },
        );
      }
    },
  );
}
