class ProductListMockData {
  static List<Map<String, dynamic>> getProducts(String categoryName) {
    final allProducts = [
      // 1. قسم الماوسات
      {
        'name': 'ماوس لاسلكي صامت M331',
        'category': 'ماوس',
        'sub': 'لاسلكي',
        'price': '\$19.00',
        'rating': '4.8',
        'reviewsCount': '128',
        'image': 'assets/images/products/mouse_silent.png',
        'isAvailable': true,
        'isFavorite': false,
      },
      {
        'name': 'ماوس باد XL مبطن للمكاتب والألعاب',
        'category': 'ماوس',
        'sub': 'ألعاب',
        'price': '\$12.00',
        'oldPrice': '\$15.00',
        'discount': '-20%',
        'rating': '4.7',
        'reviewsCount': '94',
        'image': 'assets/images/products/mousepad_xl.png',
        'isAvailable': true,
        'isFavorite': false,
      },

      // 2. قسم الكيبوردات
      {
        'name': 'كيبورد ميكانيكي 75% لاسلكي بإضاءة RGB',
        'category': 'كيبورد',
        'sub': 'لاسلكي',
        'price': '\$33.60',
        'oldPrice': '\$42.00',
        'discount': '-20%',
        'rating': '4.7',
        'reviewsCount': '86',
        'image': 'assets/images/products/keyboard_mech.png',
        'isAvailable': true,
        'isFavorite': false,
      },

      // 3. قسم السماعات
      {
        'name': 'سماعة ألعاب محيطية RGB',
        'category': 'سماعات',
        'sub': 'ألعاب',
        'price': '\$28.00',
        'oldPrice': '\$35.00',
        'discount': '-20%',
        'rating': '4.9',
        'reviewsCount': '95',
        'image': 'assets/images/products/headset_gaming.png',
        'isAvailable': true,
        'isFavorite': false,
      },

      // 4. قسم التبريد والحوامل
      {
        'name': 'قاعدة تبريد لابتوب بمروحتين LED',
        'category': 'تبريد',
        'sub': 'مكتبي',
        'price': '\$22.50',
        'rating': '4.6',
        'reviewsCount': '64',
        'image': 'assets/images/products/cooling_pad.png',
        'isAvailable': true,
        'isFavorite': false,
      },
      {
        'name': 'حامل لابتوب ألمنيوم قابل للطي',
        'category': 'ستاند',
        'sub': 'مكتبي',
        'price': '\$18.00',
        'rating': '4.8',
        'reviewsCount': '110',
        'image': 'assets/images/products/stand_laptop.png',
        'isAvailable': true,
        'isFavorite': false,
      },

      // 5. قسم الكابلات والمحولات والإكسسوارات
      {
        'name': 'موزع منافذ USB-C Hub 7 في 1',
        'category': 'هب USB',
        'sub': 'مكتبي',
        'price': '\$24.00',
        'rating': '4.8',
        'reviewsCount': '112',
        'image': 'assets/images/products/usb_hub.png',
        'isAvailable': true,
        'isFavorite': false,
      },
      {
        'name': 'حزمة ملصقات برمجية للمطورين',
        'category': 'إكسسوارات',
        'sub': 'مكتبي',
        'price': '\$4.50',
        'rating': '4.9',
        'reviewsCount': '210',
        'image': 'assets/images/products/stickers_dev.png',
        'isAvailable': true,
        'isFavorite': false,
      },
    ];

    if (categoryName == 'الكل' || categoryName.isEmpty) {
      return allProducts;
    }

    final filtered = allProducts
        .where(
          (p) =>
              categoryName.contains(p['category'] as String) ||
              (p['category'] as String).contains(categoryName),
        )
        .toList();

    return filtered.isNotEmpty ? filtered : allProducts;
  }
}
