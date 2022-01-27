import 'dart:async';

import 'package:bluetooth_messenger/constants.dart';
import 'package:bluetooth_messenger/db/chat_database.dart';
import 'package:bluetooth_messenger/screens/chat.dart';
import 'package:bluetooth_messenger/screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const chatRoute = './chat';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColorAccent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
            color: secondaryColor,
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: secondaryColor,
            ),
            shape: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            color: secondaryColor,
            itemBuilder: (context) => [
              const PopupMenuItem(
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
              if (result == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()));
              }
            },
          ),
        ],
        title: const Text(
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

  const Chats(this.screenWidth, this.screenHeight, {Key? key})
      : super(key: key);

  @override
  _ChatsState createState() => _ChatsState(screenWidth, screenHeight);
}

class _ChatsState extends State<Chats> {
  final double screenWidth;
  final double screenHeight;
  late List<Person> chats;
  List<String> lastMessages = [];
  bool isLoading = false;
  bool flag = false;

  _ChatsState(this.screenWidth, this.screenHeight);

  @override
  void initState() {
    super.initState();
    checkContacts();
    refreshChats();
  }

  Future refreshChats() async {
    setState(() => isLoading = true);

    chats = await ChatDatabase.instance.readAllPersons();
    lastMessages = [];
    if (chats.isNotEmpty) {
      for (int i = 0; i < chats.length; i++) {
        lastMessages
            .add(await ChatDatabase.instance.getLastMessage(chats[i].id) ?? "");
      }
    }
    setState(() => isLoading = false);
  }

  void checkContacts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      flag = prefs.getBool('contactPermission') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColorAccent,
              strokeWidth: 3,
            ),
          )
        : (chats.isEmpty)
            ? Scaffold(
                body: const Center(
                  child: Text(
                    "No chats to display",
                    style: TextStyle(
                      color: secondaryColorAccent,
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => {},
                  backgroundColor: primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: secondaryColor,
                  ),
                ),
              )
            : Scaffold(
                body: ListView.builder(
                  itemCount: chats.length,
                  itemExtent: 80,
                  itemBuilder: (BuildContext context, int index) {
                    String username = chats[index].username;
                    String displayPicture = chats[index].displayPicture;
                    return Container(
                      padding: const EdgeInsets.only(top: 3),
                      child: ListTile(
                        leading: CircleAvatar(
                          maxRadius: 30,
                          backgroundImage: AssetImage(
                            displayPicture,
                          ),
                        ),
                        title: Text(
                          username,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          lastMessages[index],
                          style: const TextStyle(color: Colors.white60),
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
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: secondaryColorAccent),
                        ),
                      ),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => {},
                  backgroundColor: primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: secondaryColor,
                  ),
                ),
              );
  }

  void addPerson() {
    ChatDatabase.instance.createPerson(const Person(
      number: 123,
      username: 'Mitsuha',
      displayPicture: 'assets/images/mitsuha.png',
    ));
    refreshChats();
  }

  FutureOr update(dynamic value) {
    refreshChats();
  }
}
