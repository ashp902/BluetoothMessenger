import 'package:bluetooth_messenger/constants.dart';
import 'package:flutter/material.dart';

String phoneNumber = '';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(
                flex: 1,
              ),
              InputNumber(),
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

class InputNumber extends StatefulWidget {
  InputNumberState createState() => InputNumberState();
}

class InputNumberState extends State<InputNumber> {
  final phoneNumberRetriever = TextEditingController();
  String errorText = "";
  Color textFieldColor = primaryColor;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Text(
            'Get started',
            style: TextStyle(
              fontSize: 50,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Container(
            child: TextField(
              autofocus: true,
              controller: phoneNumberRetriever,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textFieldColor, width: 0.0),
                ),
                hintText: 'Phone number',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Text(
            "$errorText",
            style: TextStyle(
              color: errorColor,
              fontSize: 14,
            ),
          ),
          Spacer(
            flex: 4,
          ),
          TextButton(
            onPressed: () {
              setErrorText();
            },
            child: Container(
              padding: EdgeInsets.all(5),
              width: screenWidth / 5,
              height: screenHeight / 15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(6)),
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
