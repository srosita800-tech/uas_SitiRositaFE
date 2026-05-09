import 'package:uts_uas1125170150sitirosita/core/models/product_model.dart';

class CartModel {
  final int id;
  final int productId;
  final int quantity;
  final ProductModel? product;

  CartModel({
    required this.id,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] ?? json['ID'] ?? 0,
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      product: json['product'] != null 
          ? ProductModel.fromJson(json['product']) 
          : null,
    );
  }
}
