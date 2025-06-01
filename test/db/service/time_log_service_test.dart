import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  final locator = GetIt.instance;

  setUp(() {});

  tearDown(() {
    locator.reset();
  });

  group('TimeLogService', () {
    test('add log to repository', () async {
      fail("to be implemented");
    });
  });
}
