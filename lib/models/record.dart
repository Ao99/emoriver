import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Record {
  Record({
    this.userDocId,
    this.emotions,
    this.time,
    this.location,
    this.objects,
    this.activities,
  });

  Record.fromJson(Map<String, dynamic> json) : this(
    userDocId: json["userDocId"] as String,
    emotions: json["emotions"] as Map<String, dynamic>,
    time: json["time"] as Timestamp,
    location: json["location"] as GeoPoint,
    objects: json["objects"] as List<dynamic>,
    activities: json["activities"] as List<dynamic>,
  );

  final String userDocId;
  final Map<String, dynamic> emotions;
  final Timestamp time;
  final GeoPoint location;
  final List<dynamic> objects;
  final List<dynamic> activities;

  Map<String, dynamic> toJson() {
    return {
      'userDocId': userDocId,
      'emotions': emotions,
      'time': time,
      'location': location,
      'objects': objects,
      'activities': activities,
    };
  }
}