import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:logger/logger.dart';

import '../../../db/entity/app_group.dart';
import '../../../db/entity/listed_app.dart';
import '../../../db/service/listed_app_service.dart';
import '../../../service/app/apps_fetcher.dart';
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
            Center(child: _buildAppList(group, listType)),
            Center(
                child: Text(
                    'Random checks included in this group')), // TODO implement tab
            Center(child: Text('Options for this group')), // TODO implement tab
          ],
        ),
      ),
    );
  }
}

FutureBuilder<List<AppInfo>> _buildAppList(
    AppGroup group, AppListType listType) {
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
              final filteredApps = listedApps
                  .map((app) => apps
                      .where((listedApp) =>
                          listedApp.packageName == app.identifier)
                      .map((listedApp) => MapEntry(app, listedApp)))
                  .expand((pair) => pair)
                  .toList();
              return ListView.builder(
                itemCount: filteredApps.length,
                itemBuilder: (context, index) {
                  return GroupAppItem(
                      listedApp: filteredApps[index].key,
                      appInfo: filteredApps[index].value,
                      listId: group.id!);
                },
              );
            }
          },
        );
      }
    },
  );
}

class GroupAppItem extends StatefulWidget {
  final ListedApp listedApp;
  final AppInfo appInfo;
  final String listId;

  const GroupAppItem({
    required this.listedApp,
    required this.appInfo,
    required this.listId,
    super.key,
  });

  @override
  GroupAppItemState createState() => GroupAppItemState();
}

class GroupAppItemState extends State<GroupAppItem> {
  final Logger _logger = Logger();

  bool _isSwitched = false;
  bool _isDisabled = false;
  final ListedAppService _service = locator<ListedAppService>();

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  Future<void> _loadSwitchValue() async {
    setState(() {
      _isSwitched = widget.listId == widget.listedApp.listId;
      _isDisabled = widget.listedApp.listId != null &&
          widget.listedApp.listId != widget.listId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.memory(
        widget.appInfo.icon!,
        errorBuilder: (context, error, stackTrace) {
          _logger.e(
              'Error loading image: $error - context: $context - stack trace: $stackTrace');
          return const Icon(Icons.apps);
        },
      ),
      title: Text(widget.appInfo.name),
      trailing: Switch(
        value: _isSwitched,
        onChanged: _isDisabled
            ? null
            : (value) async {
                setState(() {
                  _isSwitched = value;
                });
                final listId = value ? widget.listId : null;
                final listedApp = widget.listedApp.copyWith(
                  listId: listId,
                );
                await _service.updateListedApp(listedApp);
              },
      ),
    );
  }
}
