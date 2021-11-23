import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xffAB20FD);
const primaryColorAccent = Color(0xff7D12FF);
const secondaryColor = Color(0xff212121);
const secondaryColorAccent = Color(0xff323232);
const errorColor = Color(0xffff9494);

class Person {
  final String username;
  final String displayPicture;
  final bool isActive;
  List<ChatMessage> messages;

  Person(this.username, this.displayPicture, this.isActive, this.messages);
}

Map<String, Person> chats = {
  'Mitsuha': Person(
    'Mitsuha',
    'assets/images/mitsuha.png',
    true,
    [
      ChatMessage(
        'Hello',
        '14:20',
        true,
      ),
      ChatMessage(
        'Hey',
        '14:22',
        false,
      ),
    ],
  ),
  'Taki': Person(
    'Taki',
    'assets/images/taki.png',
    false,
    [
      ChatMessage(
        'zero',
        '14:20',
        true,
      ),
      ChatMessage(
        'one',
        '14:22',
        false,
      ),
    ],
  ),
};

class ChatMessage {
  final String content;
  final String time;
  final bool isSender;

  ChatMessage(this.content, this.time, this.isSender);
}

class CustomTheme {
  static ThemeData get dark {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryColor,
      fontFamily: 'Ubuntu',
      textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
        headline1: TextStyle(),
        headline2: TextStyle(),
        headline3: TextStyle(),
        headline4: TextStyle(),
        headline5: TextStyle(),
        headline6: TextStyle(),
      ).apply(
        bodyColor: primaryColor,
        displayColor: primaryColor,
      ),
      dividerTheme: DividerThemeData(
        color: secondaryColor,
      ),
    );
  }
}
