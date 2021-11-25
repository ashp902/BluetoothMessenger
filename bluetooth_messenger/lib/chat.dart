import 'dart:async';

import 'package:bluetooth_messenger/chats.dart';
import 'package:bluetooth_messenger/db/chat_database.dart';
import 'package:bluetooth_messenger/profile.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_messenger/constants.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class ChatScreen extends StatelessWidget {
  final Person user;
  final double screenWidth;
  final double screenHeight;

  ChatScreen(this.user, this.screenWidth, this.screenHeight);

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
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        user.displayPicture,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth / 35,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: screenHeight / 42,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: secondaryColor,
            ),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            color: secondaryColorAccent,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            onSelected: (result) {
              if (result == 0)
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Messages(screenWidth, screenHeight, user),
      ),
    );
  }

  void openProfile(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }
}

class Messages extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final Person user;

  Messages(this.screenWidth, this.screenHeight, this.user);

  MessagesState createState() => MessagesState(screenWidth, screenHeight, user);
}

class MessagesState extends State<Messages> {
  final double screenWidth;
  final double screenHeight;
  final Person user;
  final messenger = TextEditingController();
  late List<ChatMessage> messages;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMessages();
  }

  /**@override
  void dispose() {
    ChatDatabase.instance.close();
    super.dispose();
  }**/

  Future refreshMessages() async {
    setState(() => isLoading = true);
    this.messages = await ChatDatabase.instance.readMessages(user.id);
    setState(() => isLoading = false);
  }

  MessagesState(this.screenWidth, this.screenHeight, this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColorAccent,
                    strokeWidth: 3,
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) =>
                      messageBuilder(context, index),
                ),
        ),
        inputField(),
      ],
    );
  }

  Widget inputField() {
    return Container(
      color: secondaryColorAccent,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: messenger,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                    hintText: 'Enter a Message',
                    hintStyle: TextStyle(
                      color: Colors.white54,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: secondaryColor,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: post,
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.send_rounded,
                  size: 35,
                  color: primaryColorAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Message(messages[index], screenWidth),
    );
  }

  void post() {
    final String message = messenger.text;
    if (message == '') return;
    DateTime now = DateTime.now();
    ChatDatabase.instance.postMessage(ChatMessage(
      receipient: user.id,
      content: message,
      time: "${now.hour}:${now.minute}",
      isSender: true,
    ));
    refreshMessages();
    setState(() {
      messenger.text = '';
    });
  }
}

class Message extends StatelessWidget {
  final message;
  final double screenWidth;

  Message(this.message, this.screenWidth);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
          decoration: BoxDecoration(
            color: message.isSender ? secondaryColorAccent : primaryColorAccent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
