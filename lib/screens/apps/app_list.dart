import 'package:flutter/material.dart';

class AppList extends StatelessWidget {
  const AppList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO pass a positive/negative renderer object in the constructor
    return Scaffold(
      appBar: AppBar(
        title: Text('Empty Screen'),
      ),
      body: Center(
        child: Text('This is an empty screen'),
      ),
    );
  }
}
