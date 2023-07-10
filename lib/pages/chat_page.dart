import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../constants.dart';
import '../models/message.dart';
import '../theme.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends HookWidget {
  const ChatPage({
    super.key,
    required this.ticketId,
  });

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    final input = useTextEditingController();
    final isEmpty = useListenableSelector(input, () => input.text.trim().isEmpty);
    final scroll = useScrollController();

    final messages = getMessages(ticketId);
    final messageStream = useStream(messages.orderBy('createdAt').snapshots());

    useValueChanged(messageStream.data?.size, (_, __) {
      return scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Helpdesk'),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey[100],
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.thumb_up_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.thumb_down_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: scroll,
                reverse: true,
                children: [
                  const SizedBox(height: 24),
                  ...?messageStream.data?.docs.reversed.map(
                    (doc) {
                      final message = doc.data();
                      return ChatBubble(
                        message: message.text,
                        isSender: message.authorId == auth.currentUser!.uid,
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: input,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: isEmpty
                        ? null
                        : () async {
                            await messages.add(Message(
                              text: input.text.trim(),
                              authorId: auth.currentUser!.uid,
                              createdAt: DateTime.now(),
                            ));
                            input.clear();
                          },
                    icon: Icon(
                      Icons.send,
                      color: isEmpty ? Colors.grey : AppTheme.primaryColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
