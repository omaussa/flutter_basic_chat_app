import 'package:chat_basic_app/models/message.dart';
import 'package:chat_basic_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatComposer extends StatefulWidget {
  final String _databaseName;
  ChatComposer(this._databaseName);

  @override
  State<StatefulWidget> createState() => _ChatComposerState(this._databaseName);
}

class _ChatComposerState extends State<ChatComposer> {

  DatabaseReference _messagesRef;
  TextEditingController _messageController = TextEditingController();
  bool canSend = false;

  User author;

  _ChatComposerState(String databaseName) {
    final FirebaseDatabase database = FirebaseDatabase();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _messagesRef = database.reference().child(databaseName);
    _setAuthor();
  }

  void _setAuthor() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser current = await _auth.currentUser();
    author = User(current.uid, current.displayName, current.email, current.photoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
      color: Color(0xFFF0F0F0),
      child: Row(
        children: <Widget>[
          SizedBox(
              width: 30,
              height: 30,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: Theme.of(context).primaryColor,
                onPressed: (){},
                child: Icon(Icons.add, color: Colors.white, size: 20,),
              )
          ),
          Container(width: 10,),
          Flexible(
            child: TextField(
                maxLines: null,
                controller: _messageController,
                style: TextStyle(
                    fontSize: 15
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: "Type your message here..."
                ),
                onChanged: _handleInputChange
            ),
          ),
          Container(width: 10,),
          SizedBox(
              width: 30,
              height: 30,
              child: FlatButton(
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: (canSend && author != null) ? _sendTextMessage : null,
                child: Icon(Icons.send, size: 25, color: (canSend && author != null) ? Theme.of(context).primaryColor : Colors.black38,),
              )
          ),
        ],
      ),
    );
  }

  void _sendTextMessage() async {
    String text = _messageController.text;
    Message message = Message(text, author, DateTime.now());
    DatabaseReference item = _messagesRef.push();
    item.set(message.toJSON());
    item.setPriority(0 - DateTime.now().millisecondsSinceEpoch); // This is to be allow to get only the latest messages in the order we want to
    setState(() {
      _messageController.text = "";
    });
  }

  void _handleInputChange(String text) async {
    bool change = false;
    if (text.length > 0 && !canSend) {
      change = true;
      canSend = true;
    } else {
      if (text.length == 0 && canSend) {
        change = true;
        canSend = false;
      }
    }
    if (change) {
      setState(() {
        canSend = canSend;
      });
    }
  }
}