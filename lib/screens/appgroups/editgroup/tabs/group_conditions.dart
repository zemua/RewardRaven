import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../db/entity/app_group.dart';
import '../../../../db/entity/group_condition.dart';
import '../../../../db/service/app_group_service.dart';
import '../../../../db/service/group_condition_service.dart';
import '../../../../error/group_not_found_exception.dart';
import '../../../../tools/injectable_time_picker.dart';
import '../../../apps/app_list_type.dart';
import 'condition/edit_condition.dart';

final GetIt locator = GetIt.instance;

final _logger = Logger();

Builder buildConditionsList(AppGroup group, AppListType listType) {
  return Builder(
    builder: (context) {
      return _buildConditionsList(group, listType);
    },
  );
}

StreamBuilder<List<GroupConditionItem>> _buildConditionsList(
    AppGroup group, AppListType listType) {
  return StreamBuilder<List<GroupConditionItem>>(
    stream: _fetchSavedConditions(listType, group),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        _logger.e('Error loading conditions: ${snapshot.error}');
        return Center(
            child: Text(
                '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.noConditionsFound),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addCondition(context, group);
              },
              child: Text(AppLocalizations.of(context)!.addCondition),
            ),
          ],
        );
      } else {
        final groupApps = snapshot.data!;
        const buttonSpace = 1;
        return ListView.builder(
          itemCount: groupApps.length + buttonSpace,
          itemBuilder: (context, index) {
            if (index < groupApps.length) {
              return groupApps[index];
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: ElevatedButton(
                  onPressed: () {
                    addCondition(context, group);
                  },
                  child: Text(AppLocalizations.of(context)!.addCondition),
                ),
              );
            }
          },
        );
      }
    },
  );
}

void addCondition(BuildContext context, AppGroup group) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditCondition(
        conditionedGroup: group,
      ),
    ),
  );
}

Stream<List<GroupConditionItem>> _fetchSavedConditions(
    AppListType listType, AppGroup group) {
  if (group.id == null) {
    return const Stream.empty();
  }

  final groupConditionService = locator<GroupConditionService>();

  final conditions = groupConditionService.streamGroupConditions(group.id!);
  return conditions
      .asyncMap((cdts) => mapConditionList(cdts, listType, group))
      .expand((items) => [items]);
}

Future<List<GroupConditionItem>> mapConditionList(
    List<GroupCondition> conditions,
    AppListType listType,
    AppGroup conditionedGroup) async {
  List<GroupConditionItem> items = [];
  await Future.wait(conditions.map((condition) async {
    try {
      items.add(await mapCondition(listType, condition, conditionedGroup));
    } on GroupNotFoundException catch (e) {
      _logger.e('Error loading group conditions: $e');
    }
  }));
  return items;
}

Future<GroupConditionItem> mapCondition(AppListType listType,
    GroupCondition condition, AppGroup conditionedGroup) async {
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
    conditionedGroup: conditionedGroup,
    conditionEntity: condition,
  );
}

Future<String> getGroupName(AppListType listType, String groupId) async {
  final groupService = locator<AppGroupService>();
  AppGroup? group = await groupService.getGroup(listType.groupType, groupId);
  if (group == null) {
    throw GroupNotFoundException('Group with id $groupId not found');
  }
  return group.name;
}

class GroupConditionItem extends StatefulWidget {
  final AppGroup conditionedGroup;
  final String conditionedGroupId;
  final String conditionedGroupName;
  final String conditionalGroupId;
  final String conditionalGroupName;
  final Duration usedTime;
  final int duringLastDays;
  final GroupCondition conditionEntity;

  const GroupConditionItem({
    required this.conditionedGroupId,
    required this.conditionedGroupName,
    required this.conditionalGroupId,
    required this.conditionalGroupName,
    required this.usedTime,
    required this.duringLastDays,
    super.key,
    required this.conditionedGroup,
    required this.conditionEntity,
  });

  @override
  GroupAppItemState createState() => GroupAppItemState();
}

class GroupAppItemState extends State<GroupConditionItem> {
  final Logger _logger = Logger();

  Future<bool> _areConditionsMet() async {
    // TODO check if conditions are met and set color of the button to green/red according to theme
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    _logger.d(
        'Building app item for ${widget.conditionalGroupName} for ${widget.usedTime.inHours}:${widget.usedTime.inMinutes} in the last ${widget.duringLastDays} days');
    _logger.d(
        '${widget.conditionalGroupName} ${AppLocalizations.of(context)!.forString} ${widget.usedTime.inHours}:${widget.usedTime.inMinutes} ${AppLocalizations.of(context)!.inTheLast} ${widget.duringLastDays} ${AppLocalizations.of(context)!.days}');
    return FutureBuilder<bool>(
      future: _areConditionsMet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          bool conditionsMet = snapshot.data ?? false;
          return ListTile(
            title: OutlinedButton(
              onPressed: () {
                updateCondition(
                    context, widget.conditionedGroup, widget.conditionEntity);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: conditionsMet
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ),
              child: Text(
                // TODO de-duplicate code transforming Duration to String
                '${widget.conditionalGroupName} ${AppLocalizations.of(context)!.forString} ${durationToDigitalClock(widget.usedTime)} ${AppLocalizations.of(context)!.inTheLast} ${widget.duringLastDays} ${AppLocalizations.of(context)!.days}',
                style: TextStyle(
                  color: conditionsMet
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void updateCondition(
      BuildContext context, AppGroup group, GroupCondition condition) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCondition(
          conditionedGroup: group,
          condition: condition,
        ),
      ),
    );
  }
}
