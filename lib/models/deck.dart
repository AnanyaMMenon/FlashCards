class Deck {
  int? id;
  String title;

  Deck({this.id, required this.title});

  Deck copyWith({int? id, String? title}) {
    return Deck(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map) {
    return Deck(
      id: map['id'],
      title: map['title'],
    );
  }
}
