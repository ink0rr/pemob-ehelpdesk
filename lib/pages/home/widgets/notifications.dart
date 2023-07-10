import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Notifications extends HookConsumerWidget {
  const Notifications({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: TabBar(
          controller: controller,
          tabs: const [
            Tab(
              child: Text(
                'Umum',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Sistem',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
