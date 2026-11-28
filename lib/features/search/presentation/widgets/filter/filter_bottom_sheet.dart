import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:it_tools_app/features/catalog/domain/entities/product_search_entities.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_search_providers.dart';
import 'package:it_tools_app/features/search/presentation/widgets/filter/filter_chips_group.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  static const Map<String, String> _sortOptions = {
    'الأحدث': 'newest',
    'السعر: الأقل أولاً': 'price_asc',
    'السعر: الأعلى أولاً': 'price_desc',
  };

  late RangeValues _priceRange;
  String? _selectedBrandName;
  String _selectedSortLabel = 'الأحدث';
  bool _onlyAvailable = false;

  @override
  void initState() {
    super.initState();
    final currentQuery = ref.read(productsProvider).query;
    final start = (currentQuery.minPrice ?? 1).toDouble().clamp(1.0, 150.0);
    final end = (currentQuery.maxPrice ?? 150).toDouble().clamp(start, 150.0);
    _priceRange = RangeValues(start, end);
    _onlyAvailable = currentQuery.inStock ?? false;

    for (final entry in _sortOptions.entries) {
      if (entry.value == currentQuery.sort) {
        _selectedSortLabel = entry.key;
        break;
      }
    }

    final brands = ref.read(brandsProvider).value ?? const <BrandEntity>[];
    for (final brand in brands) {
      if (brand.id == currentQuery.brandId) {
        _selectedBrandName = brand.name;
        break;
      }
    }
  }

  void _resetFilters() {
    final currentQuery = ref.read(productsProvider).query;
    ref
        .read(productsProvider.notifier)
        .loadInitial(
          ProductQuery(categoryId: currentQuery.categoryId, q: currentQuery.q),
        );
    Navigator.pop(context);
  }

  void _applyFilters(List<BrandEntity> brands) {
    final currentQuery = ref.read(productsProvider).query;
    String? brandId;
    if (_selectedBrandName != null) {
      for (final brand in brands) {
        if (brand.name == _selectedBrandName) {
          brandId = brand.id;
          break;
        }
      }
    }

    final updatedQuery = ProductQuery(
      categoryId: currentQuery.categoryId,
      q: currentQuery.q,
      brandId: brandId,
      minPrice: _priceRange.start.round(),
      maxPrice: _priceRange.end.round(),
      inStock: _onlyAvailable ? true : null,
      sort: _sortOptions[_selectedSortLabel],
    );

    ref.read(productsProvider.notifier).loadInitial(updatedQuery);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final brandsAsync = ref.watch(brandsProvider);
    final brands = brandsAsync.value ?? const <BrandEntity>[];
    final brandNames = brands.map((b) => b.name).toList();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderDefault,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تصفية النتائج',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderStrong),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'السعر (USD)',
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            RangeSlider(
              values: _priceRange,
              min: 1,
              max: 150,
              activeColor: AppColors.blue,
              inactiveColor: AppColors.subtle,
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${_priceRange.start.round()}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '\$${_priceRange.end.round()}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            FilterChipsGroup(
              title: 'الترتيب حسب',
              options: _sortOptions.keys.toList(),
              selectedOptions: {_selectedSortLabel},
              onToggle: (val) => setState(() => _selectedSortLabel = val),
            ),
            if (brandNames.isNotEmpty) ...[
              const SizedBox(height: 18),
              FilterChipsGroup(
                title: 'العلامة التجارية',
                options: brandNames,
                selectedOptions: _selectedBrandName != null
                    ? {_selectedBrandName!}
                    : {},
                onToggle: (val) => setState(() {
                  _selectedBrandName = _selectedBrandName == val ? null : val;
                }),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عرض المتوفر فقط',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Switch(
                  value: _onlyAvailable,
                  activeThumbColor: AppColors.surface,
                  activeTrackColor: AppColors.blue,
                  onChanged: (val) => setState(() => _onlyAvailable = val),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () => _applyFilters(brands),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.actionPrimary,
                      foregroundColor: AppColors.onBrand,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'تطبيق التصفية',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.onBrand,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: _resetFilters,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.subtle,
                      foregroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'إعادة تعيين',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
