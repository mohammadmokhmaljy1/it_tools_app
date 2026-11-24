import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_tools_app/core/auth/auth_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/core/widgets/custom_bottom_nav_bar.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/cart_items/cart_coupon_section.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/cart_items/cart_item_card.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/cart_items/cart_mock_data.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/cart_items/cart_summary_card.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/empty_cart/empty_cart_view.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/guest_gate/guest_checkout_gate_sheet.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final TextEditingController _couponController = TextEditingController(
    text: 'UNI15',
  );
  bool _isCouponApplied = true;
  String _appliedCouponCode = 'UNI15';

  List<Map<String, dynamic>> get _items => CartMockData.items;

  double get _subtotal => _items.fold(
    0.0,
    (sum, e) =>
        sum + ((e['oldPrice'] as num).toDouble() * (e['quantity'] as int)),
  );

  double get _offersDiscount => _items.fold(
    0.0,
    (sum, e) =>
        sum +
        (((e['oldPrice'] as num) - (e['price'] as num)).toDouble() *
            (e['quantity'] as int)),
  );

  double get _afterOffers => _subtotal - _offersDiscount;
  double get _couponDiscount => _isCouponApplied ? _afterOffers * 0.15 : 0.0;
  double get _total => _afterOffers - _couponDiscount;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _isCouponApplied = true;
      _appliedCouponCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _items.isEmpty ? AppColors.surface : AppColors.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'السلة',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (_items.isNotEmpty)
                    Text(
                      '${_items.length} منتجات',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _items.isEmpty
                  ? const EmptyCartView()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      children: [
                        ...List.generate(_items.length, (index) {
                          final item = _items[index];
                          return CartItemCard(
                            item: item,
                            onIncrement: () => setState(() {
                              item['quantity'] = (item['quantity'] as int) + 1;
                            }),
                            onDecrement: () => setState(() {
                              final qty = item['quantity'] as int;
                              if (qty > 1) {
                                item['quantity'] = qty - 1;
                              } else {
                                _items.removeAt(index);
                              }
                            }),
                            onRemove: () => setState(() {
                              _items.removeAt(index);
                            }),
                          );
                        }),
                        const SizedBox(height: 6),
                        CartCouponSection(
                          couponController: _couponController,
                          isCouponApplied: _isCouponApplied,
                          appliedCouponCode: _appliedCouponCode,
                          onApplyCoupon: _applyCoupon,
                        ),
                        const SizedBox(height: 16),
                        CartSummaryCard(
                          isCouponApplied: _isCouponApplied,
                          appliedCouponCode: _appliedCouponCode,
                          subtotal: _subtotal,
                          offersDiscount: _offersDiscount,
                          couponDiscount: _couponDiscount,
                          total: _total,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () async {
                              final auth = ref.read(authStatusProvider);
                              await auth.initialized;
                              if (!context.mounted) return;
                              if (auth.isAuthenticated) {
                                context.push(AppRouter.checkout);
                                return;
                              }
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (sheetContext) =>
                                    GuestCheckoutGateSheet(
                                      onCreateAccount: () {
                                        Navigator.pop(sheetContext);
                                        context.push(AppRouter.register);
                                      },
                                      onLogin: () {
                                        Navigator.pop(sheetContext);
                                        context.push(AppRouter.checkout);
                                      },
                                    ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.actionPrimary,
                              foregroundColor: AppColors.onBrand,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'متابعة الطلب',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onBrand,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) context.go(AppRouter.home);
          if (index == 1) context.go(AppRouter.categories);
          if (index == 2) context.go(AppRouter.cart);
          if (index == 3) context.go(AppRouter.favorites);
          if (index == 4) context.go(AppRouter.profile);
        },
      ),
    );
  }
}
