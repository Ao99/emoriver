import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  static final userRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter(
    fromFirestore: (snapshots,_) => User.fromJson(snapshots.data()),
    toFirestore: (user,_) => user.toJson(),
  );

  static Future<DocumentSnapshot<User>> getUserByDocId(String docId) {
    return userRef.doc(docId).get();
  }

}