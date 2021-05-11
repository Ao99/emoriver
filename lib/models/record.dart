import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Record {
  Record({
    this.userDocId,
    this.emotions,
    this.objects,
    this.activities,
    this.time,
    this.location,
  });

  Record.fromJson(Map<String, dynamic> json) : this(
    userDocId: json["userDocId"] as String,
    emotions: json["emotions"] as Map<String, dynamic>,
    objects: json["objects"] as List<dynamic>,
    activities: json["activities"] as List<dynamic>,
    time: json["time"] as Timestamp,
    location: json["location"] as GeoPoint,
  );

  final String userDocId;
  final Map<String, dynamic> emotions;
  final List<dynamic> objects;
  final List<dynamic> activities;
  final Timestamp time;
  final GeoPoint location;

  Map<String, dynamic> toJson() {
    return {
      'userDocId': userDocId,
      'emotions': emotions,
      'objects': objects,
      'activities': activities,
      'time': time,
      'location': location,
    };
  }
}