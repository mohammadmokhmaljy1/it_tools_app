
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String affiliation;
  final String? avatarPath;
  final int completedOrders;
  final int activeOrders;
  final int favoriteProducts;

  const UserProfile({
    required this.name,
    required this.email,
    this.phone = '',
    required this.affiliation,
    this.avatarPath,
    this.completedOrders = 5,
    this.activeOrders = 2,
    this.favoriteProducts = 12,
  });

  String get initialLetter {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'م';
    return trimmed.characters.first;
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? affiliation,
    String? avatarPath,
    bool clearAvatar = false,
    int? completedOrders,
    int? activeOrders,
    int? favoriteProducts,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      affiliation: affiliation ?? this.affiliation,
      avatarPath: clearAvatar ? null : (avatarPath ?? this.avatarPath),
      completedOrders: completedOrders ?? this.completedOrders,
      activeOrders: activeOrders ?? this.activeOrders,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'affiliation': affiliation,
      'avatarPath': avatarPath,
      'completedOrders': completedOrders,
      'activeOrders': activeOrders,
      'favoriteProducts': favoriteProducts,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final user = FirebaseAuth.instance.currentUser;

    final firebaseName = user?.displayName?.trim();
    final firebaseEmail = user?.email?.trim();

    return UserProfile(
      name: (firebaseName != null && firebaseName.isNotEmpty)
          ? firebaseName
          : ((map['name'] as String?)?.trim().isNotEmpty == true
              ? map['name'] as String
              : 'مستخدم'),
      email: (firebaseEmail != null && firebaseEmail.isNotEmpty)
          ? firebaseEmail
          : ((map['email'] as String?)?.trim().isNotEmpty == true
              ? map['email'] as String
              : ''),
      phone: (map['phone'] as String?) ?? '',
      affiliation: (map['affiliation'] as String?)?.trim().isNotEmpty == true
          ? map['affiliation'] as String
          : 'كلية المعلوماتية - جامعة حلب',
      avatarPath: map['avatarPath'] as String?,
      completedOrders: (map['completedOrders'] as int?) ?? 5,
      activeOrders: (map['activeOrders'] as int?) ?? 2,
      favoriteProducts: (map['favoriteProducts'] as int?) ?? 12,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  static const String _storageKey = 'it_tools_saved_user_profile_v1';

  final ImagePicker _picker = ImagePicker();

  UserProfileNotifier()
      : super(
          UserProfile(
            name: FirebaseAuth.instance.currentUser?.displayName ?? 'مستخدم',
            email: FirebaseAuth.instance.currentUser?.email ?? '',
            affiliation: 'كلية المعلوماتية - جامعة حلب',
          ),
        ) {
    _loadFromLocalStorage();
  }

  Future<void> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final user = FirebaseAuth.instance.currentUser;
    debugPrint(
      'FIREBASE PROFILE: name=${user?.displayName}, email=${user?.email}',
    );

    final rawJson = prefs.getString(_storageKey);

    if (rawJson == null || rawJson.isEmpty) return;

    try {
      final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
      state = UserProfile.fromMap(decoded);
    } catch (e) {
      debugPrint('PROFILE STORAGE ERROR: $e');
    }
  }

  Future<void> _saveToLocalStorage(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(profile.toMap()));
  }

  Future<String?> pickAvatarFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final avatarsDir = Directory(p.join(appDir.path, 'avatars'));

    if (!await avatarsDir.exists()) {
      await avatarsDir.create(recursive: true);
    }

    final ext = p.extension(picked.path).isNotEmpty
        ? p.extension(picked.path)
        : '.jpg';

    final savedFile = File(p.join(avatarsDir.path, 'user_avatar$ext'));
    await File(picked.path).copy(savedFile.path);

    return savedFile.path;
  }

  Future<void> saveAccount({
    required String name,
    required String email,
    String? phone,
    required String affiliation,
    String? avatarPath,
    bool clearAvatar = false,
  }) async {
    final updated = state.copyWith(
      name: name.trim(),
      email: email.trim(),
      phone: phone?.trim() ?? state.phone,
      affiliation: affiliation.trim(),
      avatarPath: avatarPath,
      clearAvatar: clearAvatar,
    );

    state = updated;
    await _saveToLocalStorage(updated);
  }

  Future<void> clearLocalAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);

    final user = FirebaseAuth.instance.currentUser;

    state = UserProfile(
      name: user?.displayName ?? 'مستخدم',
      email: user?.email ?? '',
      phone: '',
      affiliation: 'حساب محلي',
      completedOrders: 0,
      activeOrders: 0,
      favoriteProducts: 0,
    );
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
