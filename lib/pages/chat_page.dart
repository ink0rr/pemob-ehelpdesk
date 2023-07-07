import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../constants.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends HookWidget {
  const ChatPage({
    super.key,
    required this.questionId,
  });

  final String questionId;

  @override
  Widget build(BuildContext context) {
    final messages = db.collection('questions/$questionId/messages');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Helpdesk'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder(
              stream: messages.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: [
                    const SizedBox(height: 24),
                    ...snapshot.data!.docs.map((doc) {
                      final message = Message.fromJson(doc.data());
                      return ChatBubble(
                        message: message.message,
                        isSender: message.authorId == auth.currentUser!.uid,
                      );
                    })
                  ],
                );
              },
            ),
            MessageBar(
              onSend: (message) async {
                if (message.isEmpty) {
                  return;
                }
                await messages.add(Message(
                  message: message,
                  authorId: auth.currentUser!.uid,
                  createdAt: DateTime.now(),
                ).toJson());
              },
              sendButtonColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
