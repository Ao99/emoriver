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
    this.createdAt,
    this.updatedAt,
  });

  Record.fromJson(Map<String, dynamic> json) : this(
    userDocId: json["userDocId"] as String,
    emotions: json["emotions"] as Map<String, dynamic>,
    time: json["time"] as Timestamp,
    location: json["location"] as GeoPoint,
    objects: json["objects"] as List<dynamic>,
    activities: json["activities"] as List<dynamic>,
    createdAt: json["createdAt"] as Timestamp,
    updatedAt: json["updatedAt"] as Timestamp,
);

  String docId;
  final String userDocId;
  final Map<String, dynamic> emotions;
  final Timestamp time;
  final GeoPoint location;
  final List<dynamic> objects;
  final List<dynamic> activities;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'userDocId': userDocId,
      'emotions': emotions,
      'time': time,
      'location': location,
      'objects': objects,
      'activities': activities,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}