import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LabeledCheckbox extends HookWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool value;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Checkbox(
              value: value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (_) {},
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF747980),
            ),
          ),
        ],
      ),
    );
  }
}
