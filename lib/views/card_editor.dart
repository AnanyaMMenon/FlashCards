import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../utils/db_helper.dart';

class CardEditor extends StatefulWidget {
  final int deckId;
  final Flashcard? flashcard;

  const CardEditor({Key? key, required this.deckId, this.flashcard}) : super(key: key);

  @override
  _CardEditorState createState() => _CardEditorState();
}

class _CardEditorState extends State<CardEditor> {
  final dbHelper = DBHelper.instance;
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.flashcard != null) {
      _questionController.text = widget.flashcard!.question;
      _answerController.text = widget.flashcard!.answer;
    }
  }

  Future<void> _saveFlashcard() async {
    if (widget.flashcard == null) {
      await dbHelper.insertFlashcard(
        Flashcard(deckId: widget.deckId, question: _questionController.text, answer: _answerController.text),
      );
    } else {
      await dbHelper.updateFlashcard(
        widget.flashcard!.copyWith(question: _questionController.text, answer: _answerController.text),
      );
    }
    Navigator.pop(context, true); 
  }

  Future<void> _deleteFlashcard() async {
    if (widget.flashcard != null) {
      await dbHelper.deleteFlashcard(widget.flashcard!.id!);
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flashcard == null ? 'Create Flashcard' : 'Edit Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _saveFlashcard,
                  child: const Text('Save'),
                ),
                if (widget.flashcard != null)
                  TextButton(
                    onPressed: _deleteFlashcard,
                    child: const Text('Delete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
