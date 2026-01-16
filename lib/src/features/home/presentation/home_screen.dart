import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrify/src/features/authentication/presentation/firebase_auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuthState = ref.watch(firebaseAuthControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: firebaseAuthState.isLoading
              ? null
              : () => ref.read(firebaseAuthControllerProvider.notifier).signOut(), 
            icon: firebaseAuthState.isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome!')),
    );
  }
}
