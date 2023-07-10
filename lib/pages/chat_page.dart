import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../constants.dart';
import '../models/message.dart';
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
    final isEmpty = useState(true);
    final scroll = useScrollController();

    final messages = db.collection('tickets/$ticketId/messages');

    useEffect(() {
      input.addListener(() {
        isEmpty.value = input.text.trim() == '';
      });
      return null;
    }, []);

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
              child: StreamBuilder(
                stream: messages.orderBy('createdAt').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  scroll.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                  return ListView(
                    controller: scroll,
                    reverse: true,
                    children: [
                      const SizedBox(height: 24),
                      ...snapshot.data!.docs.reversed.map((doc) {
                        final message = Message.fromJson(doc.data());
                        return ChatBubble(
                          message: message.text,
                          isSender: message.authorId == auth.currentUser!.uid,
                        );
                      })
                    ],
                  );
                },
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
                    onPressed: isEmpty.value
                        ? null
                        : () async {
                            await messages.add(Message(
                              text: input.text.trim(),
                              authorId: auth.currentUser!.uid,
                              createdAt: DateTime.now(),
                            ).toJson());
                            input.clear();
                          },
                    icon: Icon(
                      Icons.send,
                      color: isEmpty.value ? Colors.grey : Theme.of(context).primaryColor,
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
