import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timeago/timeago.dart';

import '../../../constants.dart';
import '../../../widgets/status_badge.dart';
import '../../question_page.dart';

class Home extends HookWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(24),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 24),
                StreamBuilder(
                  stream: questions.orderBy('createdAt', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      children: [
                        ...snapshot.data!.docs.map((doc) {
                          final ticket = doc.data();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(226, 228, 235, 70),
                                    blurRadius: 40,
                                    offset: Offset(0, 0),
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(226, 228, 235, 70),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                                shape: BoxShape.rectangle,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => QuestionPage(
                                      questionId: doc.id,
                                    ),
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            FutureBuilder(
                                              future: getUserData(ticket.authorId),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const SizedBox();
                                                }
                                                final user = snapshot.data!;
                                                return Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 16,
                                                      child: ClipOval(
                                                        child: Image.network(
                                                          user.photoURL,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '@${user.username}',
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            format(ticket.createdAt),
                                                            style: const TextStyle(fontSize: 12),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    StatusBadge(status: ticket.status)
                                                  ],
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              ticket.title,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              ticket.description,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
