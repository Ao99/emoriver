class AppUser {
  AppUser({
    this.docId,
    this.username,
    this.email,
    this.savedObjects,
    this.savedActivities,
  });

  AppUser.fromJson(Map<String, dynamic> json) : this(
    username: json["username"] as String,
    email: json["email"] as String,
    savedObjects: json["savedObjects"] as Map<String, dynamic>,
    savedActivities: json["savedActivities"] as Map<String, dynamic>,
  );

  String docId;
  final String username;
  final String email;
  final Map<String, dynamic> savedObjects;
  final Map<String, dynamic> savedActivities;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'savedObjects': savedObjects,
      'savedActivities': savedActivities,
    };
  }
}