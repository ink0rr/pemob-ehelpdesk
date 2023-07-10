import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/answer.dart';
import 'models/message.dart';
import 'models/question.dart';
import 'models/ticket.dart';
import 'models/user_data.dart';

final auth = FirebaseAuth.instance;

final db = FirebaseFirestore.instance;

final users = db.collection('users').withConverter(
      fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
      toFirestore: (model, _) => model.toJson(),
    );

final tickets = db.collection('tickets').withConverter(
      fromFirestore: (snapshot, _) => Ticket.fromJson(snapshot.data()!),
      toFirestore: (model, _) => model.toJson(),
    );

CollectionReference<Message> getMessages(String ticketId) => tickets.doc(ticketId).collection('messages').withConverter(
      fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
      toFirestore: (model, _) => model.toJson(),
    );

final questions = db.collection('questions').withConverter(
      fromFirestore: (snapshot, _) => Question.fromJson(snapshot.data()!),
      toFirestore: (model, _) => model.toJson(),
    );

CollectionReference<Answer> getAnswers(String questionId) =>
    questions.doc(questionId).collection('answers').withConverter(
          fromFirestore: (snapshot, _) => Answer.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        );

final _users = <String, UserData>{};

Future<UserData> getUserData(String uid) async {
  if (_users.containsKey(uid)) {
    return _users[uid]!;
  }
  final snapshot = await users.doc(uid).get();
  final userData = snapshot.data();
  if (userData == null) {
    throw StateError('User $uid does not exist');
  }
  _users[uid] = userData;
  return userData;
}
