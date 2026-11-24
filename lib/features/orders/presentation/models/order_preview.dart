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
