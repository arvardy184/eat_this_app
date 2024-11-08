import 'package:eat_this_app/app/modules/search/controllers/search_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  final SearchControllers controller = Get.put(SearchControllers());

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (query) =>
                          controller.searchQuery.value = query,
                      decoration: InputDecoration(
                        hintText: 'Search product name or code',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.blue),
                        onPressed: () {
                          controller
                              .searchProducts(controller.searchQuery.value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.products.isEmpty) {
                  return const Center(
                    child: Text('No products found'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.products.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final product = controller.products[index];

                    return ListTile(
                      onTap: () {
                        Get.toNamed(
                          '/product/details',
                          arguments: product
                              .id, // Mengirimkan ID produk ke halaman detail
                        );
                      },
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: product.imageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(product.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: product.imageUrl == null
                            ? const Icon(Icons.image_not_supported)
                            : null,
                      ),
                      title: Text(
                        product.name ?? 'Tidak ada Produk',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        product.keywords ?? 'Tidak ada Kata Kunci',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
