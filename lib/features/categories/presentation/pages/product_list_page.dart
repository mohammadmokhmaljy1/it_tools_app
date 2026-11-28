import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:it_tools_app/features/catalog/domain/entities/product_search_entities.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_search_providers.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_grid_card.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_list_header.dart';
import 'package:it_tools_app/features/favorites/presentation/widgets/favorites/favorites_mock_data.dart';
import 'package:it_tools_app/features/search/presentation/widgets/filter/filter_bottom_sheet.dart';

class ProductListPage extends ConsumerStatefulWidget {
  final String categoryName;

  const ProductListPage({super.key, this.categoryName = 'ماوس'});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialProducts());
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(productsProvider.notifier).loadMore();
    }
  }

  CategoryEntity? _findParentCategory(List<CategoryEntity> categories) {
    if (widget.categoryName == 'الكل') return null;
    for (final cat in categories) {
      if (cat.name == widget.categoryName) return cat;
    }
    return null;
  }

  Future<void> _loadInitialProducts({String? overrideCategoryId}) async {
    final categories = ref.read(categoriesProvider).value ?? const [];
    final parentCat = _findParentCategory(categories);
    final initialCategoryId = overrideCategoryId ?? parentCat?.id;

    await ref
        .read(productsProvider.notifier)
        .loadInitial(ProductQuery(categoryId: initialCategoryId));
  }

  String _formatUsd(num value) {
    return value % 1 == 0
        ? '${value.toInt()}\$'
        : '${value.toStringAsFixed(1)}\$';
  }

  Map<String, dynamic> _toCardMap(ProductSummaryEntity product) {
    return {
      'id': product.id,
      'slug': product.slug,
      'name': product.name,
      'category': product.brandName,
      'price': _formatUsd(product.finalPriceUsd),
      'oldPrice': product.hasDiscount ? _formatUsd(product.priceUsd) : null,
      'discount': product.discountPercent > 0
          ? '-${product.discountPercent}%'
          : product.badgeTitle,
      'rating': product.ratingAvg.toString(),
      'reviewsCount': product.ratingCount.toString(),
      'image': product.imageUrl,
      'isAvailable': product.inStock,
      'isOutOfStock': !product.inStock,
      'isFavorite': FavoritesMockData.isFavorite(product.name),
    };
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsState = ref.watch(productsProvider);

    final categories = categoriesAsync.value ?? const <CategoryEntity>[];
    final parentCat = _findParentCategory(categories);
    final children = parentCat?.children ?? const <CategoryEntity>[];
    final tabs = ['الكل', ...children.map((c) => c.name)];

    if (!_initialized && categories.isNotEmpty) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (parentCat != null &&
            productsState.query.categoryId != parentCat.id &&
            _selectedIndex == 0) {
          _loadInitialProducts(overrideCategoryId: parentCat.id);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              ProductListHeader(
                categoryName: widget.categoryName,
                tabs: tabs,
                selectedIndex: _selectedIndex,
                onTabSelected: (i) {
                  setState(() => _selectedIndex = i);
                  final targetCategoryId = i == 0
                      ? parentCat?.id
                      : children[i - 1].id;
                  ref
                      .read(productsProvider.notifier)
                      .loadInitial(
                        productsState.query.copyWith(
                          categoryId: targetCategoryId ?? '',
                        ),
                      );
                },
                productCount: productsState.items.length,
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const FilterBottomSheet(),
                  );
                },
              ),
              Expanded(child: _buildBody(productsState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ProductsState productsState) {
    if (productsState.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productsState.errorMessage != null && productsState.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                productsState.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(productsProvider.notifier)
                    .loadInitial(productsState.query),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (productsState.items.isEmpty) {
      return Center(
        child: Text(
          'لا توجد منتجات مطابقة حالياً',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: productsState.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.64,
            ),
            itemBuilder: (context, i) {
              final product = productsState.items[i];
              final cardMap = _toCardMap(product);
              return ProductGridCard(
                product: cardMap,
                onTap: () =>
                    context.push(AppRouter.productDetails, extra: cardMap),

                onToggleFavorite: () => setState(() {
                  FavoritesMockData.toggleFavorite(cardMap);
                }),
                onAddToCart: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تمت إضافة "${product.name}" للسلة'),
                    duration: const Duration(seconds: 1),
                  ),
                ),
              );
            },
          ),
        ),
        if (productsState.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }
}
