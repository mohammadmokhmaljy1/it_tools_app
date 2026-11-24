import 'package:it_tools_app/core/constants/app_assets.dart';

class HomeMockData {
  static final List<Map<String, dynamic>> dailyDeals = [
    {
      'title': 'كيبورد ميكانيكي 75% أزرق/أبيض',
      'category': 'كيبورد',
      'price': '\$33.60',
      'oldPrice': '\$42.00',
      'image': AppAssets.productKeyboard,
      'discount': '-20%',
      'isFavorite': false,
      'isOutOfStock': false,
    },
    {
      'title': 'سماعة ألعاب مع مايك',
      'category': 'سماعات',
      'price': '\$28.00',
      'oldPrice': '\$35.00',
      'image': AppAssets.productHeadset,
      'discount': '-20%',
      'isFavorite': false,
      'isOutOfStock': false,
    },
  ];

  static final List<Map<String, dynamic>> bestSellers = [
    {
      'title': 'ماوس لاسلكي صامت M331',
      'category': 'ماوس',
      'price': '\$19.00',
      'oldPrice': null,
      'image': AppAssets.productMouse,
      'discount': null,
      'isFavorite': false,
      'isOutOfStock': false,
    },
    {
      'title': 'ماوس باد كبير XL كحلي',
      'category': 'ماوس باد',
      'price': '\$9.50',
      'oldPrice': null,
      'image': AppAssets.productMousepad,
      'discount': null,
      'isFavorite': false,
      'isOutOfStock': false,
    },
    {
      'title': 'ستيكرات لابتوب للمبرمجين 20 قطعة',
      'category': 'ستيكرات',
      'price': '\$4.00',
      'oldPrice': null,
      'image': AppAssets.productStickers,
      'discount': null,
      'isFavorite': false,
      'isOutOfStock': false,
    },
    {
      'title': 'ستاند لابتوب ألمنيوم قابل للطي',
      'category': 'ستاند',
      'price': '\$22.00',
      'oldPrice': null,
      'image': AppAssets.productStand,
      'discount': null,
      'isFavorite': false,
      'isOutOfStock': true,
    },
  ];
}
