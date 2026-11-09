class Novel {
  final String id;
  final String title;
  final String author;
  final String description;
  final double price;
  final String coverUrl;
  final String genre;

  Novel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.coverUrl,
    required this.genre,
  });

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      coverUrl: json['coverUrl'] ?? json['thumbnail'] ?? '',
      genre: json['genre'] ?? json['category'] ?? 'Fiksi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'coverUrl': coverUrl,
      'genre': genre,
    };
  }
}