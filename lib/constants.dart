import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/message.dart';
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
