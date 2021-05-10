import 'package:flutter/foundation.dart';

@immutable
class Emotion {
  Emotion({
    this.id,
    this.positive,
    this.negative,
    this.color
  });

  Emotion.fromJson(Map<String, dynamic> json) : this(
    id: json["id"] as int,
    positive: json["positive"] as String,
    negative: json["negative"] as String,
    color: json["color"] as int,
  );

  final int id;
  final String positive;
  final String negative;
  final int color;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'positive': positive,
      'negative': negative,
      'color': color,
    };
  }
}