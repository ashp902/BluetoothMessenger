import 'dart:async';

import 'package:bluetooth_messenger/constants.dart';
import 'package:bluetooth_messenger/profile.dart';
import 'package:flutter/material.dart';

import './chat.dart';

const chatRoute = './chat';

class ChatsScreen extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  ChatsScreen(this.screenWidth, this.screenHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColorAccent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded),
            color: secondaryColor,
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: secondaryColor,
            ),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            color: secondaryColor,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: 0,
              ),
            ],
            onSelected: (result) {
              if (result == 0)
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
        ],
        title: Text(
          "Chats",
          style: TextStyle(
            color: secondaryColor,
          ),
        ),
      ),
      body: Chats(screenWidth, screenHeight),
    );
  }
}

class Chats extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  Chats(this.screenWidth, this.screenHeight);

  @override
  ChatsState createState() => ChatsState(screenWidth, screenHeight);
}

class ChatsState extends State<Chats> {
  final double screenWidth;
  final double screenHeight;

  ChatsState(this.screenWidth, this.screenHeight);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemExtent: 80,
      itemBuilder: (BuildContext context, int index) {
        String key = chats.keys.elementAt(index);
        String username = chats[key]!.username;
        String displayPicture = chats[key]!.displayPicture;
        return Container(
          padding: EdgeInsets.only(top: 3),
          child: ListTile(
            leading: CircleAvatar(
              radius: 22,
              backgroundColor:
                  chats[key]!.isActive ? primaryColor : secondaryColorAccent,
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  displayPicture,
                ),
              ),
            ),
            title: Text(
              username,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              chats[key]!.messages[chats[key]!.messages.length - 1].content,
              style: TextStyle(color: Colors.white60),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        Person(chats[key]!.username, chats[key]!.displayPicture,
                            chats[key]!.isActive, chats[key]!.messages),
                        screenWidth,
                        screenHeight)),
              ).then(update);
            },
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: secondaryColorAccent),
            ),
          ),
        );
      },
    );
  }

  FutureOr update(dynamic value) {
    setState(() {});
  }
}
