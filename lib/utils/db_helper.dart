import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('flashcards.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE decks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId INTEGER NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        FOREIGN KEY (deckId) REFERENCES decks (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertDeck(Deck deck) async {
    final db = await instance.database;
    return await db.insert('decks', deck.toMap());
  }

  Future<List<Deck>> fetchDecks() async {
    final db = await instance.database;
    final result = await db.query('decks');
    return result.map((json) => Deck.fromMap(json)).toList();
  }

  Future<int> updateDeck(Deck deck) async {
    final db = await instance.database;
    return await db.update(
      'decks',
      deck.toMap(),
      where: 'id = ?',
      whereArgs: [deck.id],
    );
  }

  Future<int> deleteDeck(int id) async {
    final db = await instance.database;
    await db.delete('flashcards', where: 'deckId = ?', whereArgs: [id]);
    return await db.delete('decks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertFlashcard(Flashcard flashcard) async {
    final db = await instance.database;
    return await db.insert('flashcards', flashcard.toMap());
  }

  Future<List<Flashcard>> fetchFlashcards(int deckId) async {
  final db = await instance.database;
  final result = await db.query(
    'flashcards',
    where: 'deckId = ?',
    whereArgs: [deckId],
    orderBy: 'id ASC', 
  );
  return result.map((json) => Flashcard.fromMap(json)).toList();
}

  Future<int> updateFlashcard(Flashcard flashcard) async {
    final db = await instance.database;
    return await db.update(
      'flashcards',
      flashcard.toMap(),
      where: 'id = ?',
      whereArgs: [flashcard.id],
    );
  }

  Future<int> deleteFlashcard(int id) async {
    final db = await instance.database;
    return await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> loadJsonData() async {
    final dataString = await rootBundle.loadString('assets/flashcards.json');
    final jsonData = json.decode(dataString) as List<dynamic>;

    final db = await instance.database;

    for (var deckData in jsonData) {
      final deck = Deck(title: deckData['title']);
      int deckId = await db.insert('decks', deck.toMap());

      for (var cardData in deckData['flashcards']) {
        final flashcard = Flashcard(
          deckId: deckId,
          question: cardData['question'],
          answer: cardData['answer'],
        );
        await db.insert('flashcards', flashcard.toMap());
      }
    }
  }

  Future<int> getFlashcardCount(int deckId) async {
  final db = await instance.database;
  final result = await db.rawQuery(
    'SELECT COUNT(*) AS count FROM flashcards WHERE deckId = ?',
    [deckId],
  );
  return Sqflite.firstIntValue(result) ?? 0;
}

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
