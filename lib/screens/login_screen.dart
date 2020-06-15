import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
	@override
	_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

	final FirebaseAuth _auth = FirebaseAuth.instance;
	final GoogleSignIn _googleSignIn = GoogleSignIn();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
			body: Center(
        child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.message, size: 120, color: Theme.of(context).primaryColor),
            Text(
							"Chat Room",
							style: TextStyle(
								color: Theme.of(context).primaryColor,
								fontSize: 30
							),
						),
            Container(height: 40,),
            RaisedButton(
							padding: EdgeInsets.only(left: 5, bottom: 0, right: 5, top: 0),
              onPressed: () async {
								try {
									FirebaseUser user = await _signInWithGoogle();
									Navigator.pushNamed(context, "/room", arguments: user);
								} catch (exception) {
									print(exception);
								}
							},
              child: Row(
								mainAxisSize: MainAxisSize.min,
								children: <Widget>[
									Image.network("https://images.theconversation.com/files/93616/original/image-20150902-6700-t2axrz.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1000&fit=clip", width: 26,),
									Container(width: 10, height: 0,),
									Text("Sign In with Google")
								],
							)
            )
          ],
        )
      )
		);
	}

	Future<FirebaseUser> _signInWithGoogle() async {
		final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
		final GoogleSignInAuthentication googleAuth =
				await googleUser.authentication;
		final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
		return (await _auth.signInWithCredential(credential)).user;
	}
}
