class FavoritesMockData {
  static final List<Map<String, dynamic>> items = [
    {
      'name': 'كيبورد ميكانيكي 75% أزرق/أبيض',
      'category': 'كيبورد',
      'price': '\$33.60',
      'oldPrice': '\$19.00',
      'discount': '-20%',
      'rating': '4.8',
      'reviewsCount': '128',
      'image': 'assets/images/products/keyboard_mech.png',
      'isAvailable': true,
      'isFavorite': true,
    },
    {
      'name': 'سماعة ألعاب مع مايك',
      'category': 'سماعات',
      'price': '\$35.00',
      'rating': '4.8',
      'reviewsCount': '128',
      'image': 'assets/images/products/headset_gaming.png',
      'isAvailable': true,
      'isFavorite': true,
    },
    {
      'name': 'هب USB-C بسبعة منافذ',
      'category': 'هب USB',
      'price': '\$24.00',
      'rating': '4.8',
      'reviewsCount': '128',
      'image': 'assets/images/products/usb_hub.png',
      'isAvailable': true,
      'isFavorite': true,
    },
    {
      'name': 'ستيكرات لابتوب للمبرمجين 20 قطعة',
      'category': 'ستيكرات',
      'price': '\$4.00',
      'rating': '4.8',
      'reviewsCount': '128',
      'image': 'assets/images/products/stickers_dev.png',
      'isAvailable': true,
      'isFavorite': true,
    },
  ];

  static bool isFavorite(String productName) {
    return items.any((element) => element['name'] == productName);
  }

  static void toggleFavorite(Map<String, dynamic> product) {
    final index = items.indexWhere(
      (element) => element['name'] == product['name'],
    );
    if (index >= 0) {
      items.removeAt(index);
    } else {
      final newProduct = Map<String, dynamic>.from(product);
      newProduct['isFavorite'] = true;
      items.add(newProduct);
    }
  }
}
