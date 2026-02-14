class Book {
  final int id;
  final String title;
  final String author;
  final String? genre;
  final String? isbn;
  final String? publicationYear;
  final String? coverImageUrl;
  final String? description;
  final String? issueDate;
  final String? dueDate;
  final double? fineAmount;
  final double price;
  final double rating;
  final int reviewCount;
  final int stock;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.genre,
    this.isbn,
    this.publicationYear,
    this.coverImageUrl,
    this.description,
    this.issueDate,
    this.dueDate,
    this.fineAmount,
    this.price = 19.99,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      genre: json['genre'],
      isbn: json['isbn'],
      publicationYear: json['publication_year']?.toString(),
      coverImageUrl: json['cover_image_url'],
      description: json['description'],
      issueDate: json['issue_date'],
      dueDate: json['due_date'],
      fineAmount: json['fine_amount'] != null ? double.tryParse(json['fine_amount'].toString()) : null,
      price: json['price'] != null ? double.parse(json['price'].toString()) : 19.99,
      rating: json['average_rating'] != null ? double.parse(json['average_rating'].toString()) : 0.0,
      reviewCount: json['review_count'] != null ? int.parse(json['review_count'].toString()) : 0,
      stock: json['available_stock'] != null ? int.parse(json['available_stock'].toString()) : 0,
    );
  }
}
