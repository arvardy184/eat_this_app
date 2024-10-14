// import 'package:can_i_eat_this/app/data/models/product_model.dart';
// import 'package:can_i_eat_this/app/data/providers/api_provider.dart';

// class ProductRepository {
//   final ApiProvider _apiProvider;

//   ProductRepository(this._apiProvider);

//   Future<Product> getProductByBarcode(String barcode) async {
//     try {
//       final response = await _apiProvider.get('/products/$barcode');
//       return Product.fromJson(response.data);
//     } catch (e) {
//       throw e;
//     }
//   }

//   Future<List<Product>> getRecommendedProducts(String userId) async {
//     try {
//       final response = await _apiProvider.get('/recommendations/$userId');
//       return (response.data as List).map((json) => Product.fromJson(json)).toList();
//     } catch (e) {
//       throw e;
//     }
//   }
// }