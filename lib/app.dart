import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/shell/home_shell.dart';
import 'features/onboarding/onboarding_screen.dart';

class BackFortyApp extends StatelessWidget {
  const BackFortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Back Forty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const AppRoot(),
    );
  }
}

/// First-run gate: onboarding once, the app forever after.
class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seen = ref.watch(firstRunSeenProvider).value;
    return switch (seen) {
      // One blank frame while the flag loads beats flashing onboarding
      // at returning users.
      null => const Scaffold(body: SizedBox.shrink()),
      false => const OnboardingScreen(),
      true => const HomeShell(),
    };
  }
}
