import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class ProductVariantsSection extends StatelessWidget {
  final int selectedColorIndex;
  final ValueChanged<int> onColorChanged;
  final String selectedSwitch;
  final ValueChanged<String> onSwitchChanged;

  const ProductVariantsSection({
    super.key,
    required this.selectedColorIndex,
    required this.onColorChanged,
    required this.selectedSwitch,
    required this.onSwitchChanged,
  });

  static const List<Map<String, dynamic>> colorOptions = [
    {'name': 'أسود مطفي', 'color': AppColors.textTertiary},
    {'name': 'أبيض ثلجي', 'color': AppColors.pageBg},
    {'name': 'أزرق / أبيض', 'color': AppColors.navy700},
  ];

  static const List<Map<String, dynamic>> switchOptions = [
    {'label': 'Brown', 'desc': 'تكتيلي متوازن · Brown', 'available': true},
    {'label': 'Blue', 'desc': 'خطّي ومريح للكتابة · Blue', 'available': true},
    {'label': 'Red', 'desc': 'سريع وخفيف للألعاب · Red', 'available': true},
    {
      'label': 'غير متوفر · Silver',
      'desc': 'غير متوفر حالياً',
      'available': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentColorName = colorOptions[selectedColorIndex]['name'] as String;
    final currentSwitchDesc =
        switchOptions.firstWhere(
              (s) => s['label'] == selectedSwitch,
              orElse: () => switchOptions[1],
            )['desc']
            as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. قسم اختيار اللون
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('اللون', style: AppTextStyles.titleLarge),
            Text(
              currentColorName,
              style: AppTextStyles.captionStrong.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(colorOptions.length, (index) {
            final bool isSelected = index == selectedColorIndex;
            final Color circleColor = colorOptions[index]['color'] as Color;
            return GestureDetector(
              onTap: () => onColorChanged(index),
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
            );
          }),
        ),
        const SizedBox(height: 20),

        // 2. قسم اختيار نوع السويتش
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
            final String label = option['label'] as String;
            final bool isAvailable = option['available'] as bool;
            final bool isSelected = label == selectedSwitch;

            return GestureDetector(
              onTap: isAvailable ? () => onSwitchChanged(label) : null,
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
                  label,
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
