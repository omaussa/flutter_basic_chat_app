import 'package:chat_basic_app/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  final String _databaseName;
  ChatList(this._databaseName);

  @override
  State<StatefulWidget> createState() => _ChatList(this._databaseName);
}

class _ChatList extends State<ChatList> {

  DatabaseReference _messagesRef;
  bool _anchorToBottom = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  _ChatList(String databaseName) {
    _auth.currentUser().then((value) => _user = value).catchError((error) => print(error));
    final FirebaseDatabase database = FirebaseDatabase();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _messagesRef = database.reference().child(databaseName);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FirebaseAnimatedList(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        key: ValueKey<bool>(_anchorToBottom),
        query: _messagesRef,
        reverse: _anchorToBottom,
        sort: _anchorToBottom
            ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
            : null,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Message message = Message.fromJSON(new Map<String, dynamic>.from(snapshot.value));
          return SizeTransition(
            sizeFactor: animation,
            child: _buildChatMessage(message),
          );
        },
      ),
    );
  }

  Widget _buildChatMessage(Message message) {
    DateTime now = message.sentAt;
    if (message.author.email == _user.email) return _buildOwnChatMessage(message);
    return Container (
      margin: EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(message.author.displayPicture),
          ),
          Container(width: 10,),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 2),
            constraints: BoxConstraints(
                maxWidth: 200
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.author.displayName,
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
                Container(height: 10, width: 0,),
                Text(
                  message.content,
                ),
                Container(height: 3, width: 0,),
                Text(
                  "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 10
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _buildOwnChatMessage(Message message) {
    DateTime now = message.sentAt;
    return Container (
        margin: EdgeInsets.only(top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Spacer(),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 2),
              constraints: BoxConstraints(
                  maxWidth: 200
              ),
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message.author.displayName,
                    style: TextStyle(
                        fontSize: 12
                    ),
                  ),
                  Container(height: 10, width: 0,),
                  Text(
                    message.content,
                  ),
                  Container(height: 3, width: 0,),
                  Text(
                    "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 10
                    ),
                  )
                ],
              ),
            ),
            Container(width: 10,),
            CircleAvatar(
              backgroundImage: NetworkImage(message.author.displayPicture),
            ),
          ],
        )
    );
  }
}