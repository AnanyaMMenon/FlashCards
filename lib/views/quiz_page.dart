import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../utils/db_helper.dart';
import '../models/flashcard.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  final Deck deck;

  const QuizPage({Key? key, required this.deck}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Flashcard> _flashcards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  int _seenCount = 1; 
  int _peekedCount = 0;
  Set<int> _seenCards = {0};
  Set<int> _peekedCards = {}; 

  @override
  void initState() {
    super.initState();
    _loadAndShuffleFlashcards();
  }

  Future<void> _loadAndShuffleFlashcards() async {
    final dbHelper = DBHelper.instance;
    final cards = await dbHelper.fetchFlashcards(widget.deck.id!);
    cards.shuffle(Random());
    setState(() {
      _flashcards = cards;
      _currentIndex = 0;
      _showAnswer = false;
      _seenCount = 1;
      _peekedCount = 0;
      _seenCards = {0}; 
      _peekedCards.clear(); 
    });
  }

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashcards.length;
      _showAnswer = false;
      _updateSeenCount();
    });
  }

  void _previousCard() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _flashcards.length) % _flashcards.length;
      _showAnswer = false;
      _updateSeenCount();
    });
  }

  void _updateSeenCount() {
    if (!_seenCards.contains(_currentIndex)) {
      _seenCards.add(_currentIndex);
      _seenCount++;
    }
  }

  void _toggleAnswerPeek() {
    setState(() {
      _showAnswer = !_showAnswer;
      if (_showAnswer && !_peekedCards.contains(_currentIndex)) {
        _peekedCards.add(_currentIndex);
        _peekedCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('${widget.deck.title} Quiz')),
        body: Center(child: Text('No flashcards in this deck')),
      );
    }

    final flashcard = _flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.deck.title} Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: _showAnswer ? const Color.fromARGB(255, 191, 176, 214) : const Color.fromARGB(255, 251, 187, 226),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _showAnswer ? flashcard.answer : flashcard.question,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: _showAnswer ? Colors.green[900] : Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _previousCard,
                ),
                IconButton(
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: _showAnswer ? Colors.green : Colors.grey,
                  ),
                  onPressed: _toggleAnswerPeek,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _nextCard,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Seen $_seenCount of ${_flashcards.length} cards',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Peeked at $_peekedCount of $_seenCount answers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
