import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';

void main() {
  runApp(const LinguaLearnApp());
}

/// LinguaLearn — CodeAlpha App Development Task 4: Language Learning App.
///
/// Learn Spanish, French and German with flashcards, a Lesson of the Day
/// and multiple-choice quizzes. Progress is saved on the device with
/// SharedPreferences and pronunciation uses flutter_tts.
class LinguaLearnApp extends StatelessWidget {
  const LinguaLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinguaLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  // --- Learning state -------------------------------------------------------
  String _langCode = 'es';
  String _category = 'All';
  int _cardIndex = 0;
  bool _showAnswer = false;
  final Set<String> _learned = <String>{};
  final Map<String, int> _bestScores = <String, int>{};
  bool _prefsReady = false;

  // --- Quiz state -----------------------------------------------------------
  String _quizCategory = 'All';
  List<WordItem> _quizQuestions = <WordItem>[];
  List<String> _currentOptions = <String>[];
  int _quizIndex = 0;
  int _quizScore = 0;
  String? _selectedOption;
  bool _quizFinished = false;

  final FlutterTts _tts = FlutterTts();
  final Random _random = Random();

  LanguageData get _language => languages[_langCode]!;

  List<WordItem> get _filteredItems {
    final items = _language.items;
    if (_category == 'All') return items;
    return items.where((item) => item.category == _category).toList();
  }

  String _keyFor(WordItem item) => '$_langCode|${item.english}';

  int get _learnedInLanguage {
    return _language.items
        .where((item) => _learned.contains(_keyFor(item)))
        .length;
  }

  double get _learnedFraction {
    if (_language.items.isEmpty) return 0;
    return _learnedInLanguage / _language.items.length;
  }

