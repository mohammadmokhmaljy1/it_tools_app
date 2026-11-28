import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:it_tools_app/core/utils/result.dart';

import '../../domain/entities/product_details_entities.dart';
import 'catalog_providers.dart';

final productDetailsProvider = FutureProvider.autoDispose
    .family<ProductDetailsEntity, String>((ref, idOrSlug) async {
      final repository = ref.watch(catalogRepositoryProvider);
      final result = await repository.getProductDetails(idOrSlug);

      return switch (result) {
        Success(:final data) => data,
        Error(:final failure) => throw Exception(
          mapCatalogFailureMessage(failure),
        ),
      };
    });

final offerDetailsProvider = FutureProvider.autoDispose
    .family<OfferDetailsEntity, String>((ref, offerId) async {
      final repository = ref.watch(catalogRepositoryProvider);
      final result = await repository.getOfferDetails(offerId);

      return switch (result) {
        Success(:final data) => data,
        Error(:final failure) => throw Exception(
          mapCatalogFailureMessage(failure),
        ),
      };
    });

class VariantSelectionState {
  final Map<String, String> selectedAttributeValues;
  final ProductVariantEntity? selectedVariant;
  final int quantity;

  const VariantSelectionState({
    this.selectedAttributeValues = const {},
    this.selectedVariant,
    this.quantity = 1,
  });

  int get maxStock => selectedVariant?.stockQty ?? 0;
  bool get canAddToCart =>
      selectedVariant != null &&
      selectedVariant!.inStock &&
      maxStock > 0 &&
      quantity > 0;
}

class VariantSelectionController {
  final ProductDetailsEntity product;
  VariantSelectionState state;

  VariantSelectionController(this.product)
    : state = const VariantSelectionState() {
    _initDefault();
  }

  void _initDefault() {
    final defVariant = product.defaultVariant;
    final initialMap = <String, String>{};

    if (defVariant != null) {
      for (final attr in product.attributes) {
        for (final val in attr.values) {
          if (defVariant.attributeValueIds.contains(val.id)) {
            initialMap[attr.id] = val.id;
            break;
          }
        }
      }
    }

    final initialQty =
        (defVariant != null && defVariant.inStock && defVariant.stockQty > 0)
        ? 1
        : 0;

    state = VariantSelectionState(
      selectedAttributeValues: initialMap,
      selectedVariant: defVariant,
      quantity: initialQty,
    );
  }

  void selectAttributeValue(String attributeId, String valueId) {
    final updatedMap = Map<String, String>.from(state.selectedAttributeValues)
      ..[attributeId] = valueId;

    ProductVariantEntity? matchedVariant;
    for (final variant in product.variants) {
      final matchesAll = updatedMap.values.every(
        (selectedId) => variant.attributeValueIds.contains(selectedId),
      );
      if (matchesAll) {
        matchedVariant = variant;
        break;
      }
    }

    matchedVariant ??= product.variants
        .cast<ProductVariantEntity?>()
        .firstWhere(
          (v) => v!.attributeValueIds.contains(valueId),
          orElse: () => state.selectedVariant,
        );

    final stock = matchedVariant?.stockQty ?? 0;
    final isAvailable = (matchedVariant?.inStock ?? false) && stock > 0;
    final nextQty = !isAvailable
        ? 0
        : (state.quantity < 1 ? 1 : state.quantity.clamp(1, stock));

    state = VariantSelectionState(
      selectedAttributeValues: updatedMap,
      selectedVariant: matchedVariant,
      quantity: nextQty,
    );
  }

  void incrementQuantity() {
    if (!state.canAddToCart) return;
    if (state.quantity < state.maxStock) {
      state = VariantSelectionState(
        selectedAttributeValues: state.selectedAttributeValues,
        selectedVariant: state.selectedVariant,
        quantity: state.quantity + 1,
      );
    }
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      state = VariantSelectionState(
        selectedAttributeValues: state.selectedAttributeValues,
        selectedVariant: state.selectedVariant,
        quantity: state.quantity - 1,
      );
    }
  }
}
