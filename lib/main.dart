import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/branding/app_theme.dart';
import 'core/routing/router.dart';
import 'core/security/app_security.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive/SecureStorage here
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Security Checks
  await AppSecurity.enableSecureMode(); // Block Screenshots
  
  runApp(const ProviderScope(child: FairAddaApp()));
}

class FairAddaApp extends ConsumerWidget {
  const FairAddaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'FAIR ADDA',
      theme: FairAddaTheme.darkTheme,
      themeMode: ThemeMode.dark, // Enforce Dark Mode
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
