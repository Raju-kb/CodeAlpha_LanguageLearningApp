# LinguaLearn — Language Learning App

A Flutter mobile app for learning Spanish, French and German — built by Raju K B for the **CodeAlpha App Development Internship (Task 4)**.

Study with flashcards, hear the pronunciation, take a daily lesson and test yourself with quizzes.

## Features

- **3 languages:** Spanish, French and German — switch between them at any time
- **90 words and phrases:** 30 per language — 12 Vocabulary, 10 Phrases and 8 Grammar each
- **Flashcards:** English on the front, the translation on the back. Tap the card or **Show Answer** to flip it, move with Previous / Next, Shuffle, and **Mark as Learned** with a progress bar for each language
- **Pronunciation:** tap the speaker button on any card or lesson item to hear it spoken
- **Lesson of the Day:** 5 items, picked from the date — the same 5 for everyone on a given day
- **Quiz:** 10 multiple-choice questions, 4 options each, instant feedback on every answer, and your score at the end
- **Categories:** Vocabulary, Phrases and Grammar — filter both the flashcards and the quiz
- **Your progress is saved** on the device: words learned per language and your best quiz score per language

## Tech stack

- **Flutter** (Dart) with Material 3
- `shared_preferences` for saving progress on the device
- `flutter_tts` for pronunciation (Spanish `es-ES`, French `fr-FR`, German `de-DE`)

## Project structure

```
language-learning-app/
├── pubspec.yaml            # name: language_learning_app
├── lib/
│   ├── main.dart           # the app: Learn tab, Quiz tab, pronunciation, progress
│   └── data.dart           # the 90 words and phrases (30 per language)
├── test/
│   └── widget_test.dart    # smoke test: open the app, flip a card, open the quiz
├── android/                # Android app (applicationId com.codealpha.languagelearningapp)
├── ios/Runner/Info.plist   # iOS app metadata
└── README.md
```

## Getting started

You need the Flutter SDK (3.x) installed, plus an Android emulator/device or iOS simulator.

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```

## Build an APK (Android)

```bash
flutter build apk --release
```

The APK is produced at `build/app/outputs/flutter-apk/app-release.apk`. Install it on any Android phone to try the app.

## About this project

This is Task 4 of the CodeAlpha App Development Internship — [codealpha.tech](https://www.codealpha.tech).
