class Book {
  final int? id;
  final String title;
  final String author;
  final String status;
  final String notes;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.status,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'status': status,
      'notes': notes,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      status: map['status'],
      notes: map['notes'],
    );
  }
}
