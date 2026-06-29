import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edu_alumni_connect/shared/widgets/app_button.dart';

void main() {
  testWidgets('AppButton renders label correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Test Button',
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
  });
}
