import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/catalog/domain/entities/product_details_entities.dart';

class ProductVariantsSection extends StatelessWidget {
  final List<ProductAttributeEntity> attributes;
  final List<ProductVariantEntity> variants;
  final Map<String, String> selectedAttributeValues;
  final void Function(String attributeId, String valueId) onAttributeSelected;

  const ProductVariantsSection({
    super.key,
    required this.attributes,
    required this.variants,
    required this.selectedAttributeValues,
    required this.onAttributeSelected,
  });

  Color _parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.textTertiary;
    final cleaned = hex.replaceFirst('#', '');
    if (cleaned.length == 6) {
      final parsed = int.tryParse('FF$cleaned', radix: 16);
      if (parsed != null) return Color(parsed);
    }
    return AppColors.textTertiary;
  }

  bool _isValueAvailable(String valueId) {
    if (variants.isEmpty) return true;
    return variants.any(
      (v) =>
          v.attributeValueIds.contains(valueId) && v.inStock && v.stockQty > 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (attributes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < attributes.length; i++) ...[
          if (i > 0) const SizedBox(height: 20),
          _buildAttributeGroup(attributes[i]),
        ],
      ],
    );
  }

  Widget _buildAttributeGroup(ProductAttributeEntity attribute) {
    final selectedValueId = selectedAttributeValues[attribute.id];
    String selectedLabel = '';
    for (final val in attribute.values) {
      if (val.id == selectedValueId) {
        selectedLabel = val.value;
        break;
      }
    }

    final isColor = attribute.displayType == 'color';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(attribute.name, style: AppTextStyles.titleLarge),
            if (selectedLabel.isNotEmpty)
              Text(
                selectedLabel,
                style: AppTextStyles.captionStrong.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (isColor)
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: attribute.values.map((val) {
              final bool isSelected = val.id == selectedValueId;
              final bool isAvailable = _isValueAvailable(val.id);
              final Color circleColor = _parseHexColor(val.colorHex);

              return GestureDetector(
                onTap: () => onAttributeSelected(attribute.id, val.id),
                child: Opacity(
                  opacity: isAvailable ? 1.0 : 0.45,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: circleColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: attribute.values.map((val) {
              final bool isSelected = val.id == selectedValueId;
              final bool isAvailable = _isValueAvailable(val.id);

              return GestureDetector(
                onTap: () => onAttributeSelected(attribute.id, val.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.blue
                        : (isAvailable ? AppColors.surface : AppColors.pageBg),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.blue
                          : AppColors.borderDefault,
                    ),
                  ),
                  child: Text(
                    isAvailable ? val.value : 'غير متوفر · ${val.value}',
                    style: AppTextStyles.captionStrong.copyWith(
                      color: isSelected
                          ? AppColors.onBrand
                          : (isAvailable
                                ? AppColors.textPrimary
                                : AppColors.textTertiary),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
