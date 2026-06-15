class ProductModel {
  final int id;
  final String title;
  final double price;
  final String category;
  final String description;
  final String thumbnail;
  final double rating;
  final int stock;
  final String brand;
  final double discountPercentage;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.thumbnail,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.discountPercentage,
    required this.images,
  });

  // Convert JSON to ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? 'N/A',
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
    );
  }

  // Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'description': description,
      'thumbnail': thumbnail,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'discountPercentage': discountPercentage,
      'images': images,
    };
  }
}