import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunrise/main.dart';

void main() {
  group('homePage', () {
    testWidgets('login', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Entrar'), findsOneWidget);
    });
  });
}
