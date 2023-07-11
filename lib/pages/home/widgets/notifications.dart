import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Notifications extends HookWidget {
  const Notifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: TabBar(
          controller: controller,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
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
