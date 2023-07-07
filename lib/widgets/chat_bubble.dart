import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatBubble extends HookWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.isSender,
  });

  final String message;
  final bool? isSender;

  @override
  Widget build(BuildContext context) {
    if (isSender == true) {
      return Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsetsDirectional.only(
          start: 64,
          end: 16,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsetsDirectional.only(
        start: 16,
        end: 64,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFFE8E8EE),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
