import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Update search query in provider
  void _onSearch() {
   
    ref.read(searchQueryProvider.notifier).state =
        _searchController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    // Watch current search query
    final query = ref.watch(searchQueryProvider);

    // Watch search results
    final resultsAsync = ref.watch(searchProductsProvider(query));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('Search Products',
            style: TextStyle(
                color: AppColors.dark,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        leading: GestureDetector(
          onTap: () => context.go('/home'),
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.dark, size: 16),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => _onSearch(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.dark),
                      decoration: InputDecoration(
                        hintText: 'Search e.g. phone, laptop...',
                        hintStyle: const TextStyle(
                            color: AppColors.muted, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.muted),
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),

          // Results
          Expanded(
  child: query.isEmpty
      ? const Center(
          child: Text(
            'Search for a product',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 15,
            ),
          ),
        )
      : resultsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
          error: (e, _) => Center(
            child: Text(
              'Error: $e',
              style: const TextStyle(
                color: AppColors.muted,
              ),
            ),
          ),
          data: (products) => products.isEmpty
              ? const Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 15,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, i) => ProductCard(
                    product: products[i],
                    onTap: () => context.go(
                      '/product-detail',
                      extra: products[i],
                    ),
                  ),
                ),
        ),
)
        ],
      ),
    );
  }
}