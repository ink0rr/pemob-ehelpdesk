import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart';

import '../constants.dart';
import '../models/answer.dart';
import '../providers/user.dart';
import '../theme.dart';

class QuestionPage extends HookWidget {
  const QuestionPage({
    super.key,
    required this.questionId,
  });

  final String questionId;
  @override
  Widget build(BuildContext context) {
    final input = useTextEditingController();
    final isEmpty = useListenableSelector(input, () => input.text.trim().isEmpty);

    final answers = getAnswers(questionId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Diskusi'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: StreamBuilder(
                    stream: questions.doc(questionId).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final questionRef = snapshot.data!.reference;
                      final question = snapshot.data!.data()!;
                      return FutureBuilder(
                        future: getUserData(question.authorId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final author = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    child: ClipOval(
                                      child: Image.network(
                                        author.photoURL,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '@${author.username}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        format(question.createdAt),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                question.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(question.description),
                              const SizedBox(height: 32),
                              _VoteWidget(doc: questionRef, votes: question.votes),
                              const Divider(),
                              StreamBuilder(
                                stream: answers.snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Column(
                                    children: [
                                      ...snapshot.data!.docs.map((doc) {
                                        final answer = doc.data();
                                        return FutureBuilder(
                                          future: getUserData(answer.authorId),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            final author = snapshot.data!;
                                            return Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        author.photoURL,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '@${author.username}',
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          format(answer.createdAt),
                                                          style: TextStyle(
                                                            color: Colors.grey.shade600,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Text(answer.text),
                                                        const SizedBox(height: 16),
                                                        Row(
                                                          children: [
                                                            _VoteWidget(doc: doc.reference, votes: answer.votes),
                                                            const SizedBox(width: 8),
                                                            if (question.answerId == doc.id)
                                                              DecoratedBox(
                                                                decoration: BoxDecoration(
                                                                  color: Colors.green,
                                                                  borderRadius: BorderRadius.circular(24),
                                                                ),
                                                                child: const Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal: 6,
                                                                    vertical: 4,
                                                                  ),
                                                                  child: Text(
                                                                    'Accepted Answer',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                          ],
                                                        ),
                                                        const SizedBox(height: 16),
                                                        const Divider(),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuButton(
                                                    itemBuilder: (context) => [
                                                      if (auth.currentUser!.uid == question.authorId)
                                                        PopupMenuItem(
                                                          child: const Text('Mark as Answer'),
                                                          onTap: () {
                                                            questionRef.update({
                                                              'status': 'RESOLVED',
                                                              'answerId': doc.id,
                                                            });
                                                          },
                                                        ),
                                                      if (auth.currentUser!.uid == answer.authorId)
                                                        PopupMenuItem(
                                                          child: const Text('Delete'),
                                                          onTap: () {
                                                            doc.reference.delete();
                                                          },
                                                        ),
                                                      const PopupMenuItem(
                                                        child: Text('Report'),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      })
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: input,
                decoration: InputDecoration(
                  hintText: 'Write an answer',
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: isEmpty
                        ? null
                        : () async {
                            await answers.add(Answer(
                              text: input.text.trim(),
                              votes: {},
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

class _VoteWidget extends HookConsumerWidget {
  const _VoteWidget({
    required this.doc,
    required this.votes,
  });

  final DocumentReference doc;
  final Map<String, int> votes;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final vote = votes[user.uid];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(64),
            onTap: () {
              if (vote == 1) {
                doc.update({'votes.${user.uid}': FieldValue.delete()});
              } else {
                doc.update({'votes.${user.uid}': 1});
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.keyboard_arrow_up,
                color: vote == 1 ? AppTheme.primaryColor : Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            votes.values.fold(0, (p, c) => p + c).toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: vote == 1
                  ? AppTheme.primaryColor
                  : vote == -1
                      ? Colors.red
                      : Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            borderRadius: BorderRadius.circular(64),
            onTap: () {
              if (vote == -1) {
                doc.update({'votes.${user.uid}': FieldValue.delete()});
              } else {
                doc.update({'votes.${user.uid}': -1});
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: vote == -1 ? Colors.red : Colors.grey.shade600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
