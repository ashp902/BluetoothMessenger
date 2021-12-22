import 'package:bluetooth_messenger/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_core/firebase_core.dart';

import './chats.dart';

String phoneNumber = '';

class SignInScreen extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  SignInScreen(this.screenWidth, this.screenHeight);

  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final phoneNumberRetriever = TextEditingController();
  final OTPRetriever = TextEditingController();
  String errorText = "";
  Color textFieldColor = primaryColor;
  String? verificationIDReceiver;
  bool OTPsent = false;
  String buttonText = "Submit";
  String? phone_number;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Divider(
                height: widget.screenHeight / 10,
              ),
              Text(
                'Get started',
                style: TextStyle(
                  fontSize: 50,
                  color: primaryColor,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(
                height: widget.screenHeight / 10,
              ),
              TextField(
                autofocus: true,
                controller: phoneNumberRetriever,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldColor, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: textFieldColor, width: 1.0)),
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
              Divider(
                height: widget.screenHeight / 50,
              ),
              Visibility(
                visible: OTPsent,
                child: TextField(
                  maxLength: 6,
                  controller: OTPRetriever,
                  decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textFieldColor, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: textFieldColor, width: 1.0)),
                    hintText: 'Enter OTP',
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
              ),

              Divider(
                height: widget.screenHeight * 3 / 10,
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: widget.screenWidth / 4,
                height: widget.screenHeight / 15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: secondaryColor,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(widget.screenHeight / 30)),
                  color: primaryColor,
                ),
                child: TextButton(
                  onPressed: () async {
                    if (buttonText == "Submit") {
                      setErrorText();
                    } else if (buttonText == "Verify") {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: verificationIDReceiver!,
                              smsCode: OTPRetriever.text))
                          .then((value) async {
                        if (value.user != null) {
                          setLoginState();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatsScreen()),
                              (route) => false);
                        }
                      });
                    }
                  },
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 18,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
        phone_number = "+91" + phoneNumberRetriever.text;
        errorText = "";
        textFieldColor = primaryColor;
        OTPsent = true;
        buttonText = "Verify";
        verifyPhone();
      });
    }
  }

  verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone_number!,
      codeSent: (String verificationID, int? resendToken) {
        setState(() {
          verificationIDReceiver = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          verificationIDReceiver = verificationId;
        });
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        await FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredential)
            .then((value) async {
          if (value.user != null) {
            setLoginState();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ChatsScreen()),
                (route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException error) {
        print(error.message);
      },
    );
  }

  setLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('LoggedIn', true);
  }
}
