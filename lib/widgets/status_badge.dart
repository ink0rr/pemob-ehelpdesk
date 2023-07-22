import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StatusBadge extends HookWidget {
  const StatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: switch (status) {
          'RESOLVED' => Colors.green,
          'OPEN' => Colors.blue,
          'CLOSED' => Colors.red,
          _ => Colors.grey
        },
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(
          status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
