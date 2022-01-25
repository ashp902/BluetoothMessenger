import 'dart:async';

import 'package:bluetooth_messenger/db/chat_database.dart';
import 'package:bluetooth_messenger/screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_messenger/constants.dart';

class ChatScreen extends StatelessWidget {
  final Person user;
  final double screenWidth;
  final double screenHeight;

  const ChatScreen(this.user, this.screenWidth, this.screenHeight, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColorAccent,
        leading: IconButton(
          icon: const Icon(
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
            icon: const Icon(
              Icons.more_vert_rounded,
              color: secondaryColor,
            ),
            shape: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            color: secondaryColorAccent,
            itemBuilder: (context) => [
              const PopupMenuItem(
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
              if (result == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _Messages(screenWidth, screenHeight, user),
      ),
    );
  }

  void openProfile(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditProfilePage()));
  }
}

class _Messages extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final Person user;

  const _Messages(this.screenWidth, this.screenHeight, this.user, {Key? key})
      : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<_Messages> {
  final messenger = TextEditingController();
  late List<ChatMessage> messages;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMessages();
  }

  Future refreshMessages() async {
    setState(() => isLoading = true);
    messages = await ChatDatabase.instance.readMessages(widget.user.id);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColorAccent,
                    strokeWidth: 3,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
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
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: messenger,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter a Message',
                    hintStyle: const TextStyle(
                      color: Colors.white54,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: secondaryColor,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
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
                icon: const Icon(
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
    final message = messages[index];
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onLongPress: () {
          ChatDatabase.instance.deleteMessage(message.id);
          refreshMessages();
        },
        child: Row(
          mainAxisAlignment: message.isSender
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              constraints: BoxConstraints(maxWidth: widget.screenWidth * 0.75),
              decoration: BoxDecoration(
                color: message.isSender
                    ? secondaryColorAccent
                    : primaryColorAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                message.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void post() {
    final String message = messenger.text;
    if (message == '') return;
    DateTime now = DateTime.now();
    ChatDatabase.instance.postMessage(ChatMessage(
      receipient: widget.user.id,
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
