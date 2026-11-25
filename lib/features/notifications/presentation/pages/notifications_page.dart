import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NotificationSection { today, earlier }

enum NotificationBadgeType { gift, flash, coupon, shipping }

class AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationSection section;
  final NotificationBadgeType badgeType;
  final bool isUnread;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.section,
    required this.badgeType,
    this.isUnread = false,
  });

  AppNotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    String? timeAgo,
    NotificationSection? section,
    NotificationBadgeType? badgeType,
    bool? isUnread,
  }) {
    return AppNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timeAgo: timeAgo ?? this.timeAgo,
      section: section ?? this.section,
      badgeType: badgeType ?? this.badgeType,
      isUnread: isUnread ?? this.isUnread,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timeAgo': timeAgo,
      'section': section.name,
      'badgeType': badgeType.name,
      'isUnread': isUnread,
    };
  }

  factory AppNotificationItem.fromMap(Map<String, dynamic> map) {
    return AppNotificationItem(
      id: (map['id'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      body: (map['body'] as String?) ?? '',
      timeAgo: (map['timeAgo'] as String?) ?? '',
      section: NotificationSection.values.firstWhere(
        (e) => e.name == map['section'],
        orElse: () => NotificationSection.earlier,
      ),
      badgeType: NotificationBadgeType.values.firstWhere(
        (e) => e.name == map['badgeType'],
        orElse: () => NotificationBadgeType.coupon,
      ),
      isUnread: (map['isUnread'] as bool?) ?? false,
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const String _storageKey = 'it_tools_notifications_v1';

  List<AppNotificationItem> _items = const [
    AppNotificationItem(
      id: '1',
      title: 'عرض خاص لجامعتك 🎓',
      body:
          'كوبون UNI15 بخصم 15% لطلاب كلية المعلوماتية - جامعة حلب حتى 30 تشرين الثاني.',
      timeAgo: 'منذ ساعة',
      section: NotificationSection.today,
      badgeType: NotificationBadgeType.gift,
      isUnread: true,
    ),
    AppNotificationItem(
      id: '2',
      title: 'عروض اليوم بدأت!',
      body:
          'خصومات حتى 30% على الكيبوردات والسماعات لمدة 24 ساعة فقط.',
      timeAgo: 'منذ 5 ساعات',
      section: NotificationSection.today,
      badgeType: NotificationBadgeType.flash,
      isUnread: true,
    ),
    AppNotificationItem(
      id: '3',
      title: 'كوبون جديد',
      body: 'استخدم WELCOME5 للحصول على خصم 5\$ على أول طلب فوق 40\$.',
      timeAgo: 'أمس',
      section: NotificationSection.earlier,
      badgeType: NotificationBadgeType.coupon,
      isUnread: false,
    ),
    AppNotificationItem(
      id: '4',
      title: 'شحن مجاني',
      body: 'توصيل مجاني لكل المحافظات على الطلبات فوق 75\$ هذا الأسبوع.',
      timeAgo: 'منذ 3 أيام',
      section: NotificationSection.earlier,
      badgeType: NotificationBadgeType.shipping,
      isUnread: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final loaded = decoded
          .map((e) => AppNotificationItem.fromMap(e as Map<String, dynamic>))
          .toList();
      if (loaded.isNotEmpty && mounted) {
        setState(() {
          _items = loaded;
        });
      }
    } catch (e) {
      debugPrint('NOTIFICATIONS LOAD ERROR: $e');
    }
  }

  Future<void> _saveNotifications(List<AppNotificationItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(list.map((e) => e.toMap()).toList()),
    );
  }

  Future<void> _markAsRead(String id) async {
    final updated = _items
        .map((item) => item.id == id ? item.copyWith(isUnread: false) : item)
        .toList();
    setState(() {
      _items = updated;
    });
    await _saveNotifications(updated);
  }

  @override
  Widget build(BuildContext context) {
    final todayItems =
        _items.where((e) => e.section == NotificationSection.today).toList();
    final earlierItems =
        _items.where((e) => e.section == NotificationSection.earlier).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FBFF),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'الإشعارات',
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (todayItems.isNotEmpty) ...[
                _buildSectionHeader('اليوم'),
                const SizedBox(height: 8),
                ...todayItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildNotificationCard(item),
                  ),
                ),
                const SizedBox(height: 4),
              ],
              if (earlierItems.isNotEmpty) ...[
                _buildSectionHeader('سابقاً'),
                const SizedBox(height: 8),
                ...earlierItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildNotificationCard(item),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'نرسل الإشعارات للعروض والكوبونات فقط. تابع حالة طلباتك من صفحة «طلباتي».',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF0578B7),
                          fontSize: 12.5,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF64748B),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotificationItem item) {
    return InkWell(
      onTap: () => _markAsRead(item.id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2EEF5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.isUnread) ...[
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.body,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.timeAgo,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildBadgeIcon(item.badgeType),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(NotificationBadgeType type) {
    Color bgColor;
    Color iconColor;
    IconData iconData;

    switch (type) {
      case NotificationBadgeType.gift:
        bgColor = const Color(0xFFFEF3C7);
        iconColor = const Color(0xFFD97706);
        iconData = Icons.card_giftcard_rounded;
        break;
      case NotificationBadgeType.flash:
        bgColor = const Color(0xFFE0F2FE);
        iconColor = const Color(0xFF0578B7);
        iconData = Icons.bolt_rounded;
        break;
      case NotificationBadgeType.coupon:
        bgColor = const Color(0xFFE0F2FE);
        iconColor = const Color(0xFF0578B7);
        iconData = Icons.confirmation_number_outlined;
        break;
      case NotificationBadgeType.shipping:
        bgColor = const Color(0xFFE0F2FE);
        iconColor = const Color(0xFF0578B7);
        iconData = Icons.local_shipping_outlined;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 22,
      ),
    );
  }
}