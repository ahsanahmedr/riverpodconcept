import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Controller created once, not on every build
  final _searchController = TextEditingController();
    // Bottom nav selected index
  int _selectedIndex = 0;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
 
  // Handle bottom nav tap
  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
 
    if (index == 1) {
      context.go('/profile');
    }
  }


  @override
  Widget build(BuildContext context) {
    // Watch search query
    final query = ref.watch(searchQueryProvider);

    // Switch between all products and search results
    final productsAsync = query.isEmpty
        ? ref.watch(productsProvider)
        : ref.watch(searchProductsProvider(query));

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 70,

        // Search bar in title
        title: TextField(
          controller: _searchController,
          onChanged: (val) =>
              ref.read(searchQueryProvider.notifier).state = val,
          style: const TextStyle(fontSize: 14, color: AppColors.dark),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
            prefixIcon:
                const Icon(Icons.search_rounded, color: AppColors.muted),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
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
        data: (products) => products.isEmpty
            ? const Center(
                child: Text('No products found',
                    style: TextStyle(color: AppColors.muted, fontSize: 15)))
            : GridView.builder(
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
                  onTap: () =>
                      context.go('/product-detail', extra: products[i]),
                ),
              ),
      ),
  bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
      // FAB — add product,
    );
  }
}