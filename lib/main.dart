import 'package:chat_basic_app/screens/chat_room_screen.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "/": (context) => LoginScreen(),
        "/room": (context) => ChatRoomScreen()
      },
    );
  }
}


