import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/theme_extension.dart';
import '../providers/user_profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  AppColors get _colors => context.colors;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  String? _selectedUniversity;
  String? _tempAvatarPath;
  bool _clearAvatar = false;
  bool _isSaving = false;

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
  void initState() {
    super.initState();
    final current = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: current.name);
    _emailController = TextEditingController(text: current.email);
    _phoneController = TextEditingController(text: current.phone);
    _tempAvatarPath = current.avatarPath;

    if (current.affiliation.trim().isNotEmpty) {
      if (!_universities.contains(current.affiliation)) {
        _universities.insert(0, current.affiliation);
      }
      _selectedUniversity = current.affiliation;
    } else {
      _selectedUniversity = _universities[2];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    await ref.read(userProfileProvider.notifier).pickAvatarFromGallery();

    final savedPath = ref.read(userProfileProvider).avatarPath;

    if (savedPath == null || !mounted) return;

    setState(() {
      _tempAvatarPath = savedPath;
      _clearAvatar = false;
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    await ref.read(userProfileProvider.notifier).saveAccount(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          affiliation: _selectedUniversity ?? 'كلية المعلوماتية - جامعة حلب',
          avatarPath: _tempAvatarPath,
          clearAvatar: _clearAvatar,
        );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
    );
    Navigator.pop(context);
  }

  void _showUniversityPickerBottomSheet() {
    String? tempSelected = _selectedUniversity;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final colors = context.colors;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.borderStrong,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: colors.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'اختر الجامعة أو المعهد',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'تأكيد الاختيار',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textOnBrand,
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
    final current = ref.watch(userProfileProvider);
    final previewName = _nameController.text.trim();
    final initialLetter = previewName.isNotEmpty
        ? previewName.characters.first
        : current.initialLetter;

    final hasAvatarFile = !_clearAvatar &&
        _tempAvatarPath != null &&
        _tempAvatarPath!.trim().isNotEmpty &&
        File(_tempAvatarPath!).existsSync();

    return Scaffold(
      backgroundColor: colors.bgPage,
      appBar: AppBar(
        backgroundColor: colors.bgPage,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'تعديل الملف الشخصي',
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: colors.bgSubtle,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.borderStrong),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: hasAvatarFile
                            ? Image.file(
                                File(_tempAvatarPath!),
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                  initialLetter,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: colors.brandBlue,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _pickImage,
                        child: Text(
                          'تغيير الصورة',
                          style: TextStyle(
                            color: colors.brandBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                _buildFieldLabel('الاسم الكامل'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textAlign: TextAlign.right,
                  onChanged: (_) => setState(() {}),
                  decoration: _inputDecoration(
                    suffixIcon: Icons.person_outline,
                    fillColor: colors.bgSurface,
                    borderColor: colors.borderDefault,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال الاسم الكامل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildFieldLabel('البريد الإلكتروني'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  enabled: false,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: colors.textTertiary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration(
                    suffixIcon: Icons.mail_outline,
                    iconColor: colors.textTertiary,
                    fillColor: colors.bgSubtle,
                    borderColor: colors.borderDefault,
                  ),
                ),
                const SizedBox(height: 16),

                _buildFieldLabel('رقم الموبايل'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.right,
                  decoration: _inputDecoration(
                    suffixIcon: Icons.phone_outlined,
                    fillColor: colors.bgSurface,
                    borderColor: colors.borderDefault,
                  ),
                ),
                const SizedBox(height: 16),

                _buildFieldLabel('الجامعة / المعهد'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _showUniversityPickerBottomSheet,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      filled: true,
                      fillColor: colors.bgSurface,
                      prefixIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: colors.textSecondary,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colors.brandBlue,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      _selectedUniversity ?? '',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.statusInfoBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'لا يمكن تغيير البريد الإلكتروني لأنه مرتبط بحسابك. لتغيير كلمة المرور اذهب إلى الإعدادات.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: colors.statusInfo,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.info_outline_rounded,
                        color: colors.statusInfo,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.actionPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colors.textOnBrand,
                            ),
                          )
                        : Text(
                            'حفظ التغييرات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.textOnBrand,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: _colors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required IconData suffixIcon,
    required Color fillColor,
    required Color borderColor,
    Color? iconColor,
  }) {
    final colors = _colors;
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: fillColor,
      suffixIcon: Icon(
        suffixIcon,
        color: iconColor ?? colors.textSecondary,
        size: 20,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.brandBlue, width: 1.5),
      ),
    );
  }
}
