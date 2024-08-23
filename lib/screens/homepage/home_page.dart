import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../apps/app_list.dart';
import '../apps/list_type.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
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
                                    listType: ListType.POSITIVE,
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
                          print('Positive groups button pressed');
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
                                    listType: ListType.NEGATIVE,
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
                          print('Negative groups button pressed');
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
                        print('Random checks button pressed');
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
                        print('My Times button pressed');
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
                        print('Settings button pressed');
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
    );
  }
}
