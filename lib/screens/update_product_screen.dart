import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/product_field.dart';

class UpdateProductScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  ConsumerState<UpdateProductScreen> createState() =>
      _UpdateProductScreenState();
}

class _UpdateProductScreenState extends ConsumerState<UpdateProductScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields with existing product data
    _titleController = TextEditingController(text: widget.product.title);
    _priceController =
        TextEditingController(text: '${widget.product.price}');
    _categoryController =
        TextEditingController(text: widget.product.category);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Update product and go back
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    await ref.read(updateProductProvider.notifier).updateProduct(
          id: widget.product.id,
          title: _titleController.text.trim(),
          price: double.tryParse(_priceController.text.trim()) ?? 0,
          category: _categoryController.text.trim(),
        );

    final state = ref.read(updateProductProvider);
    state.whenOrNull(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Product updated successfully!'),
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
    final isLoading = ref.watch(updateProductProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('Update Product',
            style: TextStyle(
                color: AppColors.dark,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        leading: GestureDetector(
          onTap: () => context.go('/product-detail', extra: widget.product),
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
                hint: 'Enter title',
                icon: Icons.title_rounded),
            const SizedBox(height: 14),
            ProductField(
                controller: _priceController,
                label: 'Price',
                hint: 'Enter price',
                icon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number),
            const SizedBox(height: 14),
            ProductField(
                controller: _categoryController,
                label: 'Category',
                hint: 'Enter category',
                icon: Icons.category_outlined),
            const SizedBox(height: 28),
            CustomButton(
                text: 'Update Product',
                isLoading: isLoading,
                onPressed: _submit),
          ],
        ),
      ),
    );
  }
}