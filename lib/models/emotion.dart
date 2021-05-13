class Emotion {
  Emotion({
    this.docId,
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

  String docId; // not in the doc, but the doc title
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

  @override
  String toString() {
    return 'Emotion(${this.positive}-${this.negative})';
  }

  @override
  int get hashCode {
    return this.id;
  }

  @override
  bool operator ==(Object other) {
    return other is Emotion && other.id == this.id;
  }
}