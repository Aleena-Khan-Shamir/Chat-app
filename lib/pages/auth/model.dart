class UserData {
  String id;
  String name;
  String email;
  String photoUrl;
  String fcmtoken;
  String about;
  bool isOnline;
  String lastActive;
  // Timestamp addTime;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.about,
    required this.isOnline,
    required this.lastActive,
    required this.fcmtoken,
    // required this.addTime
  });
  factory UserData.fromFirestore(Map<String, dynamic> data) {
    // final data = snapshot.data()!;
    return UserData(
      id: data['id'] ?? "",
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      photoUrl: data['photoUrl'] ?? "",
      about: data['about'] ?? "",
      isOnline: data['isOnline'] ?? "",
      lastActive: data['lastActive'].toString(),
      fcmtoken: data['fcmtoken'] ?? "",
      // addTime: (data['addTime'] ?? Timestamp.now())
    );
  }

  Map<String, dynamic> toFirestore() => {
        "id": id,
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
        "fcmtoken": fcmtoken,
        // "addTime": addTime,
        'about': about,
        'isOnline': isOnline,
        'lastActive': lastActive
      };
}
