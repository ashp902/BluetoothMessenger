import 'dart:async';

import 'package:bluetooth_messenger/constants.dart';
import 'package:bluetooth_messenger/db/chat_database.dart';
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
  late List<Person> chats;
  bool isLoading = false;

  ChatsState(this.screenWidth, this.screenHeight);

  @override
  void initState() {
    super.initState();
    refreshChats();
  }

  /**@override
  void dispose() {
    ChatDatabase.instance.close();
    super.dispose();
  }**/

  Future refreshChats() async {
    setState(() => isLoading = true);

    this.chats = await ChatDatabase.instance.readAllPersons();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: primaryColorAccent,
              strokeWidth: 3,
            ),
          )
        : Scaffold(
            body: ListView.builder(
              itemCount: chats.length,
              itemExtent: 80,
              itemBuilder: (BuildContext context, int index) {
                String username = chats[index].username;
                String displayPicture = chats[index].displayPicture;
                String? lastMessage = chats[index].lastMessage;
                return Container(
                  padding: EdgeInsets.only(top: 3),
                  child: ListTile(
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundImage: AssetImage(
                        displayPicture,
                      ),
                    ),
                    title: Text(
                      username,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      lastMessage!,
                      style: TextStyle(color: Colors.white60),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                chats[index], screenWidth, screenHeight)),
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
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: addPerson,
              backgroundColor: primaryColor,
              child: Icon(
                Icons.add,
                color: secondaryColor,
              ),
            ),
          );
  }

  void addPerson() {
    ChatDatabase.instance.createPerson(Person(
        number: 123,
        username: 'Mitsuha',
        displayPicture: 'assets/images/mitsuha.png',
        lastMessage: ''));
    refreshChats();
  }

  FutureOr update(dynamic value) {
    refreshChats();
  }
}
