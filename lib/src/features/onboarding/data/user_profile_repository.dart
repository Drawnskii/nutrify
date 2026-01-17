import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrify/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nutrify/src/features/onboarding/domain/user_profile_model.dart';

part 'user_profile_repository.g.dart';
  
class UserProfileRepository {
  UserProfileRepository(this._db);
  final FirebaseFirestore _db;

  Future<void> saveProfile(String uid, UserProfileModel profile) async {
    await _db.collection('users').doc(uid).set(profile.toJson());
  }

  Future<UserProfileModel?> getProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    final data = doc.data();

    if (data != null) {
      return UserProfileModel.fromJson(data);
    }

    return null;
  }
}

@riverpod
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  final fireStoreInstance = ref.watch(firestoreProvider);

  return UserProfileRepository(fireStoreInstance);
}

@riverpod
Future<UserProfileModel?> userProfile(Ref ref) async {
  final firebaseAuthState = ref.watch(authStateChangesProvider).value;
  
  if (firebaseAuthState == null) return null;

  final userProfileRepository = ref.watch(userProfileRepositoryProvider);

  return userProfileRepository.getProfile(firebaseAuthState.uid);
}