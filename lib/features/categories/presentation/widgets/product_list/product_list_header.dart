import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class ProductListHeader extends StatefulWidget {
  final String categoryName;
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final int productCount;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;

  const ProductListHeader({
    super.key,
    required this.categoryName,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.productCount,
    this.onFilterTap,
    this.onSortTap,
  });

  @override
  State<ProductListHeader> createState() => _ProductListHeaderState();
}

class _ProductListHeaderState extends State<ProductListHeader> {
  String _activeAction = ''; // 'filter' أو 'sort'

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconBtn(Icons.arrow_back_ios_new_rounded, () {
                if (context.canPop()) context.pop();
              }),
              Text(
                widget.categoryName,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              _iconBtn(Icons.search_rounded, () {
                context.push(AppRouter.search);
              }),
            ],
          ),
        ),
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: widget.tabs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final active = widget.selectedIndex == i;
              return GestureDetector(
                onTap: () => widget.onTabSelected(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? AppColors.blue : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: active ? AppColors.blue : AppColors.borderDefault,
                    ),
                  ),
                  child: Text(
                    widget.tabs[i],
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: active
                          ? AppColors.onBrand
                          : AppColors.textSecondary,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.productCount} منتج',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              Row(
                children: [
                  _chipBtn(
                    icon: Icons.tune_rounded,
                    label: 'تصفية',
                    isSelected: _activeAction == 'filter',
                    onTap: () {
                      setState(() => _activeAction = 'filter');
                      widget.onFilterTap?.call();
                    },
                  ),
                  const SizedBox(width: 8),
                  _chipBtn(
                    icon: Icons.swap_vert_rounded,
                    label: 'الأحدث',
                    isSelected: _activeAction == 'sort',
                    onTap: () {
                      setState(() => _activeAction = 'sort');
                      widget.onSortTap?.call();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _chipBtn({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.infoBg : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.borderDefault,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.blue : AppColors.textPrimary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.blue : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
