import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/features/search/presentation/widgets/filter/filter_bottom_sheet.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_grid_card.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_list_header.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_list_mock_data.dart';
import 'package:it_tools_app/features/favorites/presentation/widgets/favorites/favorites_mock_data.dart';

class ProductListPage extends StatefulWidget {
  final String categoryName;

  const ProductListPage({super.key, this.categoryName = 'ماوس'});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['الكل', 'لاسلكي', 'سلكي', 'ألعاب', 'مكتبي'];
  late final List<Map<String, dynamic>> _products =
      ProductListMockData.getProducts(widget.categoryName);

  @override
  Widget build(BuildContext context) {
    final list = _selectedIndex == 0
        ? _products
        : _products.where((e) => e['sub'] == _tabs[_selectedIndex]).toList();

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              ProductListHeader(
                categoryName: widget.categoryName,
                tabs: _tabs,
                selectedIndex: _selectedIndex,
                onTabSelected: (i) => setState(() => _selectedIndex = i),
                productCount: list.length,
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const FilterBottomSheet(),
                  );
                },
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 36),
                  itemCount: list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.64,
                  ),
                  itemBuilder: (context, i) {
                    final item = list[i];
                    item['isFavorite'] = FavoritesMockData.isFavorite(
                      item['name'],
                    );
                    return ProductGridCard(
                      product: item,
                      onToggleFavorite: () => setState(() {
                        FavoritesMockData.toggleFavorite(item);
                      }),

                      onAddToCart: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
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
