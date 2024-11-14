import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:logger/logger.dart';

import '../../../../db/entity/app_group.dart';
import '../../../../db/entity/listed_app.dart';
import '../../../../db/service/listed_app_service.dart';
import '../../../../service/app/apps_fetcher.dart';
import '../../../apps/app_list_type.dart';

final GetIt locator = GetIt.instance;

FutureBuilder<List<GroupAppItem>> buildAppList(
    AppGroup group, AppListType listType) {
  return FutureBuilder<List<GroupAppItem>>(
    future: _fetchSavedApps(listType, group),
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
        final groupApps = snapshot.data!;
        return ListView.builder(
          itemCount: groupApps.length,
          itemBuilder: (context, index) {
            return GroupAppItem(
                listedApp: groupApps[index].listedApp,
                appInfo: groupApps[index].appInfo,
                listId: group.id!);
          },
        );
      }
    },
  );
}

Future<List<GroupAppItem>> _fetchSavedApps(
    AppListType listType, AppGroup group) async {
  final listedAppService = locator<ListedAppService>();
  final appsFetcher = locator<AppsFetcher>();

  List<ListedApp> listedApps =
      await listedAppService.fetchListedAppsByType(listType);

  return (await Future.wait(listedApps.map((app) async {
    final appInfo = await appsFetcher.fetchApp(app.identifier);
    if (appInfo != null) {
      return MapEntry(app, appInfo);
    }
    return null;
  })))
      .where((entry) => entry != null)
      .map((entry) => GroupAppItem(
            listedApp: entry!.key,
            appInfo: entry.value,
            listId: group.id!,
          ))
      .toList();
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
    _logger.d('Building app item for ${widget.appInfo.name} with icon: '
        '${widget.appInfo.icon}');
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
