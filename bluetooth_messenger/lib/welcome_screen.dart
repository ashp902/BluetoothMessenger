import 'dart:async';
import 'package:bluetooth_messenger/chats.dart';
import 'package:bluetooth_messenger/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './signin.dart';

class welcomescreen extends StatefulWidget {
  @override
  _welcomescreenState createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  bool flag = false;

  @override
  void initState() {
    //super.initState();
    getLoginState();
    Timer(
      Duration(seconds: 3),
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
                builder: (context) => SignInScreen(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Spacer(
                flex: 1,
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Spacer(),
                      Text(
                        "Welcome",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 80,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
              Spacer(
                flex: 1,
              ),
              Text(
                'Chat with anyone in your Bluetooth network',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColorAccent,
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
