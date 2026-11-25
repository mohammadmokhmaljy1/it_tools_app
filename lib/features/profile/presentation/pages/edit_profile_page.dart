import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// عدّلي هذا المسار ليشير إلى ملف user_profile_provider.dart في مشروعك
import '../providers/user_profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
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
  await ref
      .read(userProfileProvider.notifier)
      .pickAvatarFromGallery();

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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
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
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'اختر الجامعة أو المعهد',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
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
                                          ? const Color(0xFF0578B7)
                                          : const Color(0xFF0F172A),
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
                                  activeColor: const Color(0xFF0578B7),
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
                      backgroundColor: const Color(0xFF0578B7),
                      padding: const EdgeInsets.symmetric(vertical: 15),
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
                        color: Colors.white,
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
      backgroundColor: const Color(0xFFF4FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBFF),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            color: Color(0xFF0F172A),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // الصورة الرمزية أو الحرف الأول وزر تغيير الصورة
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6EEF8),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFBAE6FD)),
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
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0578B7),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _pickImage,
                        child: const Text(
                          'تغيير الصورة',
                          style: TextStyle(
                            color: Color(0xFF0578B7),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // الاسم الكامل
                _buildFieldLabel('الاسم الكامل'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textAlign: TextAlign.right,
                  onChanged: (_) => setState(() {}),
                  decoration: _inputDecoration(
                    suffixIcon: Icons.person_outline,
                    fillColor: Colors.white,
                    borderColor: const Color(0xFFD0E1ED),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال الاسم الكامل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // البريد الإلكتروني (غير قابل للتعديل)
                _buildFieldLabel('البريد الإلكتروني'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  enabled: false,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration(
                    suffixIcon: Icons.mail_outline,
                    iconColor: const Color(0xFF94A3B8),
                    fillColor: const Color(0xFFF1F5F9),
                    borderColor: const Color(0xFFE2E8F0),
                  ),
                ),
                const SizedBox(height: 16),

                // رقم الموبايل
                _buildFieldLabel('رقم الموبايل'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.right,
                  decoration: _inputDecoration(
                    suffixIcon: Icons.phone_outlined,
                    fillColor: Colors.white,
                    borderColor: const Color(0xFFD0E1ED),
                  ),
                ),
                const SizedBox(height: 16),

                // الجامعة / المعهد
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
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF475569),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD0E1ED)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF0578B7),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      _selectedUniversity ?? '',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ملاحظة البريد وكلمة المرور
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'لا يمكن تغيير البريد الإلكتروني لأنه مرتبط بحسابك. لتغيير كلمة المرور اذهب إلى الإعدادات.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF0578B7),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF0578B7),
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // زر حفظ التغييرات
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0578B7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'حفظ التغييرات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required IconData suffixIcon,
    required Color fillColor,
    required Color borderColor,
    Color iconColor = const Color(0xFF64748B),
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: fillColor,
      suffixIcon: Icon(suffixIcon, color: iconColor, size: 20),
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
        borderSide: const BorderSide(color: Color(0xFF0578B7), width: 1.5),
      ),
    );
  }
}