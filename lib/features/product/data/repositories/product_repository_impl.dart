import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/repositories/product_repository.dart';
import '../Models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await DioClient.instance.get(ApiConstants.products);
      
      if (kDebugMode) {
        debugPrint('[REPO] Response status: ${response.statusCode}');
        debugPrint('[REPO] Response data: ${response.data}');
      }

      final dynamic rawData = response.data;
      List<dynamic> listData = [];

      if (rawData is List) {
        listData = rawData;
      } else if (rawData is Map && rawData.containsKey('data')) {
        listData = rawData['data'];
      } else {
        throw Exception('Format data tidak dikenali: $rawData');
      }

      return listData.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[REPO ERROR] Failed to fetch products: $e');
      }
      rethrow;
    }
  }
}