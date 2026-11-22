import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/cart_items/cart_mock_data.dart';
import 'package:it_tools_app/features/catalog/presentation/widgets/product_details_bottom_bar.dart';
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
  int _selectedColorIndex = 2;
  String _selectedSwitch = 'Blue';
  int _quantity = 1;

  String get _name =>
      (widget.product?['name'] as String?) ??
      'كيبورد ميكانيكي 75% لاسلكي بإضاءة RGB';
  String get _category =>
      (widget.product?['category'] as String?) ?? 'كيبورد · Redragon';
  double get _price => ((widget.product?['price'] ?? 33.60) as num).toDouble();
  double get _oldPrice =>
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

  void _addToCart() {
    final colorName =
        ProductVariantsSection.colorOptions[_selectedColorIndex]['name']
            as String;
    CartMockData.addItem({
      'name': _name,
      'variant': 'اللون: $colorName · السويتش: $_selectedSwitch',
      'price': _price,
      'oldPrice': _oldPrice,
      'image': _mainImage,
      'quantity': _quantity,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة $_name ($_quantity) إلى السلة'),
        backgroundColor: AppColors.navy900,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderAndPrice(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Divider(height: 1, color: AppColors.borderDefault),
                    ),
                    ProductVariantsSection(
                      selectedColorIndex: _selectedColorIndex,
                      onColorChanged: (i) =>
                          setState(() => _selectedColorIndex = i),
                      selectedSwitch: _selectedSwitch,
                      onSwitchChanged: (s) =>
                          setState(() => _selectedSwitch = s),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1, color: AppColors.borderDefault),
                    ),
                    const ProductSpecsSection(
                      description: 'كيبورد ميكانيكي بحجم 75% مع اتصال لاسلكي 2.4GHz و Bluetooth وسلكي USB-C. إضاءة RGB قابلة للتخصيص، وبطارية تدوم حتى 40 ساعة. مناسب للمبرمجين والطلاب.',
                      specs: _specs,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProductDetailsBottomBar(
        quantity: _quantity,
        onIncrement: () => setState(() => _quantity++),
        onDecrement: () {
          if (_quantity > 1) setState(() => _quantity--);
        },
        onAddToCart: _addToCart,
      ),
    );
  }

  Widget _buildHeaderAndPrice() {
    final String categoryLabel = _category.contains('·')
        ? _category
        : '$_category · Redragon';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. التصنيف على اليمين + النجمة والتقييم على اليسار
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryLabel,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: AppColors.orange,
                ),
                const SizedBox(width: 4),
                Text('4.7', style: AppTextStyles.captionStrong),
                const SizedBox(width: 4),
                Text('(86 تقييم)', style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 2. اسم المنتج
        Text(_name, style: AppTextStyles.headingH2),
        const SizedBox(height: 10),

        // 3. السعر الحالي على اليمين + السعر القديم وشارة -20% على اليسار
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_price.toStringAsFixed(2)}',
              style: AppTextStyles.priceLarge,
            ),
            Row(
              children: [
                Text(
                  '\$${_oldPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '-20%',
                    style: AppTextStyles.captionStrong.copyWith(
                      color: AppColors.navy900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 4. الشريط الأخضر لحالة التوفر
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.successBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 16,
                color: AppColors.success,
              ),
              const SizedBox(width: 8),
              Text(
                'متوفر · بقي 5 قطع فقط من هذا الخيار',
                style: AppTextStyles.captionStrong.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
