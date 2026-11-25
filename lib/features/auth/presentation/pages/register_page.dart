
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_tools_app/core/theme/theme_extension.dart';

import 'login_page.dart';
import 'otp_verification_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  String? _selectedUniversity;

  final List<String> _universities = [
    'معهد الحاسوب المتوسط',
    'معهد الحاسوب العالي',
    'كلية المعلوماتية - جامعة حلب',
    'كلية المعلوماتية - جامعة قرطبة',
    'كلية المعلوماتية - جامعة الاتحاد',
    'كلية المعلوماتية - جامعة الشهباء',
    'كلية المعلوماتية - جامعة إبلا',
    'كلية الحاسبات والاتصالات - جامعة حلب',
    'الجامعة الافتراضية - قسم المعلوماتية',
    'لا أنتمي لأي منها',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يجب الموافقة على الشروط والأحكام أولاً'),
          backgroundColor: context.colors.statusDanger,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OtpVerificationPage(email: _emailController.text.trim()),
      ),
    );
  }

  void _showUniversityPickerBottomSheet() {
    String? tempSelected = _selectedUniversity;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final colors = context.colors;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.borderDefault,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: colors.textPrimary,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'اختر جامعتك أو معهدك',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'اختياري — لتصلك عروض وكوبونات خاصة بجامعتك.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _universities.length,
                      itemBuilder: (context, index) {
                        final university = _universities[index];
                        final isSelected = tempSelected == university;

                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              tempSelected = university;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    university,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? colors.brandBlue
                                          : colors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                                Radio<String>(
                                  value: university,
                                  groupValue: tempSelected,
                                  activeColor: colors.brandBlue,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setModalState(() {
                                        tempSelected = value;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedUniversity = tempSelected;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.actionPrimary,
                      foregroundColor: colors.textOnBrand,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'تأكيد الاختيار',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgSurface,
      appBar: AppBar(
        backgroundColor: colors.bgSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: colors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'إنشاء حساب',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'أنشئ حسابك خلال دقيقة واحدة لإتمام الطلب ومتابعته.',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildLabel('الاسم الكامل'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textDirection: TextDirection.rtl,
                  decoration: _inputDecoration(
                    hintText: 'أدخل الاسم الكامل',
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال الاسم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('البريد الإلكتروني'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(
                    hintText: 'example@domain.com',
                    icon: Icons.mail_outline,
                  ),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                            .hasMatch(value.trim())) {
                      return 'البريد الإلكتروني غير صالح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('رقم الموبايل'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    hintText: '09xxxxxxxx',
                    icon: Icons.phone_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال رقم الموبايل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('كلمة المرور'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(color: colors.textTertiary),
                    prefixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.borderDefault),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.borderDefault),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.borderFocus),
                    ),
                    filled: true,
                    fillColor: colors.bgSurface,
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'كلمة المرور قصيرة جداً';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('الجامعة / المعهد (اختياري)'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _showUniversityPickerBottomSheet,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      filled: true,
                      fillColor: colors.bgSurface,
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: colors.textSecondary,
                      ),
                    ),
                    child: Text(
                      _selectedUniversity ?? 'اختر جامعتك أو معهدك (اختياري)',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedUniversity == null
                            ? colors.textTertiary
                            : colors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.statusInfoBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        color: colors.statusInfo,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'نستخدمها فقط لإرسال عروض وكوبونات خاصة بجامعتك.',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      activeColor: colors.actionPrimary,
                      onChanged: (val) {
                        setState(() {
                          _agreeToTerms = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'أوافق على الشروط والأحكام وسياسة الخصوصية',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.actionPrimary,
                    foregroundColor: colors.textOnBrand,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'إنشاء الحساب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب؟',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: colors.brandBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    final colors = context.colors;

    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    final colors = context.colors;

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: colors.textTertiary,
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: colors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.borderFocus),
      ),
      filled: true,
      fillColor: colors.bgSurface,
    );
  }
}
