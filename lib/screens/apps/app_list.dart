import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';

import 'fetcher/apps_fetcher.dart';

final GetIt locator = GetIt.instance;

class AppList extends StatelessWidget {
  // TODO test
  const AppList({super.key});

  @override
  Widget build(BuildContext context) {
    final appsFetcher = locator<AppsFetcher>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Installed Apps'),
      ),
      body: FutureBuilder<List<AppInfo>>(
        future: appsFetcher.fetchInstalledApps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No apps found'));
          } else {
            final apps = snapshot.data!;
            for (var app in apps) {
              print(app.name);
            }
            return ListView.builder(
              itemCount: apps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(apps[index].name),
                );
              },
            );
          }
        },
      ),
    );
  }
}
