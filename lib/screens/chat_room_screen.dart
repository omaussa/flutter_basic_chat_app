import 'package:chat_basic_app/widgets/chat_composer.dart';
import 'package:chat_basic_app/widgets/chat_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {

  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = (ModalRoute.of(context).settings.arguments);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
      ),
      body: Column(
        children: <Widget>[
          ChatList("messages"),
          ChatComposer("messages"),
        ],
      )
    );
  }

}