import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../platform_wrapper.dart';
import '../../toaster.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt _locator = GetIt.instance;

class SendToastChain implements AppDataHandler {
  AppDataHandler? _nextHandler;
  final PlatformWrapper _platformWrapper = _locator<PlatformWrapper>();

  SendToastChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');
    _sendBlockingToast(data);
  }

  void _sendBlockingToast(AppData data) {
    if (!data.hasBeenBlocked) {
      return;
    }
    _locator<Toaster>().showToast(
      msg: data.localizedStrings.appBlocked ?? "App Blocked",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
    );
    if (_platformWrapper.isAndroid()) {
      for (var message in data.blockingMessages) {
        _locator<Toaster>().showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      }
    }
  }
}
