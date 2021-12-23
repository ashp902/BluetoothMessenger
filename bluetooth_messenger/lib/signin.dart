import 'package:bluetooth_messenger/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './chats.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
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
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Divider(
                height: screenHeight / 10,
              ),
              const Text(
                'Get started',
                style: TextStyle(
                  fontSize: 50,
                  color: primaryColor,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(
                height: screenHeight / 10,
              ),
              TextField(
                controller: phoneNumberRetriever,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldColor, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: textFieldColor, width: 1.0)),
                  hintText: 'Phone number',
                  hintStyle: const TextStyle(
                    color: primaryColorAccent,
                    fontSize: 12,
                  ),
                ),
                style: const TextStyle(
                  color: primaryColor,
                ),
                keyboardType: TextInputType.number,
              ),
              Text(
                errorText,
                style: const TextStyle(
                  color: errorColor,
                  fontSize: 14,
                ),
              ),
              //try {
              Divider(
                height: screenHeight / 50,
              ),
              Visibility(
                visible: OTPsent,
                child: TextField(
                  maxLength: 6,
                  controller: OTPRetriever,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textFieldColor, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: textFieldColor, width: 1.0)),
                    hintText: 'Enter OTP',
                    hintStyle: const TextStyle(
                      color: primaryColorAccent,
                      fontSize: 12,
                    ),
                  ),
                  style: const TextStyle(
                    color: primaryColor,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              Divider(
                height: screenHeight * 3 / 10,
              ),
              Container(
                padding: const EdgeInsets.all(5),
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
                                  builder: (context) => const ChatsScreen()),
                              (route) => false);
                        }
                      });
                    }
                  },
                  child: Text(
                    buttonText,
                    style: const TextStyle(
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
        phoneNumberRetriever.text.length != 10) {
      setState(() {
        errorText = "Please enter a valid Phone number";
        textFieldColor = errorColor;
      });
    } else {
      setState(() {
        phoneNumber = "+91" + phoneNumberRetriever.text;
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
      phoneNumber: phoneNumber!,
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
                MaterialPageRoute(builder: (context) => const ChatsScreen()),
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
