import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nutrify/src/features/authentication/domain/user_model.dart';

part 'firebase_auth_repository.g.dart';

class FirebaseAuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) =>
      user != null ? UserModel(uid: user.uid, email: user.email, displayName: user.displayName, photoURL: user.photoURL) : null
    );
  }

  Future<void> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@riverpod
FirebaseAuthRepository firebaseAuthRepository(Ref ref) {
  return FirebaseAuthRepository(ref.watch(firebaseAuthProvider));
}

@riverpod
Stream<UserModel?> authStateChanges(Ref ref) {
  return ref.watch(firebaseAuthRepositoryProvider).authStateChanges();
}