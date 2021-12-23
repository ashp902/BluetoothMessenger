import 'package:bluetooth_messenger/constants.dart';
import 'package:bluetooth_messenger/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
