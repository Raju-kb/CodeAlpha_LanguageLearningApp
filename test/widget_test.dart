import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_learning_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App pumps and shows the flashcards screen',
      (WidgetTester tester) async {
    // SharedPreferences needs mock initial values in widget tests.
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const LinguaLearnApp());
    await tester.pump();

    // Home screen: app title, language choices and flashcards section.
    expect(find.text('🌍 LinguaLearn'), findsOneWidget);
    expect(find.text('Flashcards'), findsOneWidget);
    expect(find.text('Lesson of the Day'), findsOneWidget);
    expect(find.textContaining('Spanish'), findsWidgets);

    // Tapping a flashcard flips it to show the answer.
    await tester.tap(find.text('Show Answer'));
    await tester.pump();
    expect(find.text('Hide Answer'), findsOneWidget);

    // Quiz tab is reachable from the bottom navigation bar.
    await tester.tap(find.text('Quiz'));
    await tester.pump();
    expect(find.text('Start Quiz'), findsOneWidget);
  });
}
