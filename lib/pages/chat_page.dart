import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatPage extends HookWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Helpdesk'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: const [
                SizedBox(
                  height: 20,
                ),
                BubbleSpecialThree(
                  text: 'Izin nanya dong',
                  color: Colors.green,
                  tail: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
                BubbleSpecialThree(
                  text: 'Toilet dimana yah?',
                  color: Colors.green,
                  tail: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16),
                ),
                BubbleSpecialThree(
                  text: 'Lu pikir aja sendiri!!!',
                  color: Color(0xFFE8E8EE),
                  tail: true,
                  isSender: false,
                ),
              ],
            ),
            MessageBar(
              onSend: (_) => print(_),
              actions: [
                InkWell(
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: InkWell(
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
