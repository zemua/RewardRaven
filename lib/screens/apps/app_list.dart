import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:logger/logger.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/screens/apps/list_type.dart';

import '../../db/service/listed_app_service.dart';
import 'fetcher/apps_fetcher.dart';

final GetIt locator = GetIt.instance;

class AppList extends StatelessWidget {
  final ListType listType;

  const AppList({required this.listType, super.key});

  @override
  Widget build(BuildContext context) {
    final appsFetcher = locator<AppsFetcher>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.installedApps),
      ),
      body: FutureBuilder<List<AppInfo>>(
        future: appsFetcher.fetchInstalledApps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(AppLocalizations.of(context)!.noAppsFound));
          } else {
            final apps = snapshot.data!;
            return ListView.builder(
              itemCount: apps.length,
              itemBuilder: (context, index) {
                return AppListItem(app: apps[index], listType: listType);
              },
            );
          }
        },
      ),
    );
  }
}

class AppListItem extends StatefulWidget {
  final AppInfo app;
  final ListType listType;

  AppListItem({
    required this.app,
    required this.listType,
    super.key,
  });

  @override
  AppListItemState createState() => AppListItemState();
}

class AppListItemState extends State<AppListItem> {
  final _logger = Logger();
  bool _isSwitched = false;
  final ListedAppService _service = locator<ListedAppService>();

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  Future<void> _loadSwitchValue() async {
    try {
      final status = await _service.fetchStatus(widget.app.packageName);
      setState(() {
        _isSwitched = (status == getTargetApp(widget.listType));
      });
    } on TimeoutException {
      _logger.w('Timeout while loading switch value');
    } catch (e) {
      _logger.e('Error loading switch value: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO set disable when in another list
    return ListTile(
      title: Text(widget.app.name),
      trailing: Switch(
        value: _isSwitched,
        onChanged: (value) async {
          setState(() {
            _isSwitched = value;
          });
          final status =
              value ? getTargetApp(widget.listType) : AppStatus.UNKNOWN;
          await _service.saveStatus(widget.app.packageName, status);
        },
      ),
    );
  }
}
