import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/cart_items/cart_mock_data.dart';
import 'package:it_tools_app/features/catalog/domain/entities/product_details_entities.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_details_providers.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_details_bottom_bar.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_details_header_section.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_image_gallery.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_specs_section.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_variants_section.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? product;

  const ProductDetailsPage({super.key, this.product});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  VariantSelectionController? _variantController;
  String? _loadedProductId;
  bool _isFavorite = false;

  String get _idOrSlug =>
      (widget.product?['id'] as String?) ??
      (widget.product?['slug'] as String?) ??
      '';

  void _ensureController(ProductDetailsEntity details) {
    if (_loadedProductId != details.id || _variantController == null) {
      _loadedProductId = details.id;
      _variantController = VariantSelectionController(details);
      _isFavorite = details.isFavorite;
    }
  }

  List<String> _resolveGalleryImages(
    ProductDetailsEntity details,
    ProductVariantEntity? selectedVariant,
  ) {
    if (details.images.isEmpty) {
      final fallback = widget.product?['image'] as String?;
      return [
        if (fallback != null && fallback.isNotEmpty)
          fallback
        else
          'assets/images/products/keyboard.png',
      ];
    }

    if (selectedVariant != null && selectedVariant.imageIds.isNotEmpty) {
      final variantUrls = details.images
          .where((img) => selectedVariant.imageIds.contains(img.id))
          .map((img) => img.url)
          .toList();
      if (variantUrls.isNotEmpty) return variantUrls;
    }

    return details.images.map((img) => img.url).toList();
  }

  void _addToCart(
    ProductDetailsEntity details,
    VariantSelectionState selection,
    String mainImage,
  ) {
    final variant = selection.selectedVariant;
    if (!selection.canAddToCart || variant == null) return;

    CartMockData.addItem({
      'id': details.id,
      'variantId': variant.id,
      'name': details.name,
      'variant': variant.label,
      'price': variant.finalPriceUsd.toDouble(),
      'oldPrice': variant.priceUsd.toDouble(),
      'image': mainImage,
      'quantity': selection.quantity,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تمت إضافة ${details.name} (${selection.quantity}) إلى السلة',
        ),
        backgroundColor: AppColors.navy900,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final idOrSlug = _idOrSlug;
    if (idOrSlug.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('معرّف المنتج غير متوفر')),
      );
    }

    final detailsAsync = ref.watch(productDetailsProvider(idOrSlug));

    return detailsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) {
        final msg = err.toString().replaceFirst('Exception: ', '');
        final isNotFound = msg.contains('غير موجود') || msg.contains('404');
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isNotFound
                        ? Icons.inventory_2_outlined
                        : Icons.error_outline,
                    size: 48,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isNotFound ? 'المنتج غير متاح' : msg,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isNotFound
                        ? () => context.go(AppRouter.home)
                        : () =>
                              ref.invalidate(productDetailsProvider(idOrSlug)),
                    child: Text(
                      isNotFound ? 'الرجوع للرئيسية' : 'إعادة المحاولة',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },

      data: (details) {
        _ensureController(details);
        final controller = _variantController!;
        final selection = controller.state;
        final galleryImages = _resolveGalleryImages(
          details,
          selection.selectedVariant,
        );
        final specsList = details.specs
            .map((s) => {'label': s.name, 'value': s.value})
            .toList();

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageGallery(
                    images: galleryImages,
                    isFavorite: _isFavorite,
                    onToggleFavorite: () =>
                        setState(() => _isFavorite = !_isFavorite),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductDetailsHeaderSection(
                          details: details,
                          selection: selection,
                        ),
                        if (details.attributes.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Divider(
                              height: 1,
                              color: AppColors.borderDefault,
                            ),
                          ),
                          ProductVariantsSection(
                            attributes: details.attributes,
                            variants: details.variants,
                            selectedAttributeValues:
                                selection.selectedAttributeValues,
                            onAttributeSelected: (attrId, valId) => setState(
                              () => controller.selectAttributeValue(
                                attrId,
                                valId,
                              ),
                            ),
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(
                            height: 1,
                            color: AppColors.borderDefault,
                          ),
                        ),
                        ProductSpecsSection(
                          description: details.description,
                          specs: specsList,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: ProductDetailsBottomBar(
            quantity: selection.quantity,
            canAddToCart: selection.canAddToCart,
            canIncrement:
                selection.canAddToCart &&
                selection.quantity < selection.maxStock,
            onIncrement: () => setState(() => controller.incrementQuantity()),
            onDecrement: () => setState(() => controller.decrementQuantity()),
            onAddToCart: () =>
                _addToCart(details, selection, galleryImages.first),
          ),
        );
      },
    );
  }
}
