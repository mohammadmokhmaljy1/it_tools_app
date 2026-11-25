
import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/theme_extension.dart';
import 'package:it_tools_app/features/orders/presentation/pages/orders_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({
    super.key,
    required this.email,
  });

  @override
  State<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  String _normalizeDigits(String input) {
    const arabicDigits = [
      '٠', '١', '٢', '٣', '٤',
      '٥', '٦', '٧', '٨', '٩',
    ];

    const persianDigits = [
      '۰', '۱', '۲', '۳', '۴',
      '۵', '۶', '۷', '۸', '۹',
    ];

    var result = input;

    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(arabicDigits[i], i.toString());
      result = result.replaceAll(persianDigits[i], i.toString());
    }

    return result.replaceAll(RegExp(r'\D'), '');
  }

  void _verifyOtp() {
    final combined = _controllers.map((c) => c.text.trim()).join();
    final digitsOnly = _normalizeDigits(combined);

    if (digitsOnly.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'الرجاء إدخال رمز التحقق المكون من 6 أرقام',
          ),
          backgroundColor: context.colors.statusDanger,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const OrdersPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgSurface,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colors.bgSurface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: colors.textPrimary,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colors.bgSubtle,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.mail_outline,
                  color: colors.brandBlue,
                  size: 36,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'تحقق من بريدك الإلكتروني',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'أرسلنا رمزاً من 6 أرقام إلى\n${widget.email}',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: List.generate(6, (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        child: _buildOtpBox(index),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '00:45',
                    style: TextStyle(
                      color: colors.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'إعادة إرسال الرمز بعد',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.actionPrimary,
                    foregroundColor: colors.textOnBrand,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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

  Widget _buildOtpBox(int index) {
    final colors = context.colors;

    return SizedBox(
      height: 55,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colors.brandBlue,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: colors.borderDefault,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: colors.borderFocus,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: colors.bgSubtle,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
