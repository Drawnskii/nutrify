import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nutrify/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:nutrify/src/features/onboarding/data/user_profile_repository.dart';

part 'app_router_notifier.g.dart';

@riverpod
class AppRouterNotifier extends _$AppRouterNotifier implements Listenable {
  final List<VoidCallback> _listeners = [];

  @override
  void build() {
    // FIX: Using (_, _) instead of (_, __) to satisfy the linter
    // Listen to auth changes
    ref.listen(authStateChangesProvider, (_, _) => _notify());
    // Listen to profile/onboarding changes
    ref.listen(userProfileProvider, (_, _) => _notify());
  }

  void _notify() {
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  void addListener(VoidCallback listener) => _listeners.add(listener);

  @override
  void removeListener(VoidCallback listener) => _listeners.remove(listener);
}