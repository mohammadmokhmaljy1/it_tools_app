import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/cart_items/cart_mock_data.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_details_providers.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_details_bottom_bar.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_details_header_section.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_image_gallery.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_specs_section.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_variants_section.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductDetailsPage({super.key, this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool _isFavorite = false;
  late final VariantSelectionController _controller;

  String get _name =>
      (widget.product?['name'] as String?) ??
      'كيبورد ميكانيكي 75% لاسلكي بإضاءة RGB';
  String get _category =>
      (widget.product?['category'] as String?) ?? 'كيبورد · Redragon';
  double get _basePrice =>
      ((widget.product?['price'] ?? 33.60) as num).toDouble();
  double get _baseOldPrice =>
      ((widget.product?['oldPrice'] ?? 42.00) as num).toDouble();
  String get _mainImage =>
      (widget.product?['image'] as String?) ??
      'assets/images/products/keyboard.png';

  static const List<Map<String, String>> _specs = [
    {'label': 'الاتصال', 'value': '2.4GHz · Bluetooth · USB-C'},
    {'label': 'التخطيط', 'value': 'عربي / إنكليزي'},
    {'label': 'البطارية', 'value': '4000 mAh'},
    {'label': 'الضمان', 'value': '6 أشهر من المتجر'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = VariantSelectionController([
      ProductVariantOption(
        id: 'v1',
        sku: 'KB-BLU-BLUE',
        colorName: 'أزرق / أبيض',
        switchType: 'Blue',
        price: _basePrice,
        oldPrice: _baseOldPrice,
        stockQty: 5,
      ),
      ProductVariantOption(
        id: 'v2',
        sku: 'KB-BLK-RED',
        colorName: 'أسود مطفي',
        switchType: 'Red',
        price: _basePrice + 2.0,
        oldPrice: _baseOldPrice + 2.0,
        stockQty: 3,
      ),
      ProductVariantOption(
        id: 'v3',
        sku: 'KB-WHT-BRN',
        colorName: 'أبيض ثلجي',
        switchType: 'Brown',
        price: _basePrice + 1.0,
        oldPrice: _baseOldPrice + 1.0,
        stockQty: 4,
      ),
      ProductVariantOption(
        id: 'v4',
        sku: 'KB-BLU-SLV',
        colorName: 'أزرق / أبيض',
        switchType: 'Silver',
        price: _basePrice,
        oldPrice: _baseOldPrice,
        stockQty: 0,
      ),
    ]);
  }

  void _addToCart() {
    final s = _controller.state;
    final variant = s.selectedVariant;
    if (variant == null || !s.canAddToCart) return;

    CartMockData.addItem({
      'name': _name,
      'variant': 'اللون: ${s.selectedColor} · السويتش: ${s.selectedSwitch}',
      'price': variant.price,
      'oldPrice': variant.oldPrice,
      'image': _mainImage,
      'quantity': s.quantity,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة $_name (${s.quantity}) إلى السلة'),
        backgroundColor: AppColors.navy900,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = _controller.state;
    final variant = s.selectedVariant;
    final double activePrice = variant?.price ?? _basePrice;
    final double activeOldPrice = variant?.oldPrice ?? _baseOldPrice;
    final int stockQty = variant?.stockQty ?? 0;
    final bool inStock = (variant?.inStock ?? false) && stockQty > 0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImageGallery(
                images: [_mainImage, _mainImage, _mainImage, _mainImage],
                isFavorite: _isFavorite,
                onToggleFavorite: () =>
                    setState(() => _isFavorite = !_isFavorite),
                onShare: () => SharePlus.instance.share(
                  ShareParams(
                    text: '$_name - \$${activePrice.toStringAsFixed(2)}',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductDetailsHeaderSection(
                      category: _category,
                      name: _name,
                      price: activePrice,
                      oldPrice: activeOldPrice,
                      stockQty: stockQty,
                      inStock: inStock,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Divider(height: 1, color: AppColors.borderDefault),
                    ),
                    ProductVariantsSection(
                      selectedColor: s.selectedColor,
                      onColorChanged: (c) =>
                          setState(() => _controller.selectColor(c)),
                      isColorAvailable: _controller.isColorAvailable,
                      selectedSwitch: s.selectedSwitch,
                      onSwitchChanged: (sw) =>
                          setState(() => _controller.selectSwitch(sw)),
                      isSwitchAvailable: _controller.isSwitchAvailable,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1, color: AppColors.borderDefault),
                    ),
                    const ProductSpecsSection(
                      description: 'كيبورد ميكانيكي بحجم 75% مع اتصال لاسلكي 2.4GHz و Bluetooth وسلكي USB-C. إضاءة RGB قابلة للتخصيص، وبطارية تدوم حتى 40 ساعة. مناسب للمبرمجين والطلاب.',
                      specs: _specs,
                    ),
                    const SizedBox(height: 16),
                    _buildRatingNote(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProductDetailsBottomBar(
        quantity: s.quantity,
        maxStock: stockQty,
        inStock: inStock,
        onIncrement: () => setState(() => _controller.incrementQuantity()),
        onDecrement: () => setState(() => _controller.decrementQuantity()),
        onAddToCart: _addToCart,
      ),
    );
  }

  Widget _buildRatingNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.subtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star_outline_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'يمكنك تقييم المنتج بالنجوم بعد استلام طلبك',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
