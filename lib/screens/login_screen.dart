import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
	@override
	_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
			body: Center(
        child: Column(
          children: <Widget>[
            Icon(Icons.message, size: 40),
            RaisedButton(
              onPressed: ()=>{}, 
              child:Text("Sign In Google")
            )
          ],
        )
      )
		);
	}
}
