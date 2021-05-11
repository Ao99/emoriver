import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emotion.dart';

class EmotionService {
  static final emotionRef = FirebaseFirestore.instance
    .collection('emotions')
    .withConverter(
      fromFirestore: (snapshots,_) => Emotion.fromJson(snapshots.data()),
      toFirestore: (emotion,_) => emotion.toJson(),
    );
  
  static Future<QuerySnapshot<Emotion>> getAllEmotions() {
    return emotionRef.orderBy('id').get();
  }

  static Future<DocumentSnapshot<Emotion>> getEmotionByDocId(String docId) {
    return emotionRef.doc(docId).get();
  }

}