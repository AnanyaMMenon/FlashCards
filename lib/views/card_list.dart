import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../utils/db_helper.dart';
import 'card_editor.dart';
import 'quiz_page.dart';

class CardList extends StatefulWidget {
  final Deck deck;

  const CardList({Key? key, required this.deck}) : super(key: key);

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  List<Flashcard> _flashcards = [];
  bool _sortAZ = true; // true for A-Z, false for creation order

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    final dbHelper = DBHelper.instance;
    final cards = await dbHelper.fetchFlashcards(widget.deck.id!);
    setState(() {
      _flashcards = cards;
    });
  }

  void _sortFlashcards() {
    setState(() {
      if (_sortAZ) {
        // Sort A-Z by question
        _flashcards.sort((a, b) => a.question.compareTo(b.question));
      } else {
        // Sort by creation order (no additional sorting needed)
        _loadFlashcards();
      }
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _sortAZ = !_sortAZ;
      _sortFlashcards();
    });
  }

  void _editFlashcard(Flashcard flashcard) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CardEditor(deckId: widget.deck.id!, flashcard: flashcard),
    ),
  );
  if (result == true) {
    _loadFlashcards(); 
  }
}
void _addNewFlashcard() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CardEditor(deckId: widget.deck.id!),
    ),
  );
  if (result == true) {
    _loadFlashcards(); 
  }
}

  void _startQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(deck: widget.deck),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.deck.title} Deck'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _toggleSortOrder,
            tooltip: _sortAZ ? "Sort by Recently Viewed" : "Sort A-Z",
          ),
          IconButton(
            icon: const Icon(Icons.quiz),
            onPressed: _startQuiz,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200, // Max width of each flashcard
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _flashcards.length,
        itemBuilder: (context, index) {
          final flashcard = _flashcards[index];
          return Card(
            color: const Color.fromARGB(255, 210, 139, 223),
            child: Stack(
              children: [
                InkWell(
                  onTap: () => _editFlashcard(flashcard),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        flashcard.question,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardEditor(deckId: widget.deck.id!),
            ),
          );
          _loadFlashcards();
        },
      ),
    );
  }
}
