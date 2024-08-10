import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const RewardRavenApp());
}

class RewardRavenApp extends StatelessWidget {
  const RewardRavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: "Reward Raven",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

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
                          print('Positive apps button pressed');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.positiveApps,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('Positive groups button pressed');
                        },
                        child:
                            Text(AppLocalizations.of(context)!.positiveGroups),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('Negative apps button pressed');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.negativeApps,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('Negative groups button pressed');
                        },
                        child:
                            Text(AppLocalizations.of(context)!.negativeGroups),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('Random checks button pressed');
                      },
                      child: Text(AppLocalizations.of(context)!.randomChecks),
                    ),
                  ),
                ]),
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('Random checks button pressed');
                      },
                      child: Text(AppLocalizations.of(context)!.randomChecks),
                    ),
                  ),
                ]),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
