import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrify/src/features/authentication/presentation/firebase_auth_controller.dart';
import 'package:nutrify/src/features/authentication/presentation/firebase_email_verification_controller.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    // Start automated check on entry
    Future.microtask(() => 
      ref.read(firebaseEmailVerificationControllerProvider.notifier).startVerificationCheck()
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors (like "Not verified yet" message)
    ref.listen(firebaseEmailVerificationControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        ),
      );
    });

    final firebaseAuthState = ref.watch(firebaseAuthControllerProvider);
    final verificationState = ref.watch(firebaseEmailVerificationControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your account'),
        actions: [
          IconButton(
            onPressed: firebaseAuthState.isLoading
              ? null 
              : () => ref.read(firebaseAuthControllerProvider.notifier).signOut(), 
            icon: firebaseAuthState.isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 100, color: Colors.blue),
            const SizedBox(height: 32),
            Text('Almost there!', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            const Text(
              'We\'ve sent you a verification link to your email. Please check it to continue.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // MANUAL CHECK BUTTON
            FilledButton(
              onPressed: verificationState.isLoading
                  ? null
                  : () => ref.read(firebaseEmailVerificationControllerProvider.notifier).checkVerificationStatus(),
              child: verificationState.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('I already verified my email'),
            ),
            
            const SizedBox(height: 16),
            
            // RESEND BUTTON
            TextButton.icon(
              onPressed: verificationState.isLoading
                ? null
                : () => ref.read(firebaseEmailVerificationControllerProvider.notifier).sendVerificationEmail(),
              icon: const Icon(Icons.email),
              label: const Text('Resend verification email'),
            )
          ],
        ),  
      ),
    );
  }
}