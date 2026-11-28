import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:it_tools_app/core/utils/result.dart';

import '../../domain/entities/catalog_entities.dart';
import '../../domain/entities/product_search_entities.dart';
import '../../domain/repositories/catalog_repository.dart';
import 'catalog_providers.dart';

class ProductsState {
  final List<ProductSummaryEntity> items;
  final ProductQuery query;
  final bool hasNext;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const ProductsState({
    this.items = const [],
    this.query = const ProductQuery(),
    this.hasNext = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  ProductsState copyWith({
    List<ProductSummaryEntity>? items,
    ProductQuery? query,
    bool? hasNext,
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductsState(
      items: items ?? this.items,
      query: query ?? this.query,
      hasNext: hasNext ?? this.hasNext,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ProductsNotifier extends Notifier<ProductsState> {
  CatalogRepository get _repository => ref.read(catalogRepositoryProvider);

  @override
  ProductsState build() => const ProductsState();

  Future<void> loadInitial(ProductQuery query) async {
    final firstPageQuery = query.copyWith(page: 1);
    state = ProductsState(query: firstPageQuery, isInitialLoading: true);

    final result = await _repository.getProducts(firstPageQuery);
    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          items: data.items,
          query: firstPageQuery,
          hasNext: data.hasNext,
          isInitialLoading: false,
          clearError: true,
        );
      case Error(:final failure):
        state = state.copyWith(
          isInitialLoading: false,
          errorMessage: mapCatalogFailureMessage(failure),
        );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasNext || state.isInitialLoading || state.isLoadingMore) {
      return;
    }

    final nextPageQuery = state.query.copyWith(page: state.query.page + 1);
    state = state.copyWith(isLoadingMore: true, clearError: true);

    final result = await _repository.getProducts(nextPageQuery);
    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          items: [...state.items, ...data.items],
          query: nextPageQuery,
          hasNext: data.hasNext,
          isLoadingMore: false,
        );
      case Error(:final failure):
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: mapCatalogFailureMessage(failure),
        );
    }
  }
}

final productsProvider = NotifierProvider<ProductsNotifier, ProductsState>(
  ProductsNotifier.new,
);

class SearchSuggestionsState {
  final SearchSuggestionsEntity suggestions;
  final bool isLoading;
  final String query;

  const SearchSuggestionsState({
    this.suggestions = const SearchSuggestionsEntity(
      products: [],
      categories: [],
    ),
    this.isLoading = false,
    this.query = '',
  });
}

class SearchSuggestionsNotifier extends Notifier<SearchSuggestionsState> {
  CancelToken? _cancelToken;

  CatalogRepository get _repository => ref.read(catalogRepositoryProvider);

  @override
  SearchSuggestionsState build() {
    ref.onDispose(() => _cancelToken?.cancel());
    return const SearchSuggestionsState();
  }

  Future<void> search(String rawQuery) async {
    _cancelToken?.cancel();
    final trimmed = rawQuery.trim();

    if (trimmed.isEmpty) {
      state = const SearchSuggestionsState();
      return;
    }

    final token = CancelToken();
    _cancelToken = token;

    state = SearchSuggestionsState(
      suggestions: state.suggestions,
      isLoading: true,
      query: trimmed,
    );

    final result = await _repository.getSearchSuggestions(
      trimmed,
      cancelToken: token,
    );

    if (token.isCancelled) return;

    switch (result) {
      case Success(:final data):
        state = SearchSuggestionsState(
          suggestions: data,
          isLoading: false,
          query: trimmed,
        );
      case Error():
        state = SearchSuggestionsState(
          suggestions: const SearchSuggestionsEntity(
            products: [],
            categories: [],
          ),
          isLoading: false,
          query: trimmed,
        );
    }
  }

  void clear() {
    _cancelToken?.cancel();
    state = const SearchSuggestionsState();
  }
}

final searchSuggestionsProvider =
    NotifierProvider<SearchSuggestionsNotifier, SearchSuggestionsState>(
      SearchSuggestionsNotifier.new,
    );
