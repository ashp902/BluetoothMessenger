import 'package:flutter/material.dart';

const primaryColor = Color(0xffAB20FD);
const primaryColorAccent = Color(0xff7D12FF);
const secondaryColor = Color(0xff212121);
const secondaryColorAccent = Color(0xff323232);
const errorColor = Color(0xffff9494);

class CustomTheme {
  static ThemeData get dark {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryColor,
      fontFamily: 'Ubuntu',
      textTheme: const TextTheme(
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
      dividerTheme: const DividerThemeData(
        color: secondaryColor,
      ),
    );
  }
}

const String persons = 'persons';
const String messages = 'messages';

class PersonFields {
  static final List<String> values = [
    id,
    number,
    username,
    displayPicture,
    publicKey,
    address,
  ];

  static const String id = 'id';
  static const String number = 'number';
  static const String username = 'username';
  static const String displayPicture = 'displayPicture';
  static const String publicKey = 'publicKey';
  static const String address = 'address';
}

class MessageFields {
  static final List<String> values = [
    id,
    receipient,
    content,
    time,
    isSender,
  ];

  static const String id = 'id';
  static const String receipient = 'receipient';
  static const String content = 'content';
  static const String time = 'time';
  static const String isSender = 'isSender';
}

class Person {
  final int? id;
  final int number;
  final String username;
  final String displayPicture;
  final String publicKey;
  final String address;

  const Person({
    this.id,
    required this.number,
    required this.username,
    required this.displayPicture,
    required this.publicKey,
    required this.address,
  });

  Map<String, Object?> toJson() => {
        PersonFields.id: id,
        PersonFields.number: number,
        PersonFields.username: username,
        PersonFields.displayPicture: displayPicture,
        PersonFields.publicKey: publicKey,
        PersonFields.address: address,
      };

  static Person fromJson(Map<String, Object?> json) => Person(
        id: json[PersonFields.id] as int,
        number: json[PersonFields.number] as int,
        username: json[PersonFields.username] as String,
        displayPicture: json[PersonFields.displayPicture] as String,
        publicKey: json[PersonFields.publicKey] as String,
        address: json[PersonFields.address] as String,
      );

  Person copy({
    int? id,
    int? number,
    String? username,
    String? displayPicture,
    String? publicKey,
    String? address
  }) =>
      Person(
        id: id ?? this.id,
        number: number ?? this.number,
        username: username ?? this.username,
        displayPicture: displayPicture ?? this.displayPicture,
        publicKey: publicKey ?? this.publicKey,
        address: address ?? this.address,
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
