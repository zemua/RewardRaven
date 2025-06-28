import 'package:flutter/material.dart';

class InjectableTimePicker {
  Future<Duration?> pickTime(BuildContext context, State state,
      Duration? selectedTime, TextEditingController timeController) async {
    TimeOfDay? initialTime;
    if (selectedTime != null) {
      initialTime = toTimeOfDay(selectedTime!);
    } else {
      initialTime = const TimeOfDay(hour: 0, minute: 0); // Default time
    }

    final TimeOfDay? newTime = await showPicker(
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
      state.setState(() {
        timeController.text = timeToDigitalClock(newTime);
      });
      return Duration(hours: newTime.hour, minutes: newTime.minute);
    }
  }

  Future<TimeOfDay?> showPicker({
    required BuildContext context,
    required TimeOfDay initialTime,
    TransitionBuilder? builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useRootNavigator = true,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    String? cancelText,
    String? confirmText,
    String? helpText,
    String? errorInvalidText,
    String? hourLabelText,
    String? minuteLabelText,
    RouteSettings? routeSettings,
    EntryModeChangeCallback? onEntryModeChanged,
    Offset? anchorPoint,
    Orientation? orientation,
  }) async {
    return showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: builder,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useRootNavigator: useRootNavigator,
        initialEntryMode: initialEntryMode,
        cancelText: cancelText,
        confirmText: confirmText,
        helpText: helpText,
        errorInvalidText: errorInvalidText,
        hourLabelText: hourLabelText,
        minuteLabelText: minuteLabelText,
        routeSettings: routeSettings,
        onEntryModeChanged: onEntryModeChanged,
        anchorPoint: anchorPoint,
        orientation: orientation);
  }
}

TimeOfDay toTimeOfDay(Duration duration) {
  return TimeOfDay(hour: duration.inHours, minute: duration.inMinutes % 60);
}

String timeToDigitalClock(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

String durationToDigitalClock(Duration duration) {
  return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
}
