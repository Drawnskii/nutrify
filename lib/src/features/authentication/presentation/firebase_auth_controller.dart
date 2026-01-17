import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nutrify/src/features/authentication/data/firebase_auth_repository.dart';

part 'firebase_auth_controller.g.dart';

@riverpod
class FirebaseAuthController extends _$FirebaseAuthController {
  @override
  FutureOr<void> build() {
    // Nothing to initialize here
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => 
      ref.read(firebaseAuthRepositoryProvider).signIn(email, password)
    );
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    // FIX: Use an async block {} instead of an arrow => to run multiple statements
    state = await AsyncValue.guard(() async {
      // 1. Create the user
      await ref.read(firebaseAuthRepositoryProvider).signUp(email, password);
      
      // 2. Send verification email immediately after successful sign up
      // We get the current user instance from the provider
      final user = ref.read(firebaseAuthProvider).currentUser;
      await user?.sendEmailVerification();
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
      ref.read(firebaseAuthRepositoryProvider).signOut()
    );
  }
}