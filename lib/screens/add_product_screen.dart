import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../providers/product_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/product_field.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Add product and show result
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please fill all fields'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }

    await ref.read(addProductProvider.notifier).addProduct(
          title: _titleController.text.trim(),
          price: double.tryParse(_priceController.text.trim()) ?? 0,
          category: _categoryController.text.trim(),
        );

    final state = ref.read(addProductProvider);
    state.whenOrNull(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Product added successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
        context.pop();
      },
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch loading state
    final isLoading = ref.watch(addProductProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('Add Product',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            ProductField(
                controller: _titleController,
                label: 'Title',
                hint: 'e.g. BMW Pencil',
                icon: Icons.title_rounded),
            const SizedBox(height: 14),
            ProductField(
                controller: _priceController,
                label: 'Price',
                hint: 'e.g. 10',
                icon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number),
            const SizedBox(height: 14),
            ProductField(
                controller: _categoryController,
                label: 'Category',
                hint: 'e.g. stationery',
                icon: Icons.category_outlined),
            const SizedBox(height: 28),
            CustomButton(
                text: 'Save Product',
                isLoading: isLoading,
                onPressed: _submit),
          ],
        ),
      ),
    );
  }
}