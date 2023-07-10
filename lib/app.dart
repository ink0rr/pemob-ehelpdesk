import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'constants.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/user.dart';
import 'theme.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    auth.authStateChanges().listen((user) {
      ref.read(userProvider.notifier).state = user;
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.themeData,
      home: auth.currentUser != null ? const HomePage() : const LoginPage(),
    );
  }
}
