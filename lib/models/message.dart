import 'package:chat_basic_app/models/user.dart';

class Message {
  String content;
  User author;
  int type; // 0:text, 1:image, 2:gif?
  DateTime sentAt;

  Message (String content, User author, DateTime sentAt, {type = 0}) {
    this.content = content;
    this.author = author;
    this.sentAt = sentAt;
    this.type = type;
  }

  static Message fromJSON(Map<String, dynamic> json) {
    return Message(
      json["content"].toString(),
      User.fromJSON(new Map<String, dynamic>.from(json["author"])),
      DateTime.tryParse(json["sent_at"]),
      type: int.tryParse(json["type"].toString())
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "content": this.content,
      "author": this.author.toJSON(),
      "sent_at": this.sentAt.toIso8601String(),
      "type": this.type
    };
  }

}