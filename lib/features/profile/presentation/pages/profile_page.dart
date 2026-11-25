
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_tools_app/features/orders/presentation/pages/orders_page.dart';
import 'package:it_tools_app/features/addresses/presentation/pages/addresses_page.dart';
import 'package:it_tools_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:it_tools_app/features/settings/presentation/pages/settings_page.dart';
import 'package:it_tools_app/features/about/presentation/pages/about_contact_page.dart';

import '../providers/user_profile_provider.dart';
import 'edit_profile_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBFF),
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
                    icon: Icons.arrow_forward_ios,
                    iconColor: const Color(0xFF1E293B),
                    iconSize: 16,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Text(
                    'حسابي',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2EEF5)),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _openEditProfilePage(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF0578B7),
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile.email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
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
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              profile.affiliation,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0578B7),
                              ),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildUserAvatar(profile),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      count: '${profile.favoriteProducts}',
                      label: 'منتج بالمفضلة',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressesPage(),
                        ),
                      );
                    },
                  ),
                  _MenuItemData(
                    title: 'الكوبونات والعروض',
                    icon: Icons.confirmation_number_outlined,
                    onTap: () {},
                  ),
                  _MenuItemData(
                    title: 'الإشعارات',
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildMenuGroup(
                items: [
                  _MenuItemData(
                    title: 'الإعدادات',
                    icon: Icons.settings_outlined,
                    onTap: () {
  debugPrint('SETTINGS BUTTON PRESSED');

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => const SettingsPage(),
    ),
  );
},
                  ),
                 _MenuItemData(
  title: 'تواصل معنا',
  icon: Icons.phone_outlined,
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AboutContactPage(),
      ),
    );
  },
),
                  _MenuItemData(
                    title: 'عن المحيط',
                    icon: Icons.info_outline_rounded,
                    onTap: () {},
                  ),
                  _MenuItemData(
                    title: 'الأسئلة الشائعة',
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {},
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2EEF5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Color(0xFFD32F2F),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'الإصدار 2.3.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(UserProfile profile) {
    final googlePhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;

    final hasFile = profile.avatarPath != null &&
        profile.avatarPath!.trim().isNotEmpty &&
        File(profile.avatarPath!).existsSync();

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFD6EEF8),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasFile
          ? Image.file(
              File(profile.avatarPath!),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildInitialText(profile.initialLetter);
              },
            )
          : googlePhotoUrl != null && googlePhotoUrl.isNotEmpty
              ? Image.network(
                  googlePhotoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildInitialText(profile.initialLetter);
                  },
                )
              : _buildInitialText(profile.initialLetter),
    );
  }

  Widget _buildInitialText(String letter) {
    return Center(
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0578B7),
        ),
      ),
    );
  }

  Widget _buildSquareIconButton({
    required IconData icon,
    required Color iconColor,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD0E1ED)),
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }

  Widget _buildStatCard({
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2EEF5)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0578B7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGroup({
    required List<_MenuItemData> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EEF5)),
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
                      const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      const Spacer(),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          size: 18,
                          color: const Color(0xFF0578B7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Color(0xFFF1F5F9),
                ),
            ],
          );
        }),
      ),
    );
  }

  void _openEditProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
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
