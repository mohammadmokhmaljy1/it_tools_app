import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_tools_app/core/theme/theme_extension.dart';
import 'package:it_tools_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// عدّلي هذا المسار ليشير إلى ملف user_profile_provider.dart في مشروعك

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  get _colors => context.colors;

  static const String _promoKey = 'it_tools_promo_notifications_v1';
  static const String _uniOffersKey = 'it_tools_uni_offers_v1';
  static const String _langKey = 'it_tools_app_language_v1';

  bool _promoNotifications = true;
  bool _universityOffers = true;
  String _selectedLanguage = 'العربية';

  static const List<String> _universities = [
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
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _promoNotifications = prefs.getBool(_promoKey) ?? true;
      _universityOffers = prefs.getBool(_uniOffersKey) ?? true;
      _selectedLanguage = prefs.getString(_langKey) ?? 'العربية';
    });
  }

  Future<void> _togglePromoNotifications(bool value) async {
    setState(() => _promoNotifications = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_promoKey, value);
  }

  Future<void> _toggleUniversityOffers(bool value) async {
    setState(() => _universityOffers = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_uniOffersKey, value);
  }

  void _showChangePasswordSheet() {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'تغيير كلمة المرور',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _colors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: currentPassController,
                obscureText: true,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الحالية',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassController,
                obscureText: true,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPassController,
                obscureText: true,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور الجديدة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (newPassController.text.trim().length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                        ),
                      ),
                    );
                    return;
                  }
                  if (newPassController.text != confirmPassController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('كلمتا المرور غير متطابقتين'),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تحديث كلمة المرور بنجاح'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _colors.brandBlue,
                  foregroundColor: _colors.textOnBrand,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'حفظ كلمة المرور',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUniversitySheet() {
    final profile = ref.read(userProfileProvider);
    final options = List<String>.from(_universities);
    if (profile.affiliation.trim().isNotEmpty &&
        !options.contains(profile.affiliation)) {
      options.insert(0, profile.affiliation);
    }
    String selected = profile.affiliation;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'الجامعة / المعهد',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final item = options[index];
                        final isSelected = selected == item;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? _colors.brandBlue
                                  : _colors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: Radio<String>(
                            value: item,
                            groupValue: selected,
                            activeColor: _colors.brandBlue,
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => selected = val);
                              }
                            },
                          ),
                          onTap: () => setModalState(() => selected = item),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final current = ref.read(userProfileProvider);
                      await ref.read(userProfileProvider.notifier).saveAccount(
                            name: current.name,
                            email: current.email,
                            phone: current.phone,
                            affiliation: selected,
                            avatarPath: current.avatarPath,
                          );
                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                      }
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تحديث الجامعة / المعهد'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _colors.brandBlue,
                      foregroundColor: _colors.textOnBrand,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'حفظ الاختيار',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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

  void _showLanguageSheet() {
    const languages = ['العربية', 'English'];
    String tempLang = _selectedLanguage;

    showModalBottomSheet(
      context: context,
      backgroundColor: _colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'اختيار اللغة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...languages.map(
                    (lang) => RadioListTile<String>(
                      value: lang,
                      groupValue: tempLang,
                      activeColor: _colors.brandBlue,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        lang,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14.5),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => tempLang = val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => _selectedLanguage = tempLang);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(_langKey, tempLang);
                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _colors.brandBlue,
                      foregroundColor: _colors.textOnBrand,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'تأكيد اللغة',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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

  void _showLegalDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _colors.bgSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: _colors.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.5,
                color: _colors.textSecondary,
                height: 1.55,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'إغلاق',
                style: TextStyle(
                  color: _colors.brandBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _colors.bgSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'حذف الحساب',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: _colors.statusDanger,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف بيانات الحساب المحلي؟ لا يمكن التراجع عن هذا الإجراء.',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13.5,
              color: _colors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'إلغاء',
                style: TextStyle(color: _colors.textTertiary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(userProfileProvider.notifier)
                    .clearLocalAccount();
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حذف بيانات الحساب المحلي')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _colors.statusDanger,
                foregroundColor: _colors.textOnBrand,
                elevation: 0,
              ),
              child: Text('تأكيد الحذف'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgPage,
      appBar: AppBar(
        backgroundColor: _colors.bgPage,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'الإعدادات',
          style: TextStyle(
            color: _colors.textPrimary,
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
                    color: _colors.bgSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _colors.borderDefault),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: _colors.textPrimary,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // قسم الإشعارات
              _buildSectionTitle('الإشعارات'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: _colors.bgSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _colors.borderDefault),
                ),
                child: Column(
                  children: [
                    _buildSwitchRow(
                      title: 'إشعارات العروض والكوبونات',
                      value: _promoNotifications,
                      onChanged: _togglePromoNotifications,
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: _colors.bgSubtle,
                    ),
                    _buildSwitchRow(
                      title: 'عروض جامعتي',
                      value: _universityOffers,
                      onChanged: _toggleUniversityOffers,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // قسم الحساب
              _buildSectionTitle('الحساب'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: _colors.bgSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _colors.borderDefault),
                ),
                child: Column(
                  children: [
                    _buildNavigationRow(
                      title: 'تغيير كلمة المرور',
                      icon: Icons.verified_user_outlined,
                      onTap: _showChangePasswordSheet,
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: _colors.bgSubtle,
                    ),
                    _buildNavigationRow(
                      title: 'الجامعة / المعهد',
                      icon: Icons.badge_outlined,
                      onTap: _showUniversitySheet,
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: _colors.bgSubtle,
                    ),
                    _buildNavigationRow(
                      title: 'اللغة: $_selectedLanguage',
                      icon: Icons.description_outlined,
                      onTap: _showLanguageSheet,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // قسم قانوني
              _buildSectionTitle('قانوني'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: _colors.bgSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _colors.borderDefault),
                ),
                child: Column(
                  children: [
                    _buildNavigationRow(
                      title: 'الشروط والأحكام',
                      icon: Icons.description_outlined,
                      onTap: () => _showLegalDialog(
                        title: 'الشروط والأحكام',
                        content:
                            'باستخدامك للتطبيق فإنك توافق على شروط الطلب والتوصيل المعتمدة لدى المتجر، وتُحسب رسوم الشحن وفق المحافظة المختارة.',
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: _colors.bgSubtle,
                    ),
                    _buildNavigationRow(
                      title: 'سياسة الخصوصية',
                      icon: Icons.verified_user_outlined,
                      onTap: () => _showLegalDialog(
                        title: 'سياسة الخصوصية',
                        content:
                            'نحترم خصوصيتك ونستخدم بيانات الحساب والعناوين لتنفيذ طلباتك وتحسين تجربة التسوق داخل التطبيق فقط.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // حذف الحساب
              InkWell(
                onTap: _confirmDeleteAccount,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: _colors.bgSurface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _colors.borderDefault),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'حذف الحساب',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _colors.statusDanger,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _colors.statusDangerBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: _colors.statusDanger,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: _colors.textTertiary,
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _colors.textOnBrand,
            activeTrackColor: _colors.brandBlue,
            inactiveThumbColor: _colors.bgSurface,
            inactiveTrackColor: _colors.actionDisabled,
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: _colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: _colors.textTertiary,
            ),
            const Spacer(),
            Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: _colors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _colors.statusInfoBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: _colors.brandBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}