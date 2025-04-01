class Flashcard {
  int? id;
  int deckId;
  String question;
  String answer;

  Flashcard({this.id, required this.deckId, required this.question, required this.answer});

  Flashcard copyWith({int? id, int? deckId, String? question, String? answer}) {
    return Flashcard(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deckId': deckId,
      'question': question,
      'answer': answer,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      deckId: map['deckId'],
      question: map['question'],
      answer: map['answer'],
    );
  }
}
