import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class CheckoutAddressForm extends StatelessWidget {
  final String selectedCity;
  final ValueChanged<String?> onCityChanged;
  final TextEditingController areaController;
  final TextEditingController streetController;
  final TextEditingController phoneController;

  const CheckoutAddressForm({
    super.key,
    required this.selectedCity,
    required this.onCityChanged,
    required this.areaController,
    required this.streetController,
    required this.phoneController,
  });

  static const List<String> syrianCities = [
    'حلب',
    'دمشق',
    'ريف دمشق',
    'حمص',
    'حماة',
    'اللاذقية',
    'طرطوس',
    'إدلب',
    'دير الزور',
    'الحسكة',
    'الرقة',
    'درعا',
    'السويداء',
    'القنيطرة',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('عنوان التوصيل', style: AppTextStyles.headingH3),
        const SizedBox(height: 14),

        // 1. المحافظة (قائمة منسدلة)
        // 1. المحافظة (قائمة منسدلة أنيقة بعرض محدد)
        Text('المحافظة', style: AppTextStyles.labelMedium),
        const SizedBox(height: 6),
        PopupMenuButton<String>(
          initialValue: selectedCity,
          onSelected: onCityChanged,
          color: AppColors.surface,
          elevation: 6,
          offset: const Offset(0, 52),
          constraints: const BoxConstraints(
            minWidth: 180,
            maxWidth: 200,
            maxHeight: 280,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.borderDefault),
          ),
          itemBuilder: (context) => syrianCities.map((city) {
            final bool isSelected = city == selectedCity;
            return PopupMenuItem<String>(
              value: city,
              height: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    city,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.blue
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: AppColors.blue,
                    ),
                ],
              ),
            );
          }).toList(),
          child: Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(selectedCity, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 2. المنطقة / الحي
        _inputField(
          label: 'المنطقة / الحي',
          controller: areaController,
          icon: Icons.location_on_outlined,
          hint: 'مثال: الفرقان',
        ),
        const SizedBox(height: 14),

        // 3. العنوان التفصيلي
        _inputField(
          label: 'العنوان التفصيلي',
          controller: streetController,
          icon: Icons.edit_location_alt_outlined,
          hint: 'الشارع، البناء، الطابق...',
        ),
        const SizedBox(height: 14),

        // 4. رقم الموبايل للتواصل
        _inputField(
          label: 'رقم الموبايل للتواصل',
          controller: phoneController,
          icon: Icons.phone_outlined,
          hint: '09XX XXX XXX',
          keyboardType: TextInputType.phone,
          isLtrText: true,
        ),
      ],
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isLtrText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textDirection: isLtrText ? TextDirection.ltr : TextDirection.rtl,
          textAlign: TextAlign.right,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: AppColors.textTertiary),
          ),
        ),
      ],
    );
  }
}
