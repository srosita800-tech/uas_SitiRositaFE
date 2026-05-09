class ProductModel {
  final int id;
  final String name;
  final double price;
  final String category;
  final String? description;
  final int stock;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.description,
    required this.stock,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? json['ID'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      description: json['description'],
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'] ?? json['imageURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'description': description,
      'stock': stock,
      'image_url': imageUrl,
    };
  }
}
