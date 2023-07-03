import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AsyncButton extends HookWidget {
  const AsyncButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final Future<void> Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    if (isLoading.value) {
      return const ElevatedButton(
        onPressed: null,
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return ElevatedButton(
      onPressed: () async {
        try {
          isLoading.value = true;
          await onPressed();
        } finally {
          isLoading.value = false;
        }
      },
      child: child,
    );
  }
}
