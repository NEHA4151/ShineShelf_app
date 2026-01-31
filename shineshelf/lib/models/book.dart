class Book {
  final int id;
  final String title;
  final String author;
  final String? genre;
  final String? coverImageUrl;
  final String? description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.genre,
    this.coverImageUrl,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      genre: json['genre'],
      coverImageUrl: json['cover_image_url'],
      description: json['description'],
    );
  }
}
