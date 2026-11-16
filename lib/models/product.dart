class Product {
  final int id;
  final String title;
  final String brand;
  final String description;
  final double price;
  final String thumbnail;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? '',
      brand: json['brand'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] ?? json['coverUrl'] ?? '',
      category: json['category'] ?? json['genre'] ?? 'Lainnya',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'brand': brand,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'category': category,
    };
  }

  Product copyWith({
    int? id,
    String? title,
    String? brand,
    String? description,
    double? price,
    String? thumbnail,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      category: category ?? this.category,
    );
  }
}
