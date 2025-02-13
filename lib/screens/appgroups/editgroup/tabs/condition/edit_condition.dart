import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../../db/entity/app_group.dart';
import '../../../../../db/entity/group_condition.dart';
import '../../../../../db/service/app_group_service.dart';
import '../../../../../db/service/group_condition_service.dart';

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
  String? _selectedConditionalGroupId;

  int? _selectedDays;
  Duration? _selectedTime;

  Future<void> _pickTime() async {
    TimeOfDay? initialTime;
    if (_selectedTime != null) {
      initialTime = TimeOfDay(
          hour: _selectedTime!.inHours, minute: _selectedTime!.inMinutes % 60);
    } else {
      initialTime = const TimeOfDay(hour: 0, minute: 15); // Default time
    }

    final TimeOfDay? newTime = await showTimePicker(
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
        _timeController.text =
            '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';
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
    final _formKey = GlobalKey<FormState>();

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
            final groups = snapshot.data!;
            return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ListTile(
                      title: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.conditionalGroup,
                        ),
                        value: _selectedConditionalGroupId,
                        onChanged: (String? newValue) {
                          _selectedConditionalGroupId = newValue;
                        },
                        items: groups
                            .map((group) => group.name)
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
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
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          const Baseline(
                            baseline: 30,
                            baselineType: TextBaseline.alphabetic,
                            child: Text('Has used '),
                          ),
                          IntrinsicWidth(
                            child: Baseline(
                              baseline: 40,
                              baselineType: TextBaseline.alphabetic,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 60),
                                child: TextFormField(
                                  controller: _timeController,
                                  decoration: const InputDecoration(
                                    labelText: 'HH:mm',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  onTap: _pickTime,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          const Text('In the last '),
                          IntrinsicWidth(
                            child: Baseline(
                              baseline: 30,
                              baselineType: TextBaseline.alphabetic,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 60),
                                child: TextFormField(
                                  controller: _daysController,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 18),
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
                          const Text(' days'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    ListTile(
                      title: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ));
          }
        },
      ),
    );
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
