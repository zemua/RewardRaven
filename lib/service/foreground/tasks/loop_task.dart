import 'dart:async';

class SomeTask {
  Timer? _timer;
  void performTask() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('Executing in foreground !');
    });
  }

  void killTask() {
    _timer?.cancel();
  }
}
