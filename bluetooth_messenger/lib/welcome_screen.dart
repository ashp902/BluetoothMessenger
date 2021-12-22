import 'package:bluetooth_messenger/constants.dart';
import 'package:flutter/material.dart';
import './signin.dart';
class welcomescreen extends StatefulWidget {
  @override
  _welcomescreenState createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  @override
  void initState() {
    //super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SignIn(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height))));
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
              FittedBox(
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SignInScreen(screenWidth, screenHeight),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Next",
                        style: TextStyle(
                          color: primaryColorAccent,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: primaryColorAccent,
                      )
                    ],
                  ),
                ),
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
