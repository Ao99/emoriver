import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/record.dart';

class RecordService {
  static final recordRef = FirebaseFirestore.instance
    .collection('records')
    .withConverter(
      fromFirestore: (snapshots,_) => Record.fromJson(snapshots.data()),
      toFirestore: (record,_) => record.toJson(),
    );

  static Future<List<Record>> getRecordsByUserDocId(String userDocId) {
    return recordRef.where('userDocId', isEqualTo: userDocId).get().then(
      (snapshot) => snapshot.docs.map((doc) {
        Record r = doc.data();
        r.docId = doc.id;
        return r;
      }
    ).toList());
  }

  static Future<DocumentReference<Record>> addRecord(Record record) {
    return recordRef.add(record);
  }
  
  static Future<DocumentReference<Record>> deleteRecordByDocId(String docId) {
    return recordRef.doc(docId).delete();
  }

}