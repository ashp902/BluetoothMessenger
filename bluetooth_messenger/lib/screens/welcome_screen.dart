import 'dart:async';
import 'package:bluetooth_messenger/screens/chats.dart';
import 'package:bluetooth_messenger/constants.dart';
import 'package:bluetooth_messenger/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WelcomeScreen extends StatefulWidget {
  final BuildContext context;

  const WelcomeScreen({Key? key, required this.context}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool flag = false;
  bool contactPermissionGranted = false;

  @override
  void initState() {
    getLoginState();
    checkContactStatus();
    Timer(
      const Duration(seconds: 3),
      () => flag
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatsScreen(),
              ),
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            ),
    );
  }

  void checkContactStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('contactPermission') ?? false) {
      contactPermissionGranted = true;
    } else {
      final PermissionStatus contactPermissionStatus = await _getPermission();
      if (contactPermissionStatus == PermissionStatus.granted) {
        prefs.setBool('contactPermission', true);
        contactPermissionGranted = true;
      }
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus contactPermission =
        await Permission.contacts.request();
    if (contactPermission == PermissionStatus.granted) {
      return contactPermission;
    } else if (contactPermission != PermissionStatus.denied) {
      showDialog(
        context: super.context,
        builder: (BuildContext context) {
          return const SimpleDialog(
            backgroundColor: secondaryColor,
            title: Text(
              "Permission for contacts denied",
              style: TextStyle(
                color: primaryColorAccent,
              ),
            ),
          );
        },
      );
      return contactPermission;
    } else {
      showDialog(
        context: super.context,
        builder: (BuildContext context) {
          return const SimpleDialog(
            backgroundColor: secondaryColor,
            title: Text(
              "Allow access to contacts in settings page",
              style: TextStyle(
                color: primaryColorAccent,
              ),
            ),
          );
        },
      );
      return contactPermission;
    }
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
