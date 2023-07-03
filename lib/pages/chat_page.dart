import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:ehelpdesk/models/message.dart';
import 'package:ehelpdesk/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatPage extends HookWidget {
  const ChatPage({
    super.key,
    required this.questionId,
  });

  final String questionId;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Helpdesk'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder(
              stream: Message.getSnapshots(questionId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data?.docs;
                if (data == null) {
                  return const Center(child: Text('Failed to load data'));
                }

                final chat = data.map((e) => Message.fromSnapshot(e)).toList();
                return ListView(
                  children: [
                    const SizedBox(height: 24),
                    ...chat.map(
                      (e) => ChatBubble(
                        message: e.message,
                        isSender: e.authorId == user.uid,
                      ),
                    )
                  ],
                );
              },
            ),
            MessageBar(
              onSend: (message) {
                if (message.isEmpty) {
                  return;
                }
                Message.add(
                  questionId: questionId,
                  message: message,
                );
              },
              sendButtonColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
