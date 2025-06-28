import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../service/preferences_service.dart';
import '../../tools/injectable_time_picker.dart';

final GetIt _locator = GetIt.instance;
final _logger = Logger();

const shutdownEnabledKey = 'isShutdownEnabled';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _preferences = _locator.get<PreferencesService>();

  bool _isLoading = true;

  final timePicker = _locator<InjectableTimePicker>();
  final _shutdownStartTimeController = TextEditingController();
  Duration? _shutdownSelectedStartTime;
  final _shutdownEndTimeController = TextEditingController();
  Duration? _shutdownSelectedEndTime;

  bool? _isShutdownEnabled;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final isEnabled =
        await _preferences.getSharedBool(shutdownEnabledKey) ?? false;
    if (mounted) {
      setState(() {
        _isShutdownEnabled = isEnabled;
        _isLoading = false;
      });
    }
  }

  Future<Duration?> _pickTime(
      Duration? selectedTime, TextEditingController timeController) async {
    TimeOfDay? initialTime;
    if (selectedTime != null) {
      initialTime = toTimeOfDay(selectedTime!);
    } else {
      initialTime = const TimeOfDay(hour: 0, minute: 0); // Default time
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
      setState(() {
        timeController.text = timeToDigitalClock(newTime);
      });
      return Duration(hours: newTime.hour, minutes: newTime.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: IntrinsicWidth(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .activateShutdownDescription,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Switch(
                          value: _isShutdownEnabled ?? false,
                          onChanged: _isLoading
                              ? null
                              : (value) async {
                                  setState(() {
                                    _isShutdownEnabled = value;
                                  });
                                  _preferences.saveSharedBool(
                                      shutdownEnabledKey, value);
                                },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .shutdownNegativesWillBeClosed,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Switch(
                          value: true,
                          onChanged: (value) {
                            _logger.d('Switch changed to $value');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .shutdownNeutralsWillConsume,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Switch(
                          value: true,
                          onChanged: (value) {
                            _logger.d('Switch changed to $value');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .shutdownPositivesDoNotCount,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Switch(
                          value: true,
                          onChanged: (value) {
                            _logger.d('Switch changed to $value');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!
                              .shutdownPositivesWillConsume,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Switch(
                          value: true,
                          onChanged: (value) {
                            _logger.d('Switch changed to $value');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.shutdownStartsAt,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: IntrinsicWidth(
                          child: Baseline(
                            baseline: 40,
                            baselineType: TextBaseline.alphabetic,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 60),
                                child: TextFormField(
                                  key: const Key("shutdownStartTimeField"),
                                  controller: _shutdownStartTimeController,
                                  decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.hhmm,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 0),
                                    border: const OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  onTap: () {
                                    _pickTime(_shutdownSelectedStartTime,
                                            _shutdownStartTimeController)
                                        .then((onValue) {
                                      setState(() {
                                        _shutdownSelectedStartTime = onValue;
                                      });
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value == '00:00') {
                                      return '';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.shutdownEndsAt,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: IntrinsicWidth(
                          child: Baseline(
                            baseline: 40,
                            baselineType: TextBaseline.alphabetic,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 60),
                                child: TextFormField(
                                  key: const Key("shutdownEndTimeField"),
                                  controller: _shutdownEndTimeController,
                                  decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.hhmm,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 0),
                                    border: const OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  onTap: () {
                                    _pickTime(_shutdownSelectedEndTime,
                                            _shutdownEndTimeController)
                                        .then((onValue) {
                                      setState(() {
                                        _shutdownSelectedEndTime = onValue;
                                      });
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value == '00:00') {
                                      return '';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
