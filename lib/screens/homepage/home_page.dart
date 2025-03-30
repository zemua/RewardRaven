import 'package:flutter/material.dart';
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
    return Scaffold(
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
                const WatchdogWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
