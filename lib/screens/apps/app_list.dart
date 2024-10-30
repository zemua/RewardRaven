import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:logger/logger.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/screens/apps/app_list_type.dart';

import '../../db/service/listed_app_service.dart';
import '../../service/app/apps_fetcher.dart';
import '../../service/platform_wrapper.dart';

final GetIt locator = GetIt.instance;

class AppList extends StatelessWidget {
  final AppListType listType;
  final String titleBarMessage;

  AppList({
    required this.listType,
    required this.titleBarMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appsFetcher = locator<AppsFetcher>();
    return Scaffold(
      appBar: AppBar(
        title: Text(titleBarMessage),
      ),
      body: FutureBuilder<List<AppInfo>>(
        // TODO maybe change to stream?
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
  final AppListType listType;

  const AppListItem({
    required this.app,
    required this.listType,
    super.key,
  });

  @override
  AppListItemState createState() => AppListItemState();
}

class AppListItemState extends State<AppListItem> {
  final PlatformWrapper _platformWrapper = locator<PlatformWrapper>();

  final _logger = Logger();
  bool _isSwitched = false;
  bool _isDisabled = false;
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
        _isDisabled = getDisabledApp(widget.listType).contains(status);
      });
    } on TimeoutException {
      _logger.w('Timeout while loading switch value');
    } catch (e) {
      _logger.e('Error loading switch value: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.memory(
        widget.app.icon!,
        errorBuilder: (context, error, stackTrace) {
          _logger.e(
              'Error loading image: $error - context: $context - stack trace: $stackTrace');
          return const Icon(Icons.apps);
        },
      ),
      title: Text(widget.app.name),
      trailing: Switch(
        value: _isSwitched,
        onChanged: _isDisabled
            ? null
            : (value) async {
                setState(() {
                  _isSwitched = value;
                });
                final status =
                    value ? getTargetApp(widget.listType) : AppStatus.unknown;
                final listedApp = ListedApp(
                  identifier: widget.app.packageName,
                  platform: _platformWrapper.platformName,
                  status: status,
                );
                await _service.saveListedApp(listedApp);
              },
      ),
    );
  }
}
