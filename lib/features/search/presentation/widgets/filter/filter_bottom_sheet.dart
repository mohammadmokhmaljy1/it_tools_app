import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/search/presentation/widgets/filter/filter_chips_group.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(10, 40);
  final Set<String> _selectedConnections = {'لاسلكي'};
  final Set<String> _selectedBrands = {'Logitech', 'Redragon'};
  String _selectedRating = '4 ★ فأكثر';
  bool _onlyAvailable = true;

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(10, 40);
      _selectedConnections.clear();
      _selectedBrands.clear();
      _selectedRating = 'الكل';
      _onlyAvailable = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // مقبض السحب العلوي
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

            // العنوان وزر الإغلاق (X)
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

            // قسم السعر
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
              min: 5,
              max: 100,
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

            // نوع الاتصال
            FilterChipsGroup(
              title: 'نوع الاتصال',
              options: const ['Bluetooth', 'سلكي', 'لاسلكي'],
              selectedOptions: _selectedConnections,
              onToggle: (val) => setState(() {
                _selectedConnections.contains(val)
                    ? _selectedConnections.remove(val)
                    : _selectedConnections.add(val);
              }),
            ),
            const SizedBox(height: 18),

            // العلامة التجارية
            FilterChipsGroup(
              title: 'العلامة التجارية',
              options: const ['A4Tech', 'HP', 'Razer', 'Logitech', 'Redragon'],
              selectedOptions: _selectedBrands,
              onToggle: (val) => setState(() {
                _selectedBrands.contains(val)
                    ? _selectedBrands.remove(val)
                    : _selectedBrands.add(val);
              }),
            ),
            const SizedBox(height: 18),

            // التقييم
            FilterChipsGroup(
              title: 'التقييم',
              options: const ['الكل', '3 ★ فأكثر', '4 ★ فأكثر'],
              selectedOptions: {_selectedRating},
              onToggle: (val) => setState(() => _selectedRating = val),
            ),
            const SizedBox(height: 16),

            // زر التبديل: عرض المتوفر فقط
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

            // الزران السفليان: عرض المنتجات + إعادة تعيين
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
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
                      'عرض 12 منتج',
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
