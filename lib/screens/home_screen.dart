import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch products provider
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Products',
          style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w700,
              fontSize: 22),
        ),
        actions: [
          // Search icon
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.dark),
            onPressed: () => context.go('/search'),
          ),
        ],
      ),
      body: productsAsync.when(
        // Loading state
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),

        // Error state
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: AppColors.muted)),
        ),

        // Data loaded
data: (products) => GridView.builder(
  padding: const EdgeInsets.all(16),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 0.75,
  ),
  itemCount: products.length,
  itemBuilder: (_, i) => ProductCard(
    product: products[i],
    onTap: () => context.go('/product-detail', extra: products[i]),
  ),
),
      ),

      // FAB — add product
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-product'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}