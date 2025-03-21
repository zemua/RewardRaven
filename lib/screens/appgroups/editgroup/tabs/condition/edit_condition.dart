import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../db/entity/app_group.dart';
import '../../../../../db/entity/group_condition.dart';
import '../../../../../db/service/app_group_service.dart';
import '../../../../../db/service/group_condition_service.dart';
import '../../../../../tools/injectable_time_picker.dart';

final GetIt locator = GetIt.instance;

class EditCondition extends StatefulWidget {
  final _logger = Logger();
  final groupConditionService = locator<GroupConditionService>();
  final groupService = locator<AppGroupService>();
  final AppGroup conditionedGroup;
  final GroupCondition? condition;

  EditCondition({
    super.key,
    required this.conditionedGroup,
    this.condition,
  });

  @override
  EditConditionState createState() => EditConditionState();
}

class EditConditionState extends State<EditCondition> {
  final _timeController = TextEditingController();
  final _daysController = TextEditingController();
  final timePicker = locator<InjectableTimePicker>();

  late Map<String, AppGroup> groupsMap;

  String? _selectedConditionalGroupId;
  int? _selectedDays;
  Duration? _selectedTime;

  Future<void> _pickTime() async {
    TimeOfDay? initialTime;
    if (_selectedTime != null) {
      initialTime = toTimeOfDay(_selectedTime!);
    } else {
      initialTime = const TimeOfDay(hour: 0, minute: 15); // Default time
    }

    final TimeOfDay? newTime = await timePicker.showPicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      _selectedTime = Duration(hours: newTime.hour, minutes: newTime.minute);
      setState(() {
        _timeController.text = timeToDigitalClock(newTime);
      });
    }
  }

  void _onDaysChanged(String value) {
    _selectedDays = int.tryParse(value) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    String? conditionalGroupId = widget.condition?.conditionalGroupId;
    Duration usedTime =
        widget.condition?.usedTime ?? const Duration(minutes: 15);
    int duringLastDays = widget.condition?.duringLastDays ?? 0;
    final formKey = GlobalKey<FormState>();

    if (_selectedTime == null && widget.condition?.usedTime != null) {
      _selectedTime = widget.condition!.usedTime;
      _timeController.text = durationToDigitalClock(usedTime);
    }

    if (_selectedDays == null && widget.condition?.duringLastDays != null) {
      _selectedDays = widget.condition!.duringLastDays;
      _daysController.text = duringLastDays.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.condition == null
            ? AppLocalizations.of(context)!.addCondition
            : AppLocalizations.of(context)!.editCondition),
      ),
      body: FutureBuilder(
        future: _fetchPositiveGroups(widget.conditionedGroup),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            widget._logger.e('Error loading conditions: ${snapshot.error}');
            return Center(
                child: Text(
                    '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child:
                      Text(AppLocalizations.of(context)!.noPositiveGroupsFound),
                ),
              ],
            );
          } else {
            groupsMap = snapshot.data!
                .asMap()
                .map((index, group) => MapEntry(group.id!, group));
            return Form(
                key: formKey,
                child: ListView(
                  children: [
                    _buildConditionalGroupDropdown(context, groupsMap),
                    _buildUsedTimeField(context),
                    _buildDaysField(context),
                    const SizedBox(height: 40),
                    _buildSaveButton(formKey, context),
                  ],
                ));
          }
        },
      ),
    );
  }

  ListTile _buildConditionalGroupDropdown(
      BuildContext context, Map<String, AppGroup> groups) {
    if (_selectedConditionalGroupId == null &&
        widget.condition?.conditionalGroupId != null) {
      _selectedConditionalGroupId = widget.condition!.conditionalGroupId;
    }
    return ListTile(
      title: DropdownButtonFormField<String>(
        key: const Key("conditionalGroupDropdown"),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.conditionalGroup,
        ),
        value: _selectedConditionalGroupId,
        onChanged: (String? newValue) {
          _selectedConditionalGroupId = newValue;
        },
        items: groups.keys.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(groups[value]!.name),
          );
        }).toList(),
        validator: (value) {
          // Add your validation logic here
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    );
  }

  ListTile _buildUsedTimeField(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Baseline(
            baseline: 30,
            baselineType: TextBaseline.alphabetic,
            child: Text(AppLocalizations.of(context)!.hasUsed),
          ),
          IntrinsicWidth(
            child: Baseline(
              baseline: 40,
              baselineType: TextBaseline.alphabetic,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 60),
                  child: TextFormField(
                    key: const Key("timeField"),
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.hhmm,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      border: const OutlineInputBorder(),
                    ),
                    readOnly: true,
                    textAlign: TextAlign.center,
                    onTap: _pickTime,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '00:00') {
                        return '';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildDaysField(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(AppLocalizations.of(context)!.inTheLast),
          IntrinsicWidth(
            child: Baseline(
              baseline: 30,
              baselineType: TextBaseline.alphabetic,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 60),
                  child: TextFormField(
                    key: const Key("daysField"),
                    controller: _daysController,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _onDaysChanged(value);
                    },
                  ),
                ),
              ),
            ),
          ),
          Text(AppLocalizations.of(context)!.days),
        ],
      ),
    );
  }

  ListTile _buildSaveButton(
      GlobalKey<FormState> formKey, BuildContext context) {
    return ListTile(
      title: ElevatedButton(
        key: const Key("saveButton"),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _persistCondition();
            Navigator.pop(context);
          }
        },
        child: Text(AppLocalizations.of(context)!.save),
      ),
    );
  }

  void _persistCondition() {
    final groupCondition = GroupCondition(
      id: widget.condition?.id,
      conditionedGroupId: widget.conditionedGroup.id!,
      conditionalGroupId: _selectedConditionalGroupId!,
      usedTime: _selectedTime!,
      duringLastDays: _selectedDays!,
    );
    if (widget.condition != null) {
      locator<GroupConditionService>().updateGroupCondition(groupCondition);
    } else {
      locator<GroupConditionService>().saveGroupCondition(groupCondition);
    }
  }
}

Future<List<AppGroup>> _fetchPositiveGroups(AppGroup currentGroup) async {
  if (currentGroup.id == null) {
    return [];
  }
  final appGroupService = locator<AppGroupService>();
  final groups = await appGroupService.getGroups(GroupType.positive);
  return groups.where((group) => group.id != currentGroup.id).toList();
}
