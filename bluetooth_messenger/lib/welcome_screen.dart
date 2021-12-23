import 'dart:async';
import 'package:bluetooth_messenger/chats.dart';
import 'package:bluetooth_messenger/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './signin.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool flag = false;

  @override
  void initState() {
    getLoginState();
    Timer(
      const Duration(seconds: 3),
      () => flag
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatsScreen(),
              ),
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignInScreen(),
              ),
            ),
    );
  }

  void getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('LoggedIn') ?? false;
    flag = loggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(
                flex: 1,
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Spacer(),
                      const Text(
                        "Welcome",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 80,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.bluetooth_connected_rounded,
                            color: primaryColor,
                            size: 35,
                          ),
                          Icon(
                            Icons.circle,
                            color: primaryColorAccent,
                            size: 8,
                          ),
                          Icon(
                            Icons.circle,
                            color: primaryColorAccent,
                            size: 8,
                          ),
                          Icon(
                            Icons.circle,
                            color: primaryColorAccent,
                            size: 8,
                          ),
                          Icon(
                            Icons.send_rounded,
                            color: primaryColor,
                            size: 35,
                          ),
                          Icon(
                            Icons.circle,
                            color: primaryColorAccent,
                            size: 8,
                          ),
                          Icon(
                            Icons.circle,
                            color: primaryColorAccent,
                            size: 8,
                          ),
                          Icon(
                            Icons.circle,
                            color: primaryColorAccent,
                            size: 8,
                          ),
                          Icon(
                            Icons.bluetooth_connected_rounded,
                            color: primaryColor,
                            size: 35,
                          ),
                        ],
                      )
                    ],
                  )),
              const Spacer(
                flex: 1,
              ),
              const Text(
                'Chat with anyone in your Bluetooth network',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColorAccent,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
