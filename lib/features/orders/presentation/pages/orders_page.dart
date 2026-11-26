
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/theme_extension.dart';
import 'package:it_tools_app/features/addresses/presentation/widgets/no_orders_view.dart';
import 'package:it_tools_app/features/profile/presentation/pages/profile_page.dart';

import 'order_details_page.dart';

class OrdersPage extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const OrdersPage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final bool _hasCurrentOrders = false;
  final bool _hasPreviousOrders = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleStartShopping(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('سيتم ربط الانتقال إلى الهوم بعد الدمج'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgPage,
      appBar: AppBar(
        backgroundColor: colors.bgPage,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.bgSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.borderDefault),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: colors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'طلباتي',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (Navigator.canPop(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colors.bgSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.borderDefault),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: colors.textPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: colors.bgPage,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: colors.bgSubtle,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderDefault),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: colors.bgSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.borderDefault),
                  boxShadow: [
                    BoxShadow(
                      color: colors.overlayScrim.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: colors.textLink,
                unselectedLabelColor: colors.textTertiary,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    text: _hasCurrentOrders ? 'الحالية (2)' : 'الحالية',
                  ),
                  const Tab(text: 'السابقة'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                !_hasCurrentOrders
                    ? NoOrdersView(
                        onStartShopping: () =>
                            _handleStartShopping(context),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildOrderCard(
                            context: context,
                            orderId: '#10482',
                            date: '10 تشرين الثاني 2026 - 3 منتجات',
                            statusText: 'جديد',
                            total: '\$76.50',
                          ),
                          const SizedBox(height: 16),
                          _buildOrderCard(
                            context: context,
                            orderId: '#10482',
                            date: '10 تشرين الثاني 2026 - 3 منتجات',
                            statusText: 'قيد التوصيل',
                            total: '\$76.50',
                          ),
                        ],
                      ),
                !_hasPreviousOrders
                    ? NoOrdersView(
                        onStartShopping: () =>
                            _handleStartShopping(context),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildOrderCard(
                            context: context,
                            orderId: '#10482',
                            date: '10 تشرين الثاني 2026 - 3 منتجات',
                            statusText: 'مكتمل',
                            total: '\$76.50',
                          ),
                          const SizedBox(height: 16),
                          _buildOrderCard(
                            context: context,
                            orderId: '#10482',
                            date: '10 تشرين الثاني 2026 - 3 منتجات',
                            statusText: 'ملغي',
                            total: '\$76.50',
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required BuildContext context,
    required String orderId,
    required String date,
    required String statusText,
    required String total,
  }) {
    final colors = context.colors;

    late final Color statusColor;
    late final Color textColor;

    switch (statusText) {
      case 'جديد':
        statusColor = colors.statusInfoBg;
        textColor = colors.statusInfo;
        break;
      case 'قيد التوصيل':
      case 'مكتمل':
        statusColor = colors.statusSuccessBg;
        textColor = colors.statusSuccess;
        break;
      case 'ملغي':
        statusColor = colors.statusDangerBg;
        textColor = colors.statusDanger;
        break;
      default:
        statusColor = colors.bgSubtle;
        textColor = colors.textSecondary;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderDetailsPage(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderDefault),
          boxShadow: [
            BoxShadow(
              color: colors.overlayScrim.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'طلب $orderId',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildProductThumbnail(
                    'assets/images/mouse.png',
                    colors,
                  ),
                  const SizedBox(width: 8),
                  _buildProductThumbnail(
                    'assets/images/keyboard.png',
                    colors,
                  ),
                  const SizedBox(width: 8),
                  _buildProductThumbnail(
                    'assets/images/headset.png',
                    colors,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  height: 1,
                  color: colors.borderDefault,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderDetailsPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 14,
                          color: colors.textLink,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'التفاصيل',
                          style: TextStyle(
                            color: colors.textLink,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        total,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'الإجمالي:',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductThumbnail(
    String assetPath,
    AppColors colors,
  ) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: colors.bgSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderDefault),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.image_not_supported,
              size: 24,
              color: colors.textTertiary,
            );
          },
        ),
      ),
    );
  }
}
