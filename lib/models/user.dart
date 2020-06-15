class User {
  String id;
  String displayName;
  String email;
  String displayPicture;

  User(String id, String displayName, String email, String displayPicture) {
    this.id = id;
    this.displayName = displayName;
    this.email = email;
    this.displayPicture = displayPicture;
  }

  static User fromJSON(Map<String, dynamic> json) {
    return User(
      json["id"].toString(),
      json["displayName"].toString(),
      json["email"].toString(),
      json["displayPicture"].toString(),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": this.id,
      "displayName": this.displayName,
      "email": this.email,
      "displayPicture": this.displayPicture
    };
  }
}