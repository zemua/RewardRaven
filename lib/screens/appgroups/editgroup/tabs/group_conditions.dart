import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../db/entity/app_group.dart';
import '../../../../db/entity/group_condition.dart';
import '../../../../db/service/app_group_service.dart';
import '../../../../db/service/group_condition_service.dart';
import '../../../apps/app_list_type.dart';

final GetIt locator = GetIt.instance;

final _logger = Logger();

FutureBuilder<List<GroupConditionItem>> buildConditionsList(
    AppGroup group, AppListType listType) {
  return FutureBuilder<List<GroupConditionItem>>(
    future: _fetchSavedConditions(listType, group),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        _logger.e('Error loading apps: ${snapshot.error}');
        return Center(
            child: Text(
                '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(
            child: Text(AppLocalizations.of(context)!.noConditionsFound));
      } else {
        final groupApps = snapshot.data!;
        return ListView.builder(
          itemCount: groupApps.length,
          itemBuilder: (context, index) {
            return groupApps[index];
          },
        );
      }
    },
  );
}

Future<List<GroupConditionItem>> _fetchSavedConditions(
    AppListType listType, AppGroup group) async {
  if (group.id == null) {
    return [];
  }

  final groupConditionService = locator<GroupConditionService>();

  final conditions = await groupConditionService.getGroupConditions(group.id!);
  return (await mapConditionList(conditions, listType)).toList();
}

Future<Iterable<GroupConditionItem>> mapConditionList(
    List<GroupCondition> conditions, AppListType listType) async {
  return await Future.wait(conditions.map((condition) async {
    return await mapCondition(listType, condition);
  }));
}

Future<GroupConditionItem> mapCondition(
    AppListType listType, GroupCondition condition) async {
  var conditionedName =
      await getGroupName(listType, condition.conditionedGroupId);
  var conditionalName =
      await getGroupName(listType, condition.conditionalGroupId);
  return GroupConditionItem(
    conditionedGroupId: condition.conditionedGroupId,
    conditionedGroupName: conditionedName,
    conditionalGroupId: condition.conditionalGroupId,
    conditionalGroupName: conditionalName,
    usedTime: condition.usedTime,
    duringLastDays: condition.duringLastDays,
  );
}

Future<String> getGroupName(AppListType listType, String groupId) async {
  final groupService = locator<AppGroupService>();
  AppGroup? group = await groupService.getGroup(listType.groupType, groupId);
  return group?.name ?? '';
}

class GroupConditionItem extends StatefulWidget {
  final String conditionedGroupId;
  final String conditionedGroupName;
  final String conditionalGroupId;
  final String conditionalGroupName;
  final Duration usedTime;
  final int duringLastDays;

  const GroupConditionItem({
    required this.conditionedGroupId,
    required this.conditionedGroupName,
    required this.conditionalGroupId,
    required this.conditionalGroupName,
    required this.usedTime,
    required this.duringLastDays,
    super.key,
  });

  @override
  GroupAppItemState createState() => GroupAppItemState();
}

class GroupAppItemState extends State<GroupConditionItem> {
  final Logger _logger = Logger();

  late bool _areConditionsMet;

  @override
  void initState() {
    super.initState();
    _configureState();
  }

  Future<void> _configureState() async {
    setState(() {
      // TODO check if conditions are met and set color of the button to green/red according to theme
      _areConditionsMet = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.d(
        'Building app item for ${widget.conditionalGroupName} for ${widget.usedTime.inHours} hours in the last ${widget.duringLastDays} days');
    return ListTile(
      trailing: ElevatedButton(
        onPressed: () {}, // TODO open screen to edit condition
        child: Text(
          '${widget.conditionalGroupName} for ${widget.usedTime.inHours} hours in the last ${widget.duringLastDays} days',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _areConditionsMet
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
