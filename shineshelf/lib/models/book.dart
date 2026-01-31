class Book {
  final int id;
  final String title;
  final String author;
  final String? genre;
  final String? coverImageUrl;
  final String? description;
  final String? issueDate;
  final String? dueDate;
  final double? fineAmount;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.genre,
    this.coverImageUrl,
    this.description,
    this.issueDate,
    this.dueDate,
    this.fineAmount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      genre: json['genre'],
      coverImageUrl: json['cover_image_url'],
      description: json['description'],
      issueDate: json['issue_date'],
      dueDate: json['due_date'],
      fineAmount: json['fine_amount'] != null ? double.parse(json['fine_amount'].toString()) : 0.0,
    );
  }
}
