import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

// Service provider
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

// GET — all products
final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.read(productServiceProvider).getProducts();
});

// GET — single product
final productDetailProvider =
    FutureProvider.family<ProductModel, int>((ref, id) async {
  return ref.read(productServiceProvider).getProduct(id);
});
// GET — search products
final searchQueryProvider = StateProvider<String>((ref) => '');
// GET — search products
final searchProductsProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, query) async {
  if (query.isEmpty) return [];
  return ref.read(productServiceProvider).searchProducts(query);
});

// POST — add product notifier
class AddProductNotifier extends AsyncNotifier<ProductModel?> {
  @override
  Future<ProductModel?> build() async => null;

  Future<void> addProduct({
    required String title,
    required double price,
    required String category,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(productServiceProvider).addProduct(
            title: title,
            price: price,
            category: category,
          );
    });
  }
}

final addProductProvider =
    AsyncNotifierProvider<AddProductNotifier, ProductModel?>(
        AddProductNotifier.new);

// PUT — update product notifier
class UpdateProductNotifier extends AsyncNotifier<ProductModel?> {
  @override
  Future<ProductModel?> build() async => null;

  Future<void> updateProduct({
    required int id,
    required String title,
    required double price,
    required String category,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(productServiceProvider).updateProduct(
            id: id,
            title: title,
            price: price,
            category: category,
          );
    });
  }
}

final updateProductProvider =
    AsyncNotifierProvider<UpdateProductNotifier, ProductModel?>(
        UpdateProductNotifier.new);

// DELETE — delete product notifier
class DeleteProductNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> deleteProduct(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(productServiceProvider).deleteProduct(id);
    });
  }
}

final deleteProductProvider =
    AsyncNotifierProvider<DeleteProductNotifier, void>(
        DeleteProductNotifier.new);