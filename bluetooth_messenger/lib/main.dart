import 'package:bluetooth_messenger/constants.dart';
import 'package:bluetooth_messenger/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bluetooth_messenger/db/chat_database.dart';
/**import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';**/

/**final FirebaseApp app = FirebaseApp(
    options: FirebaseOptions(
  googleAppID: '1:452811721710:android:7253beb95ea72d6e5c5cff',
  apiKey: 'AIzaSyDJgisMScDBnuXrwwf3Ng2mCTYaatwHcxU',
  databaseURL:
      'https://bluetooth-messenge-r-default-rtdb.asia-southeast1.firebasedatabase.app',
));**/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.dark,
      title: 'Bluetooth Messenger',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
