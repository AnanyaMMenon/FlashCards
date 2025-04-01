import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../utils/db_helper.dart';

class DeckEditor extends StatefulWidget {
  final Deck? deck;

  const DeckEditor({Key? key, this.deck}) : super(key: key);

  @override
  _DeckEditorState createState() => _DeckEditorState();
}

class _DeckEditorState extends State<DeckEditor> {
  final dbHelper = DBHelper.instance;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.deck != null) {
      _titleController.text = widget.deck!.title;
    }
  }

  Future<void> _saveDeck() async {
    if (widget.deck == null) {
      await dbHelper.insertDeck(Deck(title: _titleController.text));
    } else {
      await dbHelper.updateDeck(widget.deck!.copyWith(title: _titleController.text));
    }
    Navigator.pop(context, true); 
  }

  Future<void> _deleteDeck() async {
    if (widget.deck != null) {
      await dbHelper.deleteDeck(widget.deck!.id!);
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck == null ? 'Create Deck' : 'Edit Deck'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deck name',
              style: TextStyle(color: Colors.blue),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _saveDeck,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 20),
                if (widget.deck != null)
                  TextButton(
                    onPressed: _deleteDeck,
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
