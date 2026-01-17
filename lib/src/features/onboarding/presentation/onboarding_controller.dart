import 'package:nutrify/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:nutrify/src/features/onboarding/data/user_profile_repository.dart';
import 'package:nutrify/src/features/onboarding/domain/user_profile_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() => null;

  Future<void> completeOnboarding(UserProfileModel profile) async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return;

    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userProfileRepositoryProvider);
      
      await repository.saveProfile(
        user.uid,
        profile.copyWith(isOnboardingComplete: true),
      );
      
      // Notify the profile provider to update the app state
      ref.invalidate(userProfileProvider);
    });
  }
}