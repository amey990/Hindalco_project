import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import 'user_service.dart';

class CurrentUserStore {
  const CurrentUserStore._();

  static final ValueNotifier<AppUser?> user = ValueNotifier<AppUser?>(null);
  static Future<AppUser?>? _pendingLoad;

  static Future<AppUser?> load({bool forceRefresh = false}) {
    if (!forceRefresh && user.value != null) {
      return Future.value(user.value);
    }

    if (!forceRefresh && _pendingLoad != null) {
      return _pendingLoad!;
    }

    _pendingLoad = UserService()
        .getCurrentUser()
        .then((loadedUser) {
          user.value = loadedUser;
          return loadedUser;
        })
        .whenComplete(() => _pendingLoad = null);

    return _pendingLoad!;
  }

  static void setUser(AppUser? appUser) {
    user.value = appUser;
  }

  static void clear() {
    user.value = null;
    _pendingLoad = null;
  }
}
