import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_details_providers.dart';

void main() {
  group('VariantSelectionController stock rules', () {
    test(
      '1. المتغير المتوفر: يختاره تلقائياً ويقيد الكمية بالمخزون المتاح',
      () {
        final controller = VariantSelectionController(const [
          ProductVariantOption(
            id: 'v1',
            sku: 'SKU-1',
            colorName: 'أزرق / أبيض',
            switchType: 'Blue',
            price: 33.6,
            oldPrice: 42.0,
            stockQty: 3,
          ),
        ]);

        expect(controller.state.selectedVariant?.id, 'v1');
        expect(controller.state.canAddToCart, isTrue);
        expect(controller.state.quantity, 1);

        controller.incrementQuantity();
        controller.incrementQuantity();
        controller.incrementQuantity();
        expect(controller.state.quantity, 3);
      },
    );

    test('2. متغير نافد (مخزون 0): يعطّل الإضافة للسلة ويجعل الكمية 0', () {
      final controller = VariantSelectionController(const [
        ProductVariantOption(
          id: 'v1',
          sku: 'SKU-1',
          colorName: 'أزرق / أبيض',
          switchType: 'Blue',
          price: 33.6,
          oldPrice: 42.0,
          stockQty: 5,
        ),
        ProductVariantOption(
          id: 'v2',
          sku: 'SKU-2',
          colorName: 'أزرق / أبيض',
          switchType: 'Silver',
          price: 33.6,
          oldPrice: 42.0,
          stockQty: 0,
        ),
      ]);

      controller.selectSwitch('Silver');
      expect(controller.state.selectedVariant?.id, 'v2');
      expect(controller.state.canAddToCart, isFalse);
      expect(controller.state.quantity, 0);
    });

    test(
      '3. منتج نافد بالكامل: كل المتغيرات مخزونها 0 ولا يمكن الإضافة للسلة',
      () {
        final controller = VariantSelectionController(const [
          ProductVariantOption(
            id: 'v1',
            sku: 'SKU-1',
            colorName: 'أسود مطفي',
            switchType: 'Blue',
            price: 33.6,
            oldPrice: 42.0,
            stockQty: 0,
          ),
        ]);

        expect(controller.isProductOutOfStock, isTrue);
        expect(controller.state.canAddToCart, isFalse);
        expect(controller.state.quantity, 0);
      },
    );
  });
}
