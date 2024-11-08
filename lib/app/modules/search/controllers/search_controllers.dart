import 'package:eat_this_app/app/data/models/product_model.dart';
import 'package:eat_this_app/app/modules/auth/controllers/base_controller.dart';
import 'package:eat_this_app/services/search_service.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SearchControllers extends BaseController {
  final SearchService _searchService = SearchService();
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecommendedProducts();
  }

  Future<void> loadRecommendedProducts() async {
    try {
      isLoading.value = true;
      final recommendedProducts = await _searchService.getRecommendedProducts();
      products.value = recommendedProducts;
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    // if (query.isEmpty) {
    //   await loadRecommendedProducts();
    //   return;
    // }

    try {
      isLoading.value = true;
      isSearching.value = true;
      final searchResults = await _searchService.searchProducts(query);
      products.value = searchResults;
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchQueryChanged(String query) {
    searchQuery.value = query;
    _debounceSearch();
  }

  void _debounceSearch() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (searchQuery.value == searchQuery.value) {
        searchProducts(searchQuery.value);
      }
    });
  }
}
