import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/catalog/domain/entities/product_search_entities.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_search_providers.dart';
import 'package:it_tools_app/features/search/presentation/widgets/filter/filter_bottom_sheet.dart';
import 'package:it_tools_app/features/search/presentation/widgets/search/no_search_results_view.dart';
import 'package:it_tools_app/features/search/presentation/widgets/search/recent_searches_section.dart';
import 'package:it_tools_app/features/search/presentation/widgets/search/search_header_bar.dart';
import 'package:it_tools_app/features/search/presentation/widgets/search/search_results_grid.dart';
import 'package:it_tools_app/features/search/presentation/widgets/search/search_suggestions_view.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _query = '';
  bool _isSubmitted = false;

  final List<String> _recentSearches = [
    'ماوس لاسلكي',
    'كيبورد ميكانيكي',
    'سماعات بلوتوث',
    'هب USB-C',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !_isSubmitted) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(productsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submitSearch(String rawTerm) {
    final term = rawTerm.trim();
    _controller.text = term;
    setState(() {
      _query = term;
      _isSubmitted = term.isNotEmpty;
    });
    ref.read(searchSuggestionsProvider.notifier).clear();

    if (term.isNotEmpty) {
      if (!_recentSearches.contains(term)) {
        _recentSearches.insert(0, term);
      }
      ref.read(productsProvider.notifier).loadInitial(ProductQuery(q: term));
    }
  }

  void _resetSearch() {
    _controller.clear();
    ref.read(searchSuggestionsProvider.notifier).clear();
    setState(() {
      _query = '';
      _isSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final suggestionsState = ref.watch(searchSuggestionsProvider);
    final productsState = ref.watch(productsProvider);

    final bool showNoResultsScreen =
        _isSubmitted &&
        !productsState.isInitialLoading &&
        productsState.errorMessage == null &&
        _query.trim().isNotEmpty &&
        productsState.items.isEmpty;

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
                      onChanged: (val) {
                        setState(() {
                          _query = val;
                          _isSubmitted = false;
                        });
                        ref
                            .read(searchSuggestionsProvider.notifier)
                            .search(val);
                      },
                      onSubmitted: _submitSearch,
                      onFilterTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const FilterBottomSheet(),
                        );
                      },
                    ),
                    if (!_isSubmitted && _query.trim().isEmpty)
                      RecentSearchesSection(
                        recentSearches: _recentSearches,
                        onSelect: _submitSearch,
                        onRemove: (term) =>
                            setState(() => _recentSearches.remove(term)),
                        onClearAll: () =>
                            setState(() => _recentSearches.clear()),
                      ),
                    if (!_isSubmitted && _query.trim().isNotEmpty)
                      Expanded(
                        child: SearchSuggestionsView(
                          state: suggestionsState,
                          query: _query,
                          onSelectSuggestion: _submitSearch,
                        ),
                      )
                    else if (_isSubmitted)
                      Expanded(
                        child: SearchResultsGrid(
                          state: productsState,
                          query: _query,
                          scrollController: _scrollController,
                          onRetry: () => _submitSearch(_query),
                        ),
                      )
                    else
                      Expanded(
                        child: Center(
                          child: Text(
                            'اكتب اسم المنتج للبحث الفوري',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
