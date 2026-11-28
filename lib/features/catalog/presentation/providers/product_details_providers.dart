class ProductVariantOption {
  final String id;
  final String sku;
  final String colorName;
  final String switchType;
  final double price;
  final double oldPrice;
  final int stockQty;

  const ProductVariantOption({
    required this.id,
    required this.sku,
    required this.colorName,
    required this.switchType,
    required this.price,
    required this.oldPrice,
    required this.stockQty,
  });

  bool get inStock => stockQty > 0;
}

class VariantSelectionState {
  final String selectedColor;
  final String selectedSwitch;
  final ProductVariantOption? selectedVariant;
  final int quantity;

  const VariantSelectionState({
    required this.selectedColor,
    required this.selectedSwitch,
    required this.selectedVariant,
    required this.quantity,
  });

  int get maxStock => selectedVariant?.stockQty ?? 0;

  bool get canAddToCart =>
      selectedVariant != null &&
      selectedVariant!.inStock &&
      maxStock > 0 &&
      quantity > 0;
}

class VariantSelectionController {
  final List<ProductVariantOption> variants;
  late VariantSelectionState state;

  VariantSelectionController(this.variants) {
    _initDefault();
  }

  bool get isProductOutOfStock => variants.every((v) => !v.inStock);

  void _initDefault() {
    if (variants.isEmpty) {
      state = const VariantSelectionState(
        selectedColor: '',
        selectedSwitch: '',
        selectedVariant: null,
        quantity: 0,
      );
      return;
    }

    final firstAvailable = variants.firstWhere(
      (v) => v.inStock,
      orElse: () => variants.first,
    );

    state = VariantSelectionState(
      selectedColor: firstAvailable.colorName,
      selectedSwitch: firstAvailable.switchType,
      selectedVariant: firstAvailable,
      quantity: firstAvailable.inStock ? 1 : 0,
    );
  }

  bool isColorAvailable(String colorName) {
    return variants.any(
      (v) =>
          v.colorName == colorName &&
          v.switchType == state.selectedSwitch &&
          v.inStock,
    );
  }

  bool isSwitchAvailable(String switchType) {
    return variants.any(
      (v) =>
          v.switchType == switchType &&
          v.colorName == state.selectedColor &&
          v.inStock,
    );
  }

  void selectColor(String colorName) {
    ProductVariantOption? exact = _findExact(colorName, state.selectedSwitch);
    if (exact == null || !exact.inStock) {
      exact = variants.cast<ProductVariantOption?>().firstWhere(
        (v) => v!.colorName == colorName && v.inStock,
        orElse: () => exact,
      );
    }
    _applyVariant(
      exact,
      color: exact?.colorName ?? colorName,
      sw: exact?.switchType ?? state.selectedSwitch,
    );
  }

  void selectSwitch(String switchType) {
    ProductVariantOption? exact = _findExact(state.selectedColor, switchType);
    if (exact == null || !exact.inStock) {
      exact = variants.cast<ProductVariantOption?>().firstWhere(
        (v) => v!.switchType == switchType && v.inStock,
        orElse: () => exact,
      );
    }
    _applyVariant(
      exact,
      color: exact?.colorName ?? state.selectedColor,
      sw: exact?.switchType ?? switchType,
    );
  }

  ProductVariantOption? _findExact(String color, String sw) {
    for (final v in variants) {
      if (v.colorName == color && v.switchType == sw) return v;
    }
    return null;
  }

  void _applyVariant(
    ProductVariantOption? variant, {
    required String color,
    required String sw,
  }) {
    final stock = variant?.stockQty ?? 0;
    final available = (variant?.inStock ?? false) && stock > 0;
    final nextQty = !available
        ? 0
        : (state.quantity < 1 ? 1 : state.quantity.clamp(1, stock));

    state = VariantSelectionState(
      selectedColor: color,
      selectedSwitch: sw,
      selectedVariant: variant,
      quantity: nextQty,
    );
  }

  void incrementQuantity() {
    if (!state.canAddToCart) return;
    if (state.quantity < state.maxStock) {
      state = VariantSelectionState(
        selectedColor: state.selectedColor,
        selectedSwitch: state.selectedSwitch,
        selectedVariant: state.selectedVariant,
        quantity: state.quantity + 1,
      );
    }
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      state = VariantSelectionState(
        selectedColor: state.selectedColor,
        selectedSwitch: state.selectedSwitch,
        selectedVariant: state.selectedVariant,
        quantity: state.quantity - 1,
      );
    }
  }
}
