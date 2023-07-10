import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants.dart';
import '../../../models/ticket.dart';
import '../../../providers/user.dart';
import '../../chat_page.dart';

class Home extends HookConsumerWidget {
  const Home({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    final tickets = db.collection('tickets');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: userData.when(
            error: (error, stackTrace) {
              auth.signOut();
              throw Exception('Error getting user data');
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            data: (data) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        child: CircleAvatar(
                          radius: 24,
                          child: ClipOval(
                            child: Image.network(
                              data.photoURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  StreamBuilder(
                    stream: tickets.where('authorId', isEqualTo: user.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Column(
                        children: [
                          ...snapshot.data!.docs.map((doc) {
                            final ticket = Ticket.fromJson(doc.data());
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
                                      builder: (context) => ChatPage(
                                        ticketId: doc.id,
                                      ),
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/question.svg',
                                        ),
                                        const SizedBox(width: 14),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ticket.category,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                ticket.title,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(ticket.description),
                                            ],
                                          ),
                                        )
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
      ),
    );
  }
}
