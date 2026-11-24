import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_grid_card.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_list_mock_data.dart';
import 'package:it_tools_app/features/favorites/presentation/widgets/favorites/favorites_mock_data.dart';
import 'package:it_tools_app/features/search/presentation/widgets/filter/filter_bottom_sheet.dart';
import 'package:it_tools_app/features/search/presentation/widgets/search/no_search_results_view.dart';
import 'package:it_tools_app/features/search/presentation/widgets/search/recent_searches_section.dart';
import 'package:it_tools_app/features/search/presentation/widgets/search/search_header_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _query = 'ماوس';
  bool _isSubmitted = false;

  final List<String> _recentSearches = [
    'ماوس لاسلكي',
    'كيبورد ميكانيكي',
    'سماعات بلوتوث',
    'هب USB-C',
  ];

  final List<Map<String, dynamic>> _allProducts =
      ProductListMockData.getProducts('ماوس');

  @override
  void initState() {
    super.initState();
    _controller.text = _query;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _results {
    if (_query.trim().isEmpty) return [];
    return _allProducts
        .where((p) => (p['name'] as String).contains(_query.trim()))
        .toList();
  }

  void _resetSearch() {
    _controller.clear();
    setState(() {
      _query = '';
      _isSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    final bool showNoResultsScreen =
        _isSubmitted && _query.trim().isNotEmpty && results.isEmpty;

    return Scaffold(
      backgroundColor: showNoResultsScreen
          ? AppColors.surface
          : AppColors.pageBg,
      body: SafeArea(
        child: showNoResultsScreen
            ? NoSearchResultsView(
                query: _query.trim(),
                onClearSearch: _resetSearch,
              )
            : Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchHeaderBar(
                      controller: _controller,
                      onChanged: (val) => setState(() {
                        _query = val;
                        _isSubmitted = false;
                      }),
                      onSubmitted: (val) => setState(() {
                        _query = val;
                        _isSubmitted = true;
                      }),
                      onFilterTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const FilterBottomSheet(),
                        );
                      },
                    ),
                    RecentSearchesSection(
                      recentSearches: _recentSearches,
                      onSelect: (term) {
                        _controller.text = term;
                        setState(() {
                          _query = term;
                          _isSubmitted = true;
                        });
                      },
                      onRemove: (term) =>
                          setState(() => _recentSearches.remove(term)),
                      onClearAll: () => setState(() => _recentSearches.clear()),
                    ),
                    if (_query.trim().isNotEmpty && results.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        child: Text(
                          'نتائج البحث عن "${_query.trim()}" (${results.length})',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    Expanded(
                      child: results.isEmpty
                          ? Center(
                              child: Text(
                                _query.trim().isEmpty
                                    ? 'اكتب اسم المنتج ثم اضغط بحث'
                                    : 'اضغط على زر البحث في لوحة المفاتيح لعرض النتائج',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 36),
                              itemCount: results.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.64,
                                  ),
                              itemBuilder: (context, i) {
                                final item = results[i];
                                item['isFavorite'] =
                                    FavoritesMockData.isFavorite(item['name']);
                                return ProductGridCard(
                                  product: item,
                                  onToggleFavorite: () => setState(() {
                                    FavoritesMockData.toggleFavorite(item);
                                  }),
                                  onAddToCart: () =>
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'تمت إضافة "${item['name']}" للسلة',
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
