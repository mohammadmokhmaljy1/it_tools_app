
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';

import 'package:it_tools_app/core/theme/theme_extension.dart';

class AboutContactPage extends StatelessWidget {
  const AboutContactPage({super.key});

  static const String _heroBannerAsset = 'assets/images/Frame.png';

  void _showCopiedSnackBar(
    BuildContext context,
    String label,
    String value,
  ) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ $label: $value'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMapInfoDialog(BuildContext context) {
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'موقع المتجر - المحيط',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          content: Text(
            'حلب - الجميلية، قرب ساحة سعد الله الجابري.\nالاستلام من المتجر متاح مجاناً خلال أوقات الدوام.',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13.5,
              color: colors.textSecondary,
              height: 1.55,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'حسناً',
                style: TextStyle(
                  color: colors.brandBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: colors.bgPage,
      appBar: AppBar(
        backgroundColor: colors.bgPage,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'تواصل معنا',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
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
                    color: surfaceColor,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صورة الكونتينر كاملة كما هي من فيغما
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  _heroBannerAsset,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 14),

              // بطاقة معلومات التواصل والمتجر
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.borderDefault),
                ),
                child: Column(
                  children: [
                    _buildContactTile(
                      colors: colors,
                      trailingIcon: Icons.phone_outlined,
                      title: '+963 969 146 843',
                      isLtrText: true,
                      onTap: () => _showCopiedSnackBar(
                        context,
                        'رقم الهاتف',
                        '+963 969 146 843',
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: colors.bgSubtle,
                    ),
                    _buildContactTile(
                      colors: colors,
                      trailingIcon: Icons.mail_outline_rounded,
                      title: 'واتساب: 843 146 0969',
                      onTap: () => _showCopiedSnackBar(
                        context,
                        'رقم الواتساب',
                        '0969146843',
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: colors.bgSubtle,
                    ),
                    _buildContactTile(
                      colors: colors,
                      trailingIcon: Icons.mail_outline_rounded,
                      title: 'support@almuheet.app',
                      isLtrText: true,
                      onTap: () => _showCopiedSnackBar(
                        context,
                        'البريد الإلكتروني',
                        'support@almuheet.app',
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: colors.bgSubtle,
                    ),
                    _buildContactTile(
                      colors: colors,
                      trailingIcon: Icons.location_on_outlined,
                      title: 'المتجر: حلب - الجميلية، قرب ساحة سعد الله',
                      onTap: () => _showMapInfoDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // بطاقة أوقات الدوام
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.borderDefault),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'أوقات الدوام',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: colors.brandBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '10:00 ص - 9:00 م',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'السبت - الخميس',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'مغلق',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'الجمعة',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // زر فتح الموقع على الخريطة
              InkWell(
                onTap: () => _showMapInfoDialog(context),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: colors.statusInfoBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'افتح الموقع على الخريطة',
                        style: TextStyle(
                          color: colors.brandBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on_outlined,
                        color: colors.brandBlue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required AppColors colors,
    required IconData trailingIcon,
    required String title,
    required VoidCallback onTap,
    bool isLtrText = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: colors.textTertiary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                textDirection:
                    isLtrText ? TextDirection.ltr : TextDirection.rtl,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.statusInfoBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                trailingIcon,
                color: colors.brandBlue,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
