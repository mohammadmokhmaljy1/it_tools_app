
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // إظهار الطلبات التجريبية عند الضغط على ابدأ التسوق
  bool _showDemoOrders = false;

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

  // عرض الطلبات التجريبية داخل صفحة طلباتي
  void _handleStartShopping(BuildContext context) {
    setState(() {
      _showDemoOrders = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBFF),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD0E1ED),
                  ),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF0578B7),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'طلباتي',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (Navigator.canPop(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD0E1ED),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF1E293B),
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
            color: const Color(0xFFF4FBFF),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE2EEF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: const Color(0xFF0578B7),
                unselectedLabelColor: Colors.grey,
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
                    text: (_hasCurrentOrders || _showDemoOrders)
                        ? 'الحالية (2)'
                        : 'الحالية',
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
                // الطلبات الحالية
                !(_hasCurrentOrders || _showDemoOrders)
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
                            statusColor: const Color(0xFFE3F2FD),
                            textColor: const Color(0xFF1976D2),
                            total: '\$76.50',
                          ),
                          const SizedBox(height: 16),
                          _buildOrderCard(
                            context: context,
                            orderId: '#10482',
                            date: '10 تشرين الثاني 2026 - 3 منتجات',
                            statusText: 'قيد التوصيل',
                            statusColor: const Color(0xFFE8F5E9),
                            textColor: const Color(0xFF388E3C),
                            total: '\$76.50',
                          ),
                        ],
                      ),

                // الطلبات السابقة
                !(_hasPreviousOrders || _showDemoOrders)
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
                            statusColor: const Color(0xFFE8F5E9),
                            textColor: const Color(0xFF388E3C),
                            total: '\$76.50',
                          ),
                          const SizedBox(height: 16),
                          _buildOrderCard(
                            context: context,
                            orderId: '#10482',
                            date: '10 تشرين الثاني 2026 - 3 منتجات',
                            statusText: 'ملغي',
                            statusColor: const Color(0xFFFFEBEE),
                            textColor: const Color(0xFFD32F2F),
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
    required Color statusColor,
    required Color textColor,
    required String total,
  }) {
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2EEF5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildProductThumbnail('assets/images/mouse.png'),
                  const SizedBox(width: 8),
                  _buildProductThumbnail('assets/images/keyboard.png'),
                  const SizedBox(width: 8),
                  _buildProductThumbnail('assets/images/headset.png'),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  height: 1,
                  color: Color(0xFFF1F5F9),
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
                          builder: (context) =>
                              const OrderDetailsPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 14,
                          color: Color(0xFF0578B7),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'التفاصيل',
                          style: TextStyle(
                            color: Color(0xFF0578B7),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'الإجمالي:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
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

  Widget _buildProductThumbnail(String assetPath) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              size: 24,
              color: Colors.grey,
            );
          },
        ),
      ),
    );
  }
}
