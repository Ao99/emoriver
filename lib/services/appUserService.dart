import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appUser.dart';

class UserService {
  static final userRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter(
    fromFirestore: (snapshots,_) => AppUser.fromJson(snapshots.data()),
    toFirestore: (user,_) => user.toJson(),
  );

  static Future<AppUser> getUserByDocId(String docId) {
    return userRef.doc(docId).get().then(
      (snapshot) {
        AppUser u = snapshot.data();
        u.docId = snapshot.id;
        return u;
      }
    );
  }

}