  /// The 5 Lesson of the Day items, chosen deterministically from the date
  /// (same 5 items for everyone on the same day, a new set tomorrow).
  List<WordItem> get _lessonOfTheDay {
    final now = DateTime.now();
    final dayOfYear =
        now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final items = _language.items;
    final start = (dayOfYear * 5) % items.length;
    return List<WordItem>.generate(
      5,
      (i) => items[(start + i) % items.length],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final learned = prefs.getStringList('learned') ?? <String>[];
    final best = <String, int>{};
    for (final code in languages.keys) {
      final score = prefs.getInt('best_$code');
      if (score != null) best[code] = score;
    }
    if (!mounted) return;
    setState(() {
      _learned.addAll(learned);
      _bestScores.addAll(best);
      _prefsReady = true;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('learned', _learned.toList());
    for (final entry in _bestScores.entries) {
      await prefs.setInt('best_${entry.key}', entry.value);
    }
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.setLanguage(_language.ttsLocale);
      await _tts.speak(text);
    } catch (_) {
      // Pronunciation depends on the device's installed TTS voices.
      // The app keeps working without it.
    }
  }

  void _setLanguage(String code) {
    setState(() {
      _langCode = code;
      _cardIndex = 0;
      _showAnswer = false;
      _quizQuestions = <WordItem>[];
      _quizFinished = false;
    });
  }

  void _setCategory(String category) {
    setState(() {
      _category = category;
      _cardIndex = 0;
      _showAnswer = false;
    });
  }

  void _flipCard() => setState(() => _showAnswer = !_showAnswer);

  void _previousCard() {
    final items = _filteredItems;
    if (items.isEmpty) return;
    setState(() {
      _cardIndex = (_cardIndex - 1 + items.length) % items.length;
      _showAnswer = false;
    });
  }

  void _nextCard() {
    final items = _filteredItems;
    if (items.isEmpty) return;
    setState(() {
      _cardIndex = (_cardIndex + 1) % items.length;
      _showAnswer = false;
    });
  }

  void _shuffleCard() {
    final items = _filteredItems;
    if (items.isEmpty) return;
    setState(() {
      _cardIndex = _random.nextInt(items.length);
      _showAnswer = false;
    });
  }

  void _toggleLearned() {
    final items = _filteredItems;
    if (items.isEmpty) return;
    final item = items[_cardIndex];
    final key = _keyFor(item);
    setState(() {
      if (_learned.contains(key)) {
        _learned.remove(key);
      } else {
        _learned.add(key);
      }
    });
    _saveProgress();
  }

  // --- Quiz -----------------------------------------------------------------
  void _startQuiz() {
    final pool = _quizCategory == 'All'
        ? _language.items
        : _language.items
            .where((item) => item.category == _quizCategory)
            .toList();
    final shuffled = List<WordItem>.from(pool)..shuffle(_random);
    setState(() {
      _quizQuestions = shuffled.take(10).toList();
      _quizIndex = 0;
      _quizScore = 0;
      _selectedOption = null;
      _quizFinished = false;
      _currentOptions =
          _quizQuestions.isEmpty ? <String>[] : _optionsFor(_quizQuestions[0]);
    });
  }

  List<String> _optionsFor(WordItem question) {
    final distractors = _language.items
        .where((item) => item.target != question.target)
        .map((item) => item.target)
        .toList()
      ..shuffle(_random);
    final options = <String>[question.target, ...distractors.take(3)]
      ..shuffle(_random);
    return options;
  }

  void _answerQuiz(String chosen, String correct) {
    if (_selectedOption != null) return;
    setState(() {
      _selectedOption = chosen;
      if (chosen == correct) _quizScore++;
    });
  }

  void _nextQuizQuestion() {
    if (_quizIndex + 1 < _quizQuestions.length) {
      setState(() {
        _quizIndex++;
        _selectedOption = null;
        _currentOptions = _optionsFor(_quizQuestions[_quizIndex]);
      });
    } else {
      final previousBest = _bestScores[_langCode];
      if (previousBest == null || _quizScore > previousBest) {
        _bestScores[_langCode] = _quizScore;
        _saveProgress();
      }
      setState(() => _quizFinished = true);
    }
  }

  String _quizResultMessage() {
    if (_quizScore == 10) return 'Perfect score! 🎉';
    if (_quizScore >= 7) return 'Great job! 👏';
    if (_quizScore >= 5) return 'Good start — keep practising! 💪';
    return 'Keep practising — try the flashcards again! 📚';
  }

  // --- Build ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌍 LinguaLearn'),
        centerTitle: true,
      ),
      body: _tabIndex == 0 ? _buildLearnTab() : _buildQuizTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
        ],
      ),
    );
  }

  Widget _buildLearnTab() {
    final items = _filteredItems;
    final WordItem? current =
        items.isEmpty ? null : items[_cardIndex % items.length];
    final bool isLearned =
        current != null && _learned.contains(_keyFor(current));
    final best = _bestScores[_langCode];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Choose a language',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'All lessons show the English meaning with the translation '
            'in your chosen language.',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: languages.entries.map((entry) {
              return ChoiceChip(
                label: Text('${entry.value.flag} ${entry.value.name}'),
                selected: _langCode == entry.key,
                onSelected: (_) => _setLanguage(entry.key),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatCard(
                value: '$_learnedInLanguage',
                label: 'Words learned\n(this language)',
              ),
              _StatCard(
                value: '${_learned.length}',
                label: 'Words learned\n(all languages)',
              ),
              _StatCard(
                value: best == null ? '–' : '$best / 10',
                label: 'Best quiz score\n(this language)',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: '📅 Lesson of the Day',
            subtitle:
                '${_todayLabel()} — 5 new ${_language.name} words for today',
            child: Column(
              children: _lessonOfTheDay.map((item) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.target,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item.english),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(label: Text(item.category)),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        tooltip: 'Hear pronunciation',
                        onPressed: () => _speak(item.target),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: '🃏 Flashcards',
            subtitle:
                'Tap the card to flip it. English on the front, translation on the back.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 8,
                  children: categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: _category == category,
                      onSelected: (_) => _setCategory(category),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                if (current == null)
                  const Text('No cards in this category.')
                else
                  GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey<bool>(_showAnswer),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: _showAnswer
                                ? const [
                                    Color(0xFF00B894),
                                    Color(0xFF00CEC9),
                                  ]
                                : const [
                                    Color(0xFF74B9FF),
                                    Color(0xFFA29BFE),
                                  ],
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _showAnswer ? _language.name : 'English',
                              style: const TextStyle(
                                color: Colors.white70,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _showAnswer ? current.target : current.english,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _showAnswer
                                  ? '${current.english} • ${current.category}'
                                  : 'Tap to see the translation',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            if (_showAnswer)
                              IconButton(
                                icon: const Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                ),
                                tooltip: 'Hear pronunciation',
                                onPressed: () => _speak(current.target),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                if (isLearned)
                  const Center(
                    child: Chip(label: Text('✓ Learned')),
                  ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton(
                      onPressed: _previousCard,
                      child: const Text('← Previous'),
                    ),
                    FilledButton(
                      onPressed: _flipCard,
                      child: Text(
                        _showAnswer ? 'Hide Answer' : 'Show Answer',
                      ),
                    ),
                    FilledButton(
                      onPressed: _nextCard,
                      child: const Text('Next →'),
                    ),
                    OutlinedButton(
                      onPressed: _shuffleCard,
                      child: const Text('🔀 Shuffle'),
                    ),
                    FilledButton.tonal(
                      onPressed: _toggleLearned,
                      child: Text(
                        isLearned
                            ? '✓ Learned — Tap to Unmark'
                            : '✓ Mark as Learned',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: _learnedFraction),
                const SizedBox(height: 6),
                Text(
                  '$_learnedInLanguage of ${_language.items.length} '
                  '${_language.name} words learned '
                  '(${(_learnedFraction * 100).round()}%)',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (!_prefsReady)
            const Text(
              'Loading your saved progress…',
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildQuizTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '📝 Quiz — Practice Test',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pick the correct translation. 10 questions, 4 options each. '
            'Your best score per language is saved on this device.',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Category: '),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _quizCategory,
                items: categories
                    .map(
                      (c) => DropdownMenuItem(value: c, child: Text(c)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _quizCategory = value;
                      _quizQuestions = <WordItem>[];
                      _quizFinished = false;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _startQuiz,
            child: const Text('Start Quiz'),
          ),
          const SizedBox(height: 16),
          if (_quizFinished) _buildQuizResult(),
          if (_quizQuestions.isNotEmpty && !_quizFinished)
            _buildQuizQuestion(),
        ],
      ),
    );
  }

  Widget _buildQuizQuestion() {
    final question = _quizQuestions[_quizIndex];
    final options = _currentOptions;
    final answered = _selectedOption != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Question ${_quizIndex + 1} of ${_quizQuestions.length} '
          '• Score: $_quizScore',
        ),
        const SizedBox(height: 8),
        Text(
          'What is "${question.english}" in ${_language.name}?',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...options.map((option) {
          Color? background;
          if (answered && option == question.target) {
            background = Colors.green.shade100;
          } else if (answered && option == _selectedOption) {
            background = Colors.red.shade100;
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: background,
                padding: const EdgeInsets.all(16),
              ),
              onPressed:
                  answered ? null : () => _answerQuiz(option, question.target),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(option, style: const TextStyle(fontSize: 17)),
              ),
            ),
          );
        }),
        if (answered)
          Text(
            _selectedOption == question.target
                ? '✅ Correct!'
                : '❌ Not quite — the answer is "${question.target}".',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: answered ? _nextQuizQuestion : null,
          child: Text(
            _quizIndex + 1 < _quizQuestions.length
                ? 'Next Question →'
                : 'See Result',
          ),
        ),
      ],
    );
  }

  Widget _buildQuizResult() {
    final best = _bestScores[_langCode];
    return Column(
      children: [
        Text(
          '$_quizScore / ${_quizQuestions.length}',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(_quizResultMessage(), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          'Best score in ${_language.name}: ${best ?? _quizScore} / 10',
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _startQuiz,
          child: const Text('Play Again'),
        ),
      ],
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} '
        '${now.day}, ${now.year}';
  }

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
