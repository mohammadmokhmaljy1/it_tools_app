import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart' show tokenStorageProvider;
import '../storage/token_storage.dart';

enum AuthStatus { authenticated, guest }

class AuthStatusNotifier extends ChangeNotifier {
  final TokenStorage _tokenStorage;
  AuthStatus _status = AuthStatus.guest;

  AuthStatusNotifier(this._tokenStorage);

  late final Future<void> initialized = checkAuthStatus();

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isGuest => _status == AuthStatus.guest;

  /// فحص التوكن المخزن لتحديد هل المستخدم مسجل أم زائر
  Future<void> checkAuthStatus() async {
    String? token;
    try {
      token = await _tokenStorage.readAccessToken();
    } catch (_) {
      return;
    }
    final newStatus = (token != null && token.isNotEmpty)
        ? AuthStatus.authenticated
        : AuthStatus.guest;

    if (_status != newStatus) {
      _status = newStatus;
      notifyListeners();
    }
  }

  /// تحديث الحالة بعد تسجيل الدخول بنجاح (دون المساس ببيانات السلة المحلية)
  Future<void> setAuthenticated({
    required String accessToken,
    required String refreshToken,
  }) async {
    await initialized;
    await _tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  /// تسجيل الخروج والتحويل إلى زائر
  Future<void> setGuest() async {
    await initialized;
    await _tokenStorage.clear();
    sessionExpired();
  }

  void sessionExpired() {
    if (_status == AuthStatus.guest) return;
    _status = AuthStatus.guest;
    notifyListeners();
  }
}

final authStatusProvider = Provider<AuthStatusNotifier>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  final notifier = AuthStatusNotifier(storage);
  ref.onDispose(notifier.dispose);
  return notifier;
});
