import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrify/src/features/authentication/presentation/firebase_auth_controller.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  
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

    ref.listen<AsyncValue<void>>(firebaseAuthControllerProvider, (_, state) {
      state.whenOrNull(error: (err, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In'),),
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
                : () => ref.read(firebaseAuthControllerProvider.notifier).signIn(
                    _emailController.text,
                    _passwordController.text
                  ),
              child: firebaseAuthState.isLoading
                ? const CircularProgressIndicator()
                : const Text('Sign In'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  context.pushNamed('signup');
                }, 
                child: const Text('Don\'t have an account? Sign Up here')
              ),
            ],
          ),
      ),
    );
  }
}