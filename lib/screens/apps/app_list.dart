import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:reward_raven/db/entity/listed_app.dart';

import '../../db/service/listed_app_service.dart';
import 'fetcher/apps_fetcher.dart';

final GetIt locator = GetIt.instance;

class AppList extends StatelessWidget {
  const AppList({super.key});

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
                return AppListItem(
                    app: apps[index],
                    targetStatus: AppStatus
                        .POSITIVE); // TODO receive the type POSITIVE/NEGATIVE from the button call
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
  final AppStatus
      targetStatus; // TODO make a new enum ListType { POSITIVE, NEGATIVE } that contains both target and disabled status
  final AppStatus disabledStatus;

  AppListItem({
    required this.app,
    required this.targetStatus,
    super.key,
  }) : disabledStatus = _calculateDisabledStatus(targetStatus);

  static AppStatus _calculateDisabledStatus(AppStatus targetStatus) {
    if (targetStatus == AppStatus.POSITIVE) {
      return AppStatus.NEGATIVE;
    } else if (targetStatus == AppStatus.NEGATIVE) {
      return AppStatus.POSITIVE;
    } else {
      throw ArgumentError('Invalid targetStatus');
    }
  }

  @override
  AppListItemState createState() => AppListItemState();
}

class AppListItemState extends State<AppListItem> {
  bool _isSwitched = false;
  final ListedAppService _service = locator<ListedAppService>();

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  Future<void> _loadSwitchValue() async {
    final status = await _service.fetchStatus(widget.app.packageName);
    setState(() {
      _isSwitched = (status == widget.targetStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.app.name),
      trailing: Switch(
        value: _isSwitched,
        onChanged: (value) async {
          setState(() {
            _isSwitched = value;
          });
          final status = value ? widget.targetStatus : AppStatus.NEUTRAL;
          await _service.saveStatus(widget.app.packageName, status);
        },
      ),
    );
  }
}
