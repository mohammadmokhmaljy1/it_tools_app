import '../../../../core/constants/app_assets.dart';

enum OrderPreview {
  newOrder('10482', 'جديد'),
  shipping('10481', 'قيد التوصيل'),
  completed('10480', 'مكتمل'),
  cancelled('10479', 'ملغي');

  const OrderPreview(this.id, this.label);

  final String id;
  final String label;

  static OrderPreview? fromId(String? id) {
    for (final order in values) {
      if (order.id == id) return order;
    }
    return null;
  }
}

const orderPreviewProducts = [
  (
    name: 'كيبورد ميكانيكي %75 لاسلكي',
    assetPath: AppAssets.productKeyboard,
    details: 'كحلي · 1 × Blue',
    price: '\$33.60',
  ),
  (
    name: 'ماوس لاسلكي صامت M331',
    assetPath: AppAssets.productMouse,
    details: 'أسود · 2 ×',
    price: '\$38.00',
  ),
  (
    name: 'سماعة ألعاب مع مايك',
    assetPath: AppAssets.productHeadset,
    details: 'أسود/أزرق · 1 ×',
    price: '\$35.00',
  ),
];
