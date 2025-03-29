import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

import '../../service/foreground/watchdog.dart';
import '../appgroups/app_group_list.dart';
import '../appgroups/app_group_list_type.dart';
import '../apps/app_list.dart';
import '../apps/app_list_type.dart';

final logger = Logger();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
        child: Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homePage),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppList(
                                    listType: AppListType.positive,
                                    titleBarMessage:
                                        AppLocalizations.of(context)!
                                            .positiveApps)),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.thumb_up),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.positiveApps),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppGroupList(
                                listType: AppGroupListType.positive,
                                titleBarMessage: AppLocalizations.of(context)!
                                    .positiveGroups,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.group),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.positiveGroups),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppList(
                                    listType: AppListType.negative,
                                    titleBarMessage:
                                        AppLocalizations.of(context)!
                                            .negativeApps)),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.thumb_down),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.negativeApps),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppGroupList(
                                listType: AppGroupListType.negative,
                                titleBarMessage: AppLocalizations.of(context)!
                                    .negativeGroups,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.group_off),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.negativeGroups),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.d('Random checks button pressed');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shuffle),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.randomChecks),
                        ],
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.d('My Times button pressed');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.myTimings),
                        ],
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.d('Settings button pressed');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.settings),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.settings),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void _onReceiveTaskData(Object data) {
    logger.d('onReceiveTaskData: $data');
  }

  Future<void> _requestPermissions() async {
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initService() async {
    if (await FlutterForegroundTask.isRunningService) {
      logger.d("Service is already running, doing nothing");
      return;
    } else {
      logger.d("Initializing FlutterForegroundTask service");
      FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'foreground_service',
          channelName: 'Foreground Service Notification',
          channelDescription:
              'This notification appears when the foreground service is running.',
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: true,
          playSound: false,
        ),
        foregroundTaskOptions: ForegroundTaskOptions(
            allowWakeLock: false,
            allowWifiLock: false,
            autoRunOnBoot: true,
            autoRunOnMyPackageReplaced: true,
            eventAction: ForegroundTaskEventAction.repeat(5000)),
      );
    }
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      logger.d("Service is already running");
      return FlutterForegroundTask.restartService();
    } else {
      logger.d("Starting service");
      var startServiceResult = await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(id: 'btn_hello', text: 'hello'),
        ],
        notificationInitialRoute: '/',
        callback: startCallback,
      );
      if (startServiceResult is ServiceRequestFailure) {
        logger.e(
            "Failed to start foreground service: ${startServiceResult.error}");
      }
      return startServiceResult;
    }
  }

  @override
  void initState() {
    super.initState();
    // Add a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request permissions and initialize the service.
      _requestPermissions();
      _initService();
      _startService();
    });
  }

  @override
  void dispose() {
    // Remove a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.dispose();
  }

  Future<ServiceRequestResult> _stopService() {
    logger.d('Stopping service');
    return FlutterForegroundTask.stopService();
  }
}
