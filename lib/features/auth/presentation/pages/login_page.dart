import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:it_tools_app/core/theme/theme_extension.dart';
import 'package:it_tools_app/features/auth/presentation/pages/register_page.dart';
import 'package:it_tools_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:it_tools_app/features/orders/presentation/pages/orders_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isGoogleLoading = false;
  bool _isLoginLoading = false;

  static const String _baseUrl =
      'https://it-tools-api.vercel.app/api/v1';
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (_isLoginLoading || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoginLoading = true);

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await dio.post(
        '/auth/login',
        data: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'deviceInfo': 'Flutter App',
        },
      );

      final responseData = response.data;

      final data = responseData is Map
          ? responseData['data']
          : null;

      final tokens = data is Map
          ? (data['tokens'] ?? data)
          : null;

      final accessToken = tokens is Map
          ? tokens['accessToken']
          : null;

      final refreshToken = tokens is Map
          ? tokens['refreshToken']
          : null;

      if (accessToken == null || refreshToken == null) {
        throw Exception(
          'لم يرجع السيرفر بيانات تسجيل الدخول بالشكل المتوقع',
        );
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'accessToken',
        accessToken.toString(),
      );

      await prefs.setString(
        'refreshToken',
        refreshToken.toString(),
      );

      log('API LOGIN SUCCESS');

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const OrdersPage(),
        ),
        (route) => false,
      );
    } on DioException catch (e) {
      log('API LOGIN ERROR: ${e.message}');
      log('STATUS CODE: ${e.response?.statusCode}');
      log('API RESPONSE: ${e.response?.data}');

      if (!mounted) return;

      final responseData = e.response?.data;
      String message;

      if (responseData is Map && responseData['message'] != null) {
        message = responseData['message'].toString();
      } else if (responseData is String && responseData.isNotEmpty) {
        message = 'السيرفر (${e.response?.statusCode}): $responseData';
      } else if (e.response != null) {
        message = 'فشل الدخول (رمز ${e.response?.statusCode})';
      } else {
        message = 'تعذّر الاتصال بالسيرفر، تحقق من الإنترنت';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.colors.statusDanger,
        ),
      );
    } catch (e, stackTrace) {
      log('LOGIN ERROR: $e');
      log('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تسجيل الدخول: $e'),
          backgroundColor: context.colors.statusDanger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoginLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isGoogleLoading) return;

    try {
      debugPrint('GOOGLE SIGN IN BUTTON PRESSED');
      debugPrint('Starting Google Sign-In initialization...');

      setState(() => _isGoogleLoading = true);

      await GoogleSignIn.instance.initialize(
        serverClientId:
            '942180254108-t77m12s3jjabseudctf8v5qhcps9b5o3.apps.googleusercontent.com',
      );

      log('Google Sign-In initialized successfully');

      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      log('========== GOOGLE USER DATA ==========');
      log('Google ID: ${googleUser.id}');
      log('Display Name: ${googleUser.displayName}');
      log('Email: ${googleUser.email}');
      log('Photo URL: ${googleUser.photoUrl}');
      log('======================================');

      log('Google account selected: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint('Firebase Google Sign-In successful');

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const OrdersPage(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('FIREBASE AUTH ERROR: ${e.code} - ${e.message}');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'فشل تسجيل الدخول: ${e.message ?? e.code}',
          ),
          backgroundColor: context.colors.statusDanger,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('GOOGLE SIGN IN ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذّر تسجيل الدخول باستخدام Google: $e'),
          backgroundColor: context.colors.statusDanger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/images/Mark-Color.png',
                      height: 65,
                      width: 65,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'أهلاً بعودتك',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'سجّل دخولك لمتابعة حسابك.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

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
                      hintText: 'noor@devmmnd.com',
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
                      if (!value.contains('@') ||
                          !value.contains('.')) {
                        return 'البريد الإلكتروني غير صالح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'كلمة المرور',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(
                        color: colors.textTertiary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colors.brandBlue,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
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
                        return 'يرجى إدخال كلمة المرور';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب ألا تقل عن 6 أحرف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          color: colors.brandBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

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
                      onPressed:
                          _isLoginLoading ? null : _submitLogin,
                      child: _isLoginLoading
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.textOnBrand,
                              ),
                            )
                          : const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: colors.borderDefault,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Text(
                          'أو',
                          style: TextStyle(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: colors.borderDefault,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: colors.borderDefault,
                        ),
                      ),
                      onPressed: _isGoogleLoading
                          ? null
                          : () {
                              debugPrint('GOOGLE BUTTON CLICKED');
                              _signInWithGoogle();
                            },
                      child: _isGoogleLoading
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.brandBlue,
                              ),
                            )
                          : Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(20, 20),
                                  painter: _GoogleLogoPainter(),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'المتابعة باستخدام Google',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لديك حساب؟ ',
                        style: TextStyle(
                          color: colors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            color: colors.brandBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'تصفّح كزائر',
                        style: TextStyle(
                          color: colors.brandBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    final double radius = w / 2;
    final double strokeWidth = w * 0.2;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius - strokeWidth / 2,
      ),
      -2.35,
      1.6,
      false,
      paint,
    );

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius - strokeWidth / 2,
      ),
      2.35,
      1.6,
      false,
      paint,
    );

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius - strokeWidth / 2,
      ),
      0.75,
      1.6,
      false,
      paint,
    );

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius - strokeWidth / 2,
      ),
      -0.05,
      0.85,
      false,
      paint,
    );

    final Paint linePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        w * 0.5,
        h * 0.41,
        w * 0.48,
        strokeWidth,
      ),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
