import 'package:bluetooth_messenger/chat.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xffAB20FD);
const primaryColorAccent = Color(0xff7D12FF);
const secondaryColor = Color(0xff212121);
const secondaryColorAccent = Color(0xff323232);
const errorColor = Color(0xffff9494);

/**Map<String, Person> chats = {
  'Mitsuha': Person(
    number: 1,
    username: 'Mitsuha',
    displayPicture: 'assets/images/mitsuha.png',
  ),
  'Taki': Person(
    number: 2,
    username: 'Taki',
    displayPicture: 'assets/images/taki.png',
  ),
};**/

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

final String persons = 'persons';
final String messages = 'messages';

class PersonFields {
  static final List<String> values = [
    id,
    number,
    username,
    displayPicture,
    lastMessage,
  ];

  static final String id = 'id';
  static final String number = 'number';
  static final String username = 'username';
  static final String displayPicture = 'displayPicture';
  static final String lastMessage = 'lastMessage';
}

class MessageFields {
  static final List<String> values = [
    id,
    receipient,
    content,
    time,
    isSender,
  ];

  static final String id = 'id';
  static final String receipient = 'receipient';
  static final String content = 'content';
  static final String time = 'time';
  static final String isSender = 'isSender';
}

class Person {
  final int? id;
  final int number;
  final String username;
  final String displayPicture;
  final String? lastMessage;

  const Person({
    this.id,
    required this.number,
    required this.username,
    required this.displayPicture,
    this.lastMessage,
  });

  Map<String, Object?> toJson() => {
        PersonFields.id: id,
        PersonFields.number: number,
        PersonFields.username: username,
        PersonFields.displayPicture: displayPicture,
        PersonFields.lastMessage: lastMessage,
      };

  static Person fromJson(Map<String, Object?> json) => Person(
        id: json[PersonFields.id] as int,
        number: json[PersonFields.number] as int,
        username: json[PersonFields.username] as String,
        displayPicture: json[PersonFields.displayPicture] as String,
        lastMessage: json[PersonFields.lastMessage] as String,
      );

  Person copy({
    int? id,
    int? number,
    String? username,
    String? displayPicture,
    String? lastMessage,
  }) =>
      Person(
        id: id ?? this.id,
        number: number ?? this.number,
        username: username ?? this.username,
        displayPicture: displayPicture ?? this.displayPicture,
        lastMessage: lastMessage ?? this.lastMessage,
      );
}

class ChatMessage {
  final int? id;
  final int? receipient;
  final String content;
  final String time;
  final bool isSender;

  const ChatMessage({
    this.id,
    required this.receipient,
    required this.content,
    required this.time,
    required this.isSender,
  });

  Map<String, Object?> toJson() => {
        MessageFields.id: id,
        MessageFields.receipient: receipient,
        MessageFields.content: content,
        MessageFields.time: time,
        MessageFields.isSender: isSender ? 1 : 0,
      };

  static ChatMessage fromJson(Map<String, Object?> json) => ChatMessage(
        id: json[MessageFields.id] as int,
        receipient: json[MessageFields.receipient] as int,
        content: json[MessageFields.content] as String,
        time: json[MessageFields.time] as String,
        isSender: json[MessageFields.isSender] == 1,
      );

  ChatMessage copy({
    int? id,
    int? receipient,
    String? content,
    String? time,
    bool? isSender,
  }) =>
      ChatMessage(
        id: id ?? this.id,
        receipient: receipient ?? this.receipient,
        content: content ?? this.content,
        time: time ?? this.time,
        isSender: isSender ?? this.isSender,
      );
}
