import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../constants.dart';
import '../models/answer.dart';
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
    final answerSnapshots = useStream(answers.snapshots());

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
                  child: FutureBuilder(
                    future: questions.doc(questionId).get(),
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
                                    radius: 24,
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
                                        author.username,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Just now',
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(64),
                                    onTap: () {
                                      if (question.votes[auth.currentUser!.uid] == 1) {
                                        questionRef.update({'votes.${auth.currentUser!.uid}': FieldValue.delete()});
                                      } else {
                                        questionRef.update({'votes.${auth.currentUser!.uid}': 1});
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        color: question.votes[auth.currentUser!.uid] == 1
                                            ? AppTheme.primaryColor
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    question.votes.values.fold(0, (p, c) => p + c).toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(64),
                                    onTap: () {
                                      if (question.votes[auth.currentUser!.uid] == -1) {
                                        questionRef.update({'votes.${auth.currentUser!.uid}': FieldValue.delete()});
                                      } else {
                                        questionRef.update({'votes.${auth.currentUser!.uid}': -1});
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: question.votes[auth.currentUser!.uid] == -1
                                            ? Colors.red
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Divider(),
                              ...?answerSnapshots.data?.docs.map(
                                (e) => _AnswerWiget(answer: e.data(), answerRef: e.reference),
                              )
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

class _AnswerWiget extends HookWidget {
  const _AnswerWiget({
    required this.answer,
    required this.answerRef,
  });

  final Answer answer;
  final DocumentReference answerRef;

  @override
  Widget build(BuildContext context) {
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
                    author.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Just now',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(answer.text),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(64),
                        onTap: () {
                          if (answer.votes[auth.currentUser!.uid] == 1) {
                            answerRef.update({'votes.${auth.currentUser!.uid}': FieldValue.delete()});
                          } else {
                            answerRef.update({'votes.${auth.currentUser!.uid}': 1});
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color:
                                answer.votes[auth.currentUser!.uid] == 1 ? AppTheme.primaryColor : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        answer.votes.values.fold(0, (p, c) => p + c).toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        borderRadius: BorderRadius.circular(64),
                        onTap: () {
                          if (answer.votes[auth.currentUser!.uid] == -1) {
                            answerRef.update({'votes.${auth.currentUser!.uid}': FieldValue.delete()});
                          } else {
                            answerRef.update({'votes.${auth.currentUser!.uid}': -1});
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: answer.votes[auth.currentUser!.uid] == -1 ? Colors.red : Colors.grey.shade600,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                ],
              ))
            ],
          ),
        );
      },
    );
  }
}
