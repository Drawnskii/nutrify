import 'package:go_router/go_router.dart';
import 'package:nutrify/routes/app_router_notifier.dart';
import 'package:nutrify/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:nutrify/src/features/authentication/presentation/verify_email_screen.dart';
import 'package:nutrify/src/features/onboarding/data/user_profile_repository.dart';
import 'package:nutrify/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nutrify/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:nutrify/src/features/authentication/presentation/sign_in_screen.dart';
import 'package:nutrify/src/features/home/presentation/home_screen.dart';

part 'app_routes.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  // Use 'appRouterProvider' (generated from AppRouterNotifier)
  final notifier = ref.watch(appRouterProvider.notifier);

  return GoRouter(
    initialLocation: '/signin',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);
      
      // Handle loading/error states
      if (authState.isLoading || authState.hasError) return null;

      final user = authState.value;
      final isSignedIn = user != null;
      
      final isSigningIn = state.matchedLocation == '/signin';
      final isSigningUp = state.matchedLocation == '/signup';

      // 1. Unauthenticated users
      if (!isSignedIn) {
        return (isSigningIn || isSigningUp) ? null : '/signin';
      }
      
      // 2. Email verification check
      // We read directly from Firebase instance to get the freshest flag
      final isEmailVerified = ref.read(firebaseAuthProvider).currentUser?.emailVerified ?? false;
      final isVerifyingEmail = state.matchedLocation == '/verify-email';

      if (!isEmailVerified) {
        return isVerifyingEmail ? null : '/verify-email';
      }

      // 3. Profile/Onboarding check
      final userProfile = ref.read(userProfileProvider);
      if (userProfile.isLoading) return null;

      final profile = userProfile.value;
      final isOnboardingComplete = profile?.isOnboardingComplete ?? false;
      final isGoingToOnboarding = state.matchedLocation == '/onboarding';

      if (!isOnboardingComplete) {
        return isGoingToOnboarding ? null : '/onboarding';
      }

      // 4. Redirect to home if user is at an auth route but already verified/onboarded
      final isAtAuthRoute = isSigningIn || isSigningUp || isVerifyingEmail || isGoingToOnboarding;
      if (isAtAuthRoute) return '/home';

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
        path: '/verify-email',
        name: 'verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ]
  );
}