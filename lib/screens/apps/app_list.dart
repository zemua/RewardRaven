import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';

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
            return Center(child: CircularProgressIndicator());
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
                return AppListItem(app: apps[index]);
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

  const AppListItem({required this.app, Key? key}) : super(key: key);

  @override
  _AppListItemState createState() => _AppListItemState();
}

class _AppListItemState extends State<AppListItem> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.app.name),
      trailing: Switch(
        value: _isSwitched,
        onChanged: (value) {
          setState(() {
            _isSwitched = value;
          });
        },
      ),
    );
  }
}
