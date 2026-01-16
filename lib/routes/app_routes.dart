import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrify/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nutrify/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:nutrify/src/features/authentication/presentation/sign_in_screen.dart';
import 'package:nutrify/src/features/home/presentation/home_screen.dart';

part 'app_routes.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final firebaseAuthState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/signin',
    refreshListenable: Listenable.merge([]),
    redirect: (context, state) {
      final isSignedIn = firebaseAuthState.value != null;
      
      // Public Routes
      final isSigningIn = state.matchedLocation == '/signin';
      final isSigningUp = state.matchedLocation == '/signup';

      if (!isSignedIn && !isSigningIn && !isSigningUp) return '/signin';
      if (isSignedIn && (isSigningIn || isSigningUp)) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/signin',
        name: 'signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ]
  );
}