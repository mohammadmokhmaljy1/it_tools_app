
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/theme_extension.dart';
import 'package:it_tools_app/features/about/presentation/pages/about_contact_page.dart';
import 'package:it_tools_app/features/addresses/presentation/pages/addresses_page.dart';
import 'package:it_tools_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:it_tools_app/features/orders/presentation/pages/orders_page.dart';
import 'package:it_tools_app/features/settings/presentation/pages/settings_page.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../providers/user_profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSquareIconButton(
                    colors: colors,
                    icon: Icons.arrow_forward_ios,
                    onTap: () => Navigator.pop(context),
                  ),
                  Text(
                    'حسابي',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.bgSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.borderDefault),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _showEditAccountSheet(context, ref, profile),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors.bgSubtle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: colors.brandBlue,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            profile.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile.email,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textSecondary,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.bgSubtle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              profile.affiliation,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colors.textLink,
                              ),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildUserAvatar(profile, colors),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      colors: colors,
                      count: '${profile.favoriteProducts}',
                      label: 'منتج بالمفضلة',
                      onTap: () => _showComingSoon(context, 'المفضلة'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      colors: colors,
                      count: '${profile.activeOrders}',
                      label: 'طلبات حالية',
                      onTap: () => _openOrdersPage(
                        context,
                        initialTabIndex: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      colors: colors,
                      count: '${profile.completedOrders}',
                      label: 'طلبات مكتملة',
                      onTap: () => _openOrdersPage(
                        context,
                        initialTabIndex: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildMenuGroup(
                colors: colors,
                items: [
                  _MenuItemData(
                    title: 'طلباتي',
                    icon: Icons.receipt_long_outlined,
                    onTap: () => _openOrdersPage(
                      context,
                      initialTabIndex: 0,
                    ),
                  ),
                  _MenuItemData(
                    title: 'عناويني',
                    icon: Icons.location_on_outlined,
                    onTap: () => _openPage(context, const AddressesPage()),
                  ),
                  _MenuItemData(
                    title: 'الكوبونات والعروض',
                    icon: Icons.confirmation_number_outlined,
                    onTap: () => _showComingSoon(context, 'الكوبونات والعروض'),
                  ),
                  _MenuItemData(
                    title: 'الإشعارات',
                    icon: Icons.notifications_none_rounded,
                    onTap: () => _openPage(context, const NotificationsPage()),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildMenuGroup(
                colors: colors,
                items: [
                  _MenuItemData(
                    title: 'الإعدادات',
                    icon: Icons.settings_outlined,
                    onTap: () => _openPage(context, const SettingsPage()),
                  ),
                  _MenuItemData(
                    title: 'تواصل معنا',
                    icon: Icons.phone_outlined,
                    onTap: () => _openPage(context, const AboutContactPage()),
                  ),
                  _MenuItemData(
                    title: 'عن المحيط',
                    icon: Icons.info_outline_rounded,
                    onTap: () => _showComingSoon(context, 'عن المحيط'),
                  ),
                  _MenuItemData(
                    title: 'الأسئلة الشائعة',
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () => _showComingSoon(context, 'الأسئلة الشائعة'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: () async {
                  await ref
                      .read(userProfileProvider.notifier)
                      .clearLocalAccount();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم مسح الحساب المحلي'),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.borderDefault),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colors.statusDanger,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colors.statusDangerBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: colors.statusDanger,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'الإصدار 2.3.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textTertiary,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showComingSoon(BuildContext context, String pageName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('صفحة $pageName قيد التجهيز')),
    );
  }

  Widget _buildUserAvatar(UserProfile profile, AppColors colors) {
    final googlePhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;

    final hasFile = profile.avatarPath != null &&
        profile.avatarPath!.trim().isNotEmpty &&
        File(profile.avatarPath!).existsSync();

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: colors.bgSubtle,
        shape: BoxShape.circle,
        border: Border.all(color: colors.borderDefault),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasFile
          ? Image.file(
              File(profile.avatarPath!),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  _buildInitialText(profile.initialLetter, colors),
            )
          : googlePhotoUrl != null && googlePhotoUrl.isNotEmpty
              ? Image.network(
                  googlePhotoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _buildInitialText(profile.initialLetter, colors),
                )
              : _buildInitialText(profile.initialLetter, colors),
    );
  }

  Widget _buildInitialText(String letter, AppColors colors) {
    return Center(
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colors.brandBlue,
        ),
      ),
    );
  }

  Widget _buildSquareIconButton({
    required AppColors colors,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
          icon,
          color: colors.textPrimary,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required AppColors colors,
    required String count,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: colors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.borderDefault),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.brandBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGroup({
    required AppColors colors,
    required List<_MenuItemData> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.bgSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.vertical(
                  top: index == 0
                      ? const Radius.circular(18)
                      : Radius.zero,
                  bottom: isLast
                      ? const Radius.circular(18)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 14,
                        color: colors.textTertiary,
                      ),
                      const Spacer(),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colors.bgSubtle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          size: 18,
                          color: colors.brandBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: colors.borderDefault,
                ),
            ],
          );
        }),
      ),
    );
  }

  void _openOrdersPage(
    BuildContext context, {
    required int initialTabIndex,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdersPage(
          initialTabIndex: initialTabIndex,
        ),
      ),
    );
  }

  void _showEditAccountSheet(
    BuildContext context,
    WidgetRef ref,
    UserProfile current,
  ) {
    final nameController = TextEditingController(text: current.name);
    final emailController = TextEditingController(text: current.email);
    final affiliationController =
        TextEditingController(text: current.affiliation);

    String? tempAvatarPath = current.avatarPath;
    bool clearAvatar = false;

    Future<void> pickFromGallery(StateSetter setModalState) async {
      final picker = ImagePicker();

      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final avatarsDir = Directory(
        p.join(appDir.path, 'avatars'),
      );

      if (!await avatarsDir.exists()) {
        await avatarsDir.create(recursive: true);
      }

      final ext = p.extension(picked.path).isNotEmpty
          ? p.extension(picked.path)
          : '.jpg';

      final savedFile = File(
        p.join(avatarsDir.path, 'user_avatar$ext'),
      );

      await File(picked.path).copy(savedFile.path);

      setModalState(() {
        tempAvatarPath = savedFile.path;
        clearAvatar = false;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        side: BorderSide(color: context.colors.borderDefault),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final colors = sheetContext.colors;

            final previewHasFile = !clearAvatar &&
                tempAvatarPath != null &&
                tempAvatarPath!.trim().isNotEmpty &&
                File(tempAvatarPath!).existsSync();

            final previewInitial = nameController.text.trim().isEmpty
                ? current.initialLetter
                : nameController.text.trim().characters.first;

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
                    'تعديل الحساب المحلي',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => pickFromGallery(setModalState),
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          size: 18,
                        ),
                        label: const Text('اختيار صورة'),
                      ),
                      if (previewHasFile) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempAvatarPath = null;
                              clearAvatar = true;
                            });
                          },
                          child: Text(
                            'إزالة الصورة',
                            style: TextStyle(color: colors.statusDanger),
                          ),
                        ),
                      ],
                      const SizedBox(width: 14),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: colors.bgSubtle,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.borderDefault),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: previewHasFile
                            ? Image.file(
                                File(tempAvatarPath!),
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                  previewInitial,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: colors.brandBlue,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.right,
                    onChanged: (_) => setModalState(() {}),
                    decoration: InputDecoration(
                      labelText: 'الاسم الكامل',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: affiliationController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'الكلية / الجهة',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty) return;

                      await ref
                          .read(userProfileProvider.notifier)
                          .saveAccount(
                            name: nameController.text,
                            email: emailController.text,
                            affiliation: affiliationController.text,
                            avatarPath: tempAvatarPath,
                            clearAvatar: clearAvatar,
                          );

                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.actionPrimary,
                      foregroundColor: colors.textOnBrand,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'حفظ التعديلات محلياً',
                      style: TextStyle(
                        fontSize: 15,
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
}

class _MenuItemData {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _MenuItemData({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
