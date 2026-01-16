import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrify/src/features/authentication/presentation/firebase_auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuthState = ref.watch(firebaseAuthControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: !firebaseAuthState.isLoading,
            ),
            TextField(  
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              enabled: !firebaseAuthState.isLoading,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: firebaseAuthState.isLoading
                ? null
                : () => ref.read(firebaseAuthControllerProvider.notifier).signUp(
                    _emailController.text, 
                    _emailController.text
                  ),
              child: firebaseAuthState.isLoading
                ? const CircularProgressIndicator()
                : const Text('Sign Up')
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.pop();
              }, 
              child: const Text('Already have an account? Sign In here')
            ),
          ],
        ),
      ),
    );
  }
}