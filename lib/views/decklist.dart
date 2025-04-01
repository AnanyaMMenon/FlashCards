import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../utils/db_helper.dart';
import 'deck_editor.dart';
import 'card_list.dart';

class DeckList extends StatefulWidget {
  const DeckList({super.key});

  @override
  _DeckListState createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  List<Deck> _decks = [];
  final dbHelper = DBHelper.instance;
  Map<int, int> _flashcardCounts = {}; // Map to store flashcard counts by deckId

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    final decks = await dbHelper.fetchDecks();
    final flashcardCounts = <int, int>{};
    
    // Fetch flashcard count for each deck
    for (var deck in decks) {
      final count = await dbHelper.getFlashcardCount(deck.id!);
      flashcardCounts[deck.id!] = count;
    }

    setState(() {
      _decks = decks;
      _flashcardCounts = flashcardCounts;
    });
  }

  Future<void> _loadJsonData() async {
    await dbHelper.loadJsonData();
    _loadDecks(); // Reload decks after inserting from JSON
  }

  void _navigateToCardList(Deck deck) async {
    // Navigate to CardList and reload counts when returning
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardList(deck: deck),
      ),
    );
    _loadDecks(); // Refresh the deck list and counts after returning
  }

  void _editDeck(Deck deck) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeckEditor(deck: deck),
      ),
    );
    _loadDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: _loadJsonData,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200, // Max width of each deck card
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _decks.length,
        itemBuilder: (context, index) {
          final deck = _decks[index];
          final flashcardCount = _flashcardCounts[deck.id] ?? 0;

          return Card(
            color: const Color.fromARGB(255, 243, 140, 198),
            child: Stack(
              children: [
                InkWell(
                  onTap: () => _navigateToCardList(deck),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          deck.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$flashcardCount cards',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 1,
                  right: 1,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editDeck(deck),
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
              builder: (context) => const DeckEditor(),
            ),
          );
          _loadDecks();
        },
      ),
    );
  }
}
