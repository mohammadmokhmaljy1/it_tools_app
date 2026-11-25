
import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/theme_extension.dart';
import 'otp_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForgotPassword() {
    if (_formKey.currentState!.validate()) {
      // بعد إدخال البريد والضغط على إرسال، ننتقل لشاشة الـ OTP لتأكيد الاسترداد
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpVerificationPage(email: _emailController.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgSurface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    48,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // رأس الصفحة: زر الرجوع على اليمين، والعنوان في المنتصف تماماً
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Text(
                              'استعادة الحساب',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: colors.textPrimary,
                              ),
                              style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: colors.borderDefault,
                                  ),
                                ),
                                padding: const EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // أيقونة الأمان داخل الصندوق الأزرق الفاتح
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: colors.bgSubtle,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.lock_reset_rounded,
                          color: colors.brandBlue,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'أدخل بريدك الإلكتروني وسنرسل لك رمزاً لإعادة تعيين كلمة المرور.',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // حقل البريد الإلكتروني مع الفالديشن
                      Text(
                        'البريد الإلكتروني',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'example@domain.com',
                          hintStyle: TextStyle(
                            color: colors.textTertiary,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: colors.textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colors.borderDefault,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colors.borderDefault,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colors.borderFocus,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colors.statusDanger,
                              width: 1,
                            ),
                          ),
                        ),
                      validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'يرجى إدخال البريد الإلكتروني';
  }

  if (!value.contains('@') || !value.contains('.')) {
    return 'البريد الإلكتروني غير صالح';
  }

  return null;
},
                      ),

                      const Spacer(),
                      const SizedBox(height: 20),

                      // زر إرسال رمز التحقق
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.actionPrimary,
                            foregroundColor: colors.textOnBrand,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _submitForgotPassword,
                          child: const Text(
                            'إرسال رمز التحقق',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
