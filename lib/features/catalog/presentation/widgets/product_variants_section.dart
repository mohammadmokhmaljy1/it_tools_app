import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class ProductVariantsSection extends StatelessWidget {
  final String selectedColor;
  final ValueChanged<String> onColorChanged;
  final bool Function(String colorName) isColorAvailable;
  final String selectedSwitch;
  final ValueChanged<String> onSwitchChanged;
  final bool Function(String switchType) isSwitchAvailable;

  const ProductVariantsSection({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    required this.isColorAvailable,
    required this.selectedSwitch,
    required this.onSwitchChanged,
    required this.isSwitchAvailable,
  });

  static const List<Map<String, dynamic>> colorOptions = [
    {'name': 'أسود مطفي', 'color': AppColors.textTertiary},
    {'name': 'أبيض ثلجي', 'color': AppColors.pageBg},
    {'name': 'أزرق / أبيض', 'color': AppColors.navy700},
  ];

  static const List<Map<String, String>> switchOptions = [
    {'label': 'Brown', 'desc': 'تكتيلي متوازن · Brown'},
    {'label': 'Blue', 'desc': 'خطّي ومريح للكتابة · Blue'},
    {'label': 'Red', 'desc': 'سريع وخفيف للألعاب · Red'},
    {'label': 'Silver', 'desc': 'خفيف جداً · Silver'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentSwitchDesc = switchOptions.firstWhere(
      (s) => s['label'] == selectedSwitch,
      orElse: () => switchOptions[1],
    )['desc']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('اللون', style: AppTextStyles.titleLarge),
            Text(
              selectedColor,
              style: AppTextStyles.captionStrong.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: colorOptions.map((opt) {
            final String colorName = opt['name'] as String;
            final Color circleColor = opt['color'] as Color;
            final bool isSelected = colorName == selectedColor;
            final bool available = isColorAvailable(colorName);

            return GestureDetector(
              onTap: () => onColorChanged(colorName),
              child: Opacity(
                opacity: available ? 1.0 : 0.45,
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
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
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('نوع السويتش', style: AppTextStyles.titleLarge),
            Text(
              currentSwitchDesc,
              style: AppTextStyles.captionStrong.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: switchOptions.map((option) {
            final String label = option['label']!;
            final bool available = isSwitchAvailable(label);
            final bool isSelected = label == selectedSwitch;

            return GestureDetector(
              onTap: () => onSwitchChanged(label),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.blue
                      : (available ? AppColors.surface : AppColors.pageBg),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.blue
                        : AppColors.borderDefault,
                  ),
                ),
                child: Text(
                  available ? label : 'غير متوفر · $label',
                  style: AppTextStyles.captionStrong.copyWith(
                    color: isSelected
                        ? AppColors.onBrand
                        : (available
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
