// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FirebaseAuthController)
final firebaseAuthControllerProvider = FirebaseAuthControllerProvider._();

final class FirebaseAuthControllerProvider
    extends $AsyncNotifierProvider<FirebaseAuthController, void> {
  FirebaseAuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAuthControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthControllerHash();

  @$internal
  @override
  FirebaseAuthController create() => FirebaseAuthController();
}

String _$firebaseAuthControllerHash() =>
    r'3295420fcae6218dd7742dcb4034042400ccb1b2';

abstract class _$FirebaseAuthController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
