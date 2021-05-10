import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emotion.dart';

class EmotionService {
  final emotionRef = FirebaseFirestore.instance
    .collection('emotions')
    .withConverter(
      fromFirestore: (snapshots,_) => Emotion.fromJson(snapshots.data()),
      toFirestore: (emotion,_) => emotion.toJson(),
    );
  
  Future<QuerySnapshot<Emotion>> getAllEmotions() {
    return emotionRef.orderBy('id').get();
  }

  Future<DocumentSnapshot<Emotion>> getEmotionByDocId(String docId) {
    return emotionRef.doc(docId).get();
  }

}