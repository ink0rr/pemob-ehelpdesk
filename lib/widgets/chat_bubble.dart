import 'package:chat_bubbles/chat_bubbles.dart';
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
      return BubbleSpecialThree(
        text: message,
        tail: true,
        color: Theme.of(context).primaryColor,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    }
    return BubbleSpecialThree(
      text: message,
      tail: true,
      isSender: false,
      color: const Color(0xFFE8E8EE),
    );
  }
}
