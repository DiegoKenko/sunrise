import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sunrise/main.dart' as sunrise;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('homepage', () {
    testWidgets('google login', (widgetTester) async {
      sunrise.main();
      await widgetTester.pumpAndSettle();

      expect(find.byKey(const Key('loginGoogleButton')), findsOneWidget);
    });
  });
}
