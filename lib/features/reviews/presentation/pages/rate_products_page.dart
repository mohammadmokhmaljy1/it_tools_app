
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRatingItem {
  final String name;
  final String assetPath;
  int rating;

  ProductRatingItem({
    required this.name,
    required this.assetPath,
    this.rating = 0,
  });
}

class RateProductsPage extends ConsumerStatefulWidget {
  final List<ProductRatingItem> products;

  const RateProductsPage({
    super.key,
    required this.products,
  });

  @override
  ConsumerState<RateProductsPage> createState() => _RateProductsPageState();
}

class _RateProductsPageState extends ConsumerState<RateProductsPage> {
  late final List<ProductRatingItem> _items;

  @override
  void initState() {
    super.initState();

    // نسخة محلية من منتجات الطلب حتى نحدّث التقييم داخل الصفحة
    _items = widget.products.map((product) {
      return ProductRatingItem(
        name: product.name,
        assetPath: product.assetPath,
        rating: product.rating,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBFF),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'قيّم مشترياتك',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD0E1ED)),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF1E293B),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صندوق الملاحظة الإرشادية
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'التقييم متاح فقط للمنتجات التي استلمتها. يمكنك تعديل تقييمك لاحقاً.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF1E3A8A),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.star_border,
                      color: Color(0xFF0578B7),
                      size: 22,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // بطاقات منتجات الطلب المكتمل
              if (_items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'لا توجد منتجات لتقييمها.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                )
              else
                ...List.generate(_items.length, (index) {
                  final item = _items[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: _buildRatingCard(item),
                  );
                }),

              const SizedBox(height: 10),

              // زر حفظ التقييم
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _items.isEmpty
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تم حفظ تقييماتك بنجاح',
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0578B7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'حفظ التقييم',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingCard(ProductRatingItem item) {
    final bool isRated = item.rating > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isRated ? 'تم التقييم' : 'لم تُقيّم بعد',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isRated
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4FBFF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2EEF5)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    item.assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 24,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (starIndex) {
              final starValue = starIndex + 1;
              final isSelected = starValue <= item.rating;

              return InkWell(
                onTap: () {
                  setState(() {
                    item.rating = starValue;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    isSelected
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 34,
                    color: isSelected
                        ? const Color(0xFFF5B800)
                        : const Color(0xFF7CB9E8),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
