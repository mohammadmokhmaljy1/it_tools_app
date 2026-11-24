class CartMockData {
  static final List<Map<String, dynamic>> items = [
    {
      'name': 'كيبورد ميكانيكي 75% لاسلكي',
      'variant': 'اللون: كحلي · السويتش',
      'price': 33.60,
      'oldPrice': 42.00,
      'quantity': 1,
      'image': 'assets/images/products/keyboard_mech.png',
    },
    {
      'name': 'ماوس لاسلكي صامت M331',
      'variant': 'اللون: أسود',
      'price': 19.00,
      'oldPrice': 19.00,
      'quantity': 2,
      'image': 'assets/images/products/mouse_silent.png',
    },
    {
      'name': 'سماعة ألعاب مع مايك',
      'variant': 'اللون: أسود/أزرق',
      'price': 35.00,
      'oldPrice': 35.00,
      'quantity': 1,
      'image': 'assets/images/products/headset_gaming.png',
    },
  ];

  static void addItem(Map<String, dynamic> product) {
    final String name = (product['name'] ?? product['title'] ?? '') as String;
    final index = items.indexWhere((e) => e['name'] == name);
    if (index >= 0) {
      items[index]['quantity'] = (items[index]['quantity'] as int) + 1;
    } else {
      final rawPrice = product['price'].toString().replaceAll('\$', '');
      final double parsedPrice = double.tryParse(rawPrice) ?? 15.0;
      items.add({
        'name': name,
        'variant': 'اللون: أسود',
        'price': parsedPrice,
        'oldPrice': parsedPrice,
        'quantity': 1,
        'image': product['image'],
      });
    }
  }
}
