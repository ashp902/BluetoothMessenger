import 'package:flutter/material.dart';

class OTPScreen extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  OTPScreen(this.screenWidth, this.screenHeight);
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
                child: OTPVerifier(screenWidth, screenHeight),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class OTPVerifier extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  OTPVerifier(this.screenWidth, this.screenHeight);

  OTPVerifierState createState() => OTPVerifierState(screenWidth, screenHeight);
}

class OTPVerifierState extends State<OTPVerifier> {
  final double screenWidth;
  final double screenHeight;

  OTPVerifierState(this.screenWidth, this.screenHeight);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
