import 'package:bluetooth_messenger/constants.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_core/firebase_core.dart';

import './chats.dart';

String phoneNumber = '';

class SignIn extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  SignIn(this.screenWidth, this.screenHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Expanded(
                flex: 2,
                child: InputNumber(screenWidth, screenHeight),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class InputNumber extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  InputNumber(this.screenWidth, this.screenHeight);

  InputNumberState createState() => InputNumberState(screenWidth, screenHeight);
}

class InputNumberState extends State<InputNumber> {
  final phoneNumberRetriever = TextEditingController();
  String errorText = "";
  Color textFieldColor = primaryColor;
  late FocusNode textFieldFocus;

  final double screenWidth;
  final double screenHeight;

  InputNumberState(this.screenWidth, this.screenHeight);

  @override
  void initState() {
    super.initState();
    textFieldFocus = FocusNode();
  }

  @override
  void dispose() {
    textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Get started',
          style: TextStyle(
            fontSize: 50,
            color: primaryColor,
            fontWeight: FontWeight.w300,
          ),
        ),
        Spacer(),
        TextField(
          autofocus: true,
          focusNode: textFieldFocus,
          controller: phoneNumberRetriever,
          decoration: new InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textFieldColor, width: 1.0)),
            hintText: 'Phone number',
            hintStyle: TextStyle(
              color: primaryColorAccent,
              fontSize: 12,
            ),
          ),
          style: TextStyle(
            color: primaryColor,
          ),
          keyboardType: TextInputType.number,
        ),
        Text(
          "$errorText",
          style: TextStyle(
            color: errorColor,
            fontSize: 14,
          ),
        ),
        //try {
        Spacer(
          flex: 4,
        ),
        //} catch (e) {
        //Spacer(),
        //}
        TextButton(
          onPressed: () {
            setErrorText();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatsScreen(screenWidth, screenHeight)),
            );
          },
          child: Container(
            padding: EdgeInsets.all(5),
            width: screenWidth / 4,
            height: screenHeight / 15,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: secondaryColor,
              ),
              borderRadius:
                  BorderRadius.all(Radius.circular(screenHeight / 30)),
              color: primaryColor,
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: 18,
                color: secondaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void setErrorText() {
    if (phoneNumberRetriever.text == "" ||
        phoneNumberRetriever.text.length < 10) {
      setState(() {
        errorText = "Please enter a valid Phone number";
        textFieldColor = errorColor;
      });
    } else {
      setState(() {
        errorText = "";
        textFieldColor = primaryColor;
      });
      phoneNumber = phoneNumberRetriever.text;
      numberSubmitted(phoneNumber);
    }
  }

  void numberSubmitted(String phone_number) {
    print(phone_number);
  }
}
