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
  bool _sortAZ = false; // default to creation order

  @override
  void initState() {
    super.initState();
    _loadFlashcards(); // load in original creation order
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
        _flashcards.sort((a, b) => a.question.toLowerCase().compareTo(b.question.toLowerCase()));
      } else {
        _loadFlashcards(); // reload from DB in creation order
      }
    });
  }

  void _toggleSortOrder() {
    _sortAZ = !_sortAZ;
    _sortFlashcards();
  }

  void _editFlashcard(Flashcard flashcard) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardEditor(deckId: widget.deck.id!, flashcard: flashcard),
      ),
    );
    if (result == true) {
      await _loadFlashcards();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flashcard updated')),
      );
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
      await _loadFlashcards(); // shows new card at bottom
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flashcard added')),
      );
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.deck.title} Deck'),
            Text(
              _sortAZ ? 'Sorted: A-Z' : 'Sorted: Oldest First',
              style: const TextStyle(fontSize: 12, color: Color.fromARGB(0, 255, 255, 255)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _toggleSortOrder,
            tooltip: _sortAZ ? "Sort by Creation Order" : "Sort A-Z",
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
          maxCrossAxisExtent: 200,
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
        onPressed: _addNewFlashcard,
      ),
    );
  }
}
