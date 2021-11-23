import 'package:flutter/material.dart';
import 'package:bluetooth_messenger/constants.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColorAccent,
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back_ios_rounded,
            color: secondaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Text(
              'Settings',
              style: TextStyle(
                color: secondaryColor,
              ),
            )
          ],
        ),
      ),
      body: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/empty_profile.png'),
              ),
            ],
          ),
          flex: 2,
        ),
        Spacer(),
        Expanded(
          child: Column(),
          flex: 2,
        ),
      ],
    );
  }
}
