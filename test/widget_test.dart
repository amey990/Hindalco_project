import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindalco/main.dart';

void main() {
  testWidgets('renders the empty home page', (WidgetTester tester) async {
    await tester.pumpWidget(const HindalcoApp());

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('Flutter Demo Home Page'), findsNothing);
  });
}
