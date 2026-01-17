import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nutrify/src/features/authentication/data/firebase_auth_repository.dart';

part 'firebase_email_verification_controller.g.dart';

@riverpod
class FirebaseEmailVerificationController extends _$FirebaseEmailVerificationController {
  Timer? _timer;

  @override
  FutureOr<void> build() {
    // If the controller is disposed, cancel the timer
    ref.onDispose(() => _timer?.cancel());
  }

  void startVerificationCheck() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final auth = ref.read(firebaseAuthProvider);
      await auth.currentUser?.reload();
      
      final isVerified = auth.currentUser?.emailVerified ?? false;
      if (isVerified) {
        timer.cancel();
        // Force the auth stream to emit the new state
        ref.invalidate(authStateChangesProvider);
      }
    });
  }

  Future<void> sendVerificationEmail() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(firebaseAuthProvider).currentUser?.sendEmailVerification();
    });
  }

  Future<void> checkVerificationStatus() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(firebaseAuthProvider);
      await auth.currentUser?.reload();

      if (auth.currentUser?.emailVerified ?? false) {
        // Success: Trigger router re-evaluation
        ref.invalidate(authStateChangesProvider);
      } else {
        // Fallback: Notify the user that it's still not verified
        throw Exception('Email not verified yet. Please check your inbox.');
      }
    });
  }
}