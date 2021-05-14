import 'package:flutter/foundation.dart';

@immutable
class User {
  User({
    this.username,
    this.savedObjects,
    this.savedActivities,
  });

  User.fromJson(Map<String, dynamic> json) : this(
    username: json["username"] as String,
    savedObjects: json["savedObjects"] as Map<String, dynamic>,
    savedActivities: json["savedActivities"] as Map<String, dynamic>,
  );

  final String username;
  final Map<String, dynamic> savedObjects;
  final Map<String, dynamic> savedActivities;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'savedObjects': savedObjects,
      'savedActivities': savedActivities,
    };
  }
}