import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Helpdesk'),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
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
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: Icon(
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
    );
  }
}
