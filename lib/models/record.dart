import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  Record({
    this.docId,
    this.userDocId,
    this.emotions,
    this.time,
    this.location,
    this.objects,
    this.activities,
    this.updatedAt,
  });

  Record.fromJson(Map<String, dynamic> json) : this(
    userDocId: json["userDocId"] as String,
    emotions: json["emotions"] as Map<String, dynamic>,
    time: json["time"] as Timestamp,
    location: json["location"] as GeoPoint,
    objects: json["objects"] as List<dynamic>,
    activities: json["activities"] as List<dynamic>,
    updatedAt: json["updatedAt"] as List<dynamic>,
);

  String docId;
  String userDocId;
  Map<String, dynamic> emotions;
  Timestamp time;
  GeoPoint location;
  List<dynamic> objects;
  List<dynamic> activities;
  List<dynamic> updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'userDocId': userDocId,
      'emotions': emotions,
      'time': time,
      'location': location,
      'objects': objects,
      'activities': activities,
      'updatedAt': updatedAt,
    };
  }
}