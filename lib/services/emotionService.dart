import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emotion.dart';

class EmotionService {
  static final emotionRef = FirebaseFirestore.instance
    .collection('emotions')
    .withConverter(
      fromFirestore: (snapshots,_) => Emotion.fromJson(snapshots.data()),
      toFirestore: (emotion,_) => emotion.toJson(),
    );

  static Future<List<Emotion>> getAllEmotions() {
    return emotionRef.orderBy('id').get().then(
      (snapshot) => snapshot.docs.map((doc) {
        Emotion e = doc.data();
        e.docId = doc.id;
        return e;
      }
    ).toList());
  }

  static Future<Emotion> getEmotionByDocId(String docId) {
    return emotionRef.doc(docId).get().then(
      (snapshot) {
        Emotion e = snapshot.data();
        e.docId = snapshot.id;
        return e;
      }
    );
  }

}