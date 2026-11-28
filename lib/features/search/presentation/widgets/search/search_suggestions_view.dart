import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_search_providers.dart';

class SearchSuggestionsView extends StatelessWidget {
  final SearchSuggestionsState state;
  final String query;
  final ValueChanged<String> onSelectSuggestion;

  const SearchSuggestionsView({
    super.key,
    required this.state,
    required this.query,
    required this.onSelectSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final categories = state.suggestions.categories;
    final products = state.suggestions.products;

    if (categories.isEmpty && products.isEmpty) {
      return Center(
        child: Text(
          'اضغط على زر البحث في لوحة المفاتيح للبحث عن "${query.trim()}"',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        for (final cat in categories)
          ListTile(
            leading: const Icon(Icons.category_outlined, color: AppColors.blue),
            title: Text(cat.name, style: AppTextStyles.bodyMedium),
            subtitle: const Text('قسم'),
            onTap: () => onSelectSuggestion(cat.name),
          ),
        for (final prod in products)
          ListTile(
            leading: const Icon(Icons.search_rounded, color: AppColors.royal),
            title: Text(prod.name, style: AppTextStyles.bodyMedium),
            subtitle: Text(prod.brandName),
            onTap: () => onSelectSuggestion(prod.name),
          ),
      ],
    );
  }
}
