import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_assets.dart';
import '../models/order_preview.dart';

class OrderDetailsPage extends ConsumerWidget {
  const OrderDetailsPage({super.key, required this.order, this.onRate});

  final OrderPreview order;
  final VoidCallback? onRate;

  bool get isOrderCompleted => order == OrderPreview.completed;
  bool get canCancel =>
      order == OrderPreview.newOrder || order == OrderPreview.shipping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBFF),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Center(
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري الاتصال بالدعم...')),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD0E1ED)),
                ),
                child: const Icon(
                  Icons.phone_outlined,
                  color: Color(0xFF1E293B),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'طلب #${order.id}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD0E1ED)),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. حالة الطلب والتتبع
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2EEF5)),
                ),
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
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            order.label,
                            style: const TextStyle(
                              color: Color(0xFF1976D2),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Text(
                          'حالة الطلب',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTimelineStep(
                      title: 'جديد',
                      subtitle: '10 تشرين الثاني · 01:40 م',
                      isCompleted: true,
                      isCurrent: false,
                      hasLine: true,
                    ),
                    _buildTimelineStep(
                      title: 'مؤكد',
                      subtitle: '10 تشرين الثاني · 03:15 م',
                      isCompleted: true,
                      isCurrent: !isOrderCompleted,
                      hasLine: true,
                    ),
                    _buildTimelineStep(
                      title: 'قيد التوصيل',
                      subtitle: '',
                      isCompleted: isOrderCompleted,
                      isCurrent: false,
                      hasLine: true,
                    ),
                    _buildTimelineStep(
                      title: 'مكتمل',
                      subtitle: '',
                      isCompleted: isOrderCompleted,
                      isCurrent: false,
                      hasLine: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. المنتجات
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2EEF5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'المنتجات (3)',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildProductItem(
                      name: 'كيبورد ميكانيكي %75 لاسلكي',
                      details: 'كحلي · 1 × Blue',
                      price: '\$33.60',
                      assetPath: AppAssets.productKeyboard,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Color(0xFFF1F5F9)),
                    ),
                    _buildProductItem(
                      name: 'ماوس لاسلكي صامت M331',
                      details: 'أسود · 2 ×',
                      price: '\$38.00',
                      assetPath: AppAssets.productMouse,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Color(0xFFF1F5F9)),
                    ),
                    _buildProductItem(
                      name: 'سماعة ألعاب مع مايك',
                      details: 'أسود/أزرق · 1 ×',
                      price: '\$35.00',
                      assetPath: AppAssets.productHeadset,
                    ),
                  ],
                ),
              ),

              // يظهر تقييم المشتريات فقط بعد اكتمال الطلب.
              if (isOrderCompleted && onRate != null) ...[
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: onRate,
                  icon: const Icon(Icons.star_outline_rounded),
                  label: const Text(
                    'قيّم مشترياتك',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // 3. التوصيل والدفع
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2EEF5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'التوصيل والدفع',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('طريقة الاستلام', 'توصيل إلى العنوان'),
                    const SizedBox(height: 8),
                    _buildInfoRow('العنوان', 'حلب · الفرقان · شارع الجامعة'),
                    const SizedBox(height: 8),
                    _buildInfoRow('الدفع', 'عند الاستلام (USD / SYP)'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFF1F5F9)),
                    ),
                    _buildFinancialRow('المجموع الفرعي', '\$106.60'),
                    const SizedBox(height: 6),
                    _buildFinancialRow('الخصومات', '-\$23.13', isGreen: true),
                    const SizedBox(height: 6),
                    _buildFinancialRow('التوصيل', '\$3.00'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFF1F5F9)),
                    ),
                    _buildFinancialRow('الإجمالي', '\$86.47', isBold: true),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. التنبيه: يظهر فقط قبل اكتمال الطلب.
              if (canCancel)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFEF3C7)),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'طلبك مؤكد. يمكنك إرسال طلب إلغاء واستراجعه للإدارة. لا يمكن الإلغاء بعد خروج الطلب للتوصيل.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB45309),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFFD97706),
                        size: 20,
                      ),
                    ],
                  ),
                ),

              if (canCancel) const SizedBox(height: 16),

              // 5. زر طلب الإلغاء: لا يمكن إلغاء طلب مكتمل.
              if (canCancel)
                OutlinedButton(
                  onPressed: () {
                    _showCancelOrderBottomSheet(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD32F2F),
                    side: const BorderSide(color: Color(0xFFD32F2F)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_outlined, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'طلب إلغاء الطلب',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // نافذة إلغاء الطلب
  void _showCancelOrderBottomSheet(BuildContext context) {
    String selectedReason = 'تأخر موعد التوصيل';

    final List<String> reasons = [
      'طلبت المنتج بالخطأ',
      'وجدت سعراً أفضل',
      'تأخر موعد التوصيل',
      'أريد تعديل الطلب',
      'سبب آخر',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    left: 20,
                    right: 20,
                    top: 12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // الخط العلوي
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'طلب إلغاء الطلب #${order.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.right,
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'طلبك مؤكد، لذلك سيرسل طلب الإلغاء للإدارة للموافقة. سنعلمك بالنتيجة داخل التطبيق.',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                        textAlign: TextAlign.right,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'سبب الإلغاء',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.right,
                      ),

                      const SizedBox(height: 8),

                      // خيارات سبب الإلغاء
                      RadioGroup<String>(
                        groupValue: selectedReason,
                        onChanged: (value) {
                          if (value == null) return;
                          setStateModal(() {
                            selectedReason = value;
                          });
                        },
                        child: Column(
                          children: reasons.map((reason) {
                            return RadioListTile<String>(
                              title: Text(
                                reason,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              value: reason,
                              activeColor: const Color(0xFF0077B6),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.trailing,
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // أزرار التراجع والإرسال
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF0077B6),
                                backgroundColor: const Color(0xFFF4FBFF),
                                side: const BorderSide(
                                  color: Color(0xFFD0E1ED),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'تراجع',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تم إرسال طلب الإلغاء بسبب: $selectedReason',
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD32F2F),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'إرسال طلب الإلغاء',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // خطوات تتبع الطلب
  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    required bool hasLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent || isCompleted
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isCurrent || isCompleted
                      ? Colors.black87
                      : Colors.grey,
                ),
                textAlign: TextAlign.right,
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrent || isCompleted
                      ? const Color(0xFF0077B6)
                      : Colors.grey.shade300,
                  width: 2,
                ),
                color: isCurrent
                    ? Colors.white
                    : (isCompleted ? const Color(0xFF0077B6) : Colors.white),
              ),
              child: isCurrent
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0077B6),
                        ),
                      ),
                    )
                  : (isCompleted
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null),
            ),

            if (hasLine)
              Container(
                width: 2,
                height: 28,
                color: isCompleted
                    ? const Color(0xFF0077B6)
                    : Colors.grey.shade300,
              ),
          ],
        ),
      ],
    );
  }

  // عنصر المنتج
  Widget _buildProductItem({
    required String name,
    required String details,
    required String price,
    required String assetPath,
  }) {
    return Row(
      children: [
        Text(
          price,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const Spacer(),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              details,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),

        const SizedBox(width: 12),

        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  size: 20,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // معلومات التوصيل
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  // الحسابات المالية
  Widget _buildFinancialRow(
    String label,
    String value, {
    bool isGreen = false,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isGreen ? const Color(0xFF2E7D32) : Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black87 : Colors.grey,
          ),
        ),
      ],
    );
  }
}
