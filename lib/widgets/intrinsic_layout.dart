import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class IntrinsicLayout extends HookWidget {
  const IntrinsicLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: child,
          ),
        ),
      ),
    );
  }
}
