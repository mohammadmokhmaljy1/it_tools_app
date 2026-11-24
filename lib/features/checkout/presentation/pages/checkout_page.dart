import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/cart/presentation/widgets/cart_items/cart_mock_data.dart';
import 'package:it_tools_app/features/checkout/presentation/widgets/checkout/checkout_address_form.dart';
import 'package:it_tools_app/features/checkout/presentation/widgets/checkout/checkout_delivery_method_section.dart';
import 'package:it_tools_app/features/checkout/presentation/widgets/checkout/checkout_payment_and_summary.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isHomeDelivery = true;
  String _selectedCity = 'حلب';

  final TextEditingController _areaController = TextEditingController(
    text: 'الفرقان',
  );
  final TextEditingController _streetController = TextEditingController(
    text: 'شارع الجامعة، بناء 12، الطابق 3',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '0944 123 456',
  );
  final TextEditingController _notesController = TextEditingController();

  List<Map<String, dynamic>> get _items => CartMockData.items;

  int get _totalPieces =>
      _items.fold(0, (sum, e) => sum + (e['quantity'] as int));

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
  double get _couponDiscount => _afterOffers * 0.15;
  double get _totalDiscount => _offersDiscount + _couponDiscount;
  double get _deliveryFee => _isHomeDelivery ? 3.00 : 0.00;
  double get _finalTotal => _afterOffers - _couponDiscount + _deliveryFee;

  @override
  void dispose() {
    _areaController.dispose();
    _streetController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // 1. الشريط العلوي
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (context.canPop()) context.pop();
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'إتمام الطلب',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingH3,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // 2. المحتوى القابل للتمرير
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckoutDeliveryMethodSection(
                      isHomeDelivery: _isHomeDelivery,
                      onChanged: (val) => setState(() => _isHomeDelivery = val),
                    ),
                    if (_isHomeDelivery) ...[
                      const SizedBox(height: 22),
                      CheckoutAddressForm(
                        selectedCity: _selectedCity,
                        onCityChanged: (city) {
                          if (city != null) {
                            setState(() => _selectedCity = city);
                          }
                        },
                        areaController: _areaController,
                        streetController: _streetController,
                        phoneController: _phoneController,
                      ),
                    ],
                    const SizedBox(height: 22),
                    CheckoutPaymentAndSummary(
                      notesController: _notesController,
                      totalPieces: _totalPieces,
                      subtotal: _subtotal,
                      totalDiscount: _totalDiscount,
                      isHomeDelivery: _isHomeDelivery,
                      selectedCity: _selectedCity,
                      deliveryFee: _deliveryFee,
                      finalTotal: _finalTotal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 3. الشريط السفلي الثابت (الإجمالي + زر تأكيد الطلب)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.borderDefault, width: 0.8),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الإجمالي', style: AppTextStyles.caption),
                  Text(
                    '\$${_finalTotal.toStringAsFixed(2)}',
                    style: AppTextStyles.priceLarge,
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // سنربطه بصفحة نجاح الطلب (23 Order Success) في الخطوة التالية
                    context.push(
                      AppRouter.orderSuccess,
                      extra: {
                        'deliveryLabel': _isHomeDelivery
                            ? 'توصيل إلى $_selectedCity'
                            : 'استلام من المتجر',
                        'totalAmount': _finalTotal,
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.actionPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'تأكيد الطلب',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.onBrand,
                      ),
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
