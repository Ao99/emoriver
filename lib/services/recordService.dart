import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/record.dart';

class RecordService {
  static final recordRef = FirebaseFirestore.instance
    .collection('records')
    .withConverter(
      fromFirestore: (snapshots,_) => Record.fromJson(snapshots.data()),
      toFirestore: (record,_) => record.toJson(),
    );

  static Future<QuerySnapshot<Record>> getRecordsByUserDocId(String userDocId) {
    return recordRef.where('userDocId', isEqualTo: userDocId).get();
  }

}