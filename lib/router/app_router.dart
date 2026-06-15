import 'package:go_router/go_router.dart';
import '../models/product_model.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../widgets/add_product_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/update_product_screen.dart';
import '../screens/search_screen.dart';
import '../screens/profile_screen.dart';
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      // Home — products list
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Add product
      GoRoute(
        path: '/add-product',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
  path: '/profile',
  builder: (context, state) => const ProfileScreen(),
),
      // Product detail — product object extra se aata hai
      GoRoute(
        path: '/product-detail',
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return ProductDetailScreen(product: product);
        },
      ),
      // Update product — product object extra se aata hai
      GoRoute(
        path: '/update-product',
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return UpdateProductScreen(product: product);
        },
      ),
      // Search
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
    ],
  );
}