import 'dart:async';
import 'dart:convert';

import 'package:asn1lib/asn1lib.dart';
import 'package:bluetooth_messenger/constants.dart';
import 'package:bluetooth_messenger/db/chat_database.dart';
import 'package:bluetooth_messenger/screens/chat.dart';
import 'package:bluetooth_messenger/screens/edit_profile.dart';
import 'package:bluetooth_messenger/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage())),
            icon: const Icon(Icons.person_rounded),
            color: secondaryColor,
          ),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage())),
            icon: const Icon(Icons.settings_rounded),
            color: secondaryColor,
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
  String qrCode = "";

  _ChatsState(this.screenWidth, this.screenHeight);

  @override
  void initState() {
    super.initState();
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
                    Icons.qr_code_scanner_rounded,
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
                  onPressed: () => scanQrCode(),
                  backgroundColor: primaryColor,
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: secondaryColor,
                  ),
                ),
              );
  }

  Future<void> scanQrCode() async {
    try {
      final scanner = await FlutterBarcodeScanner.scanBarcode(
        'AB20FD',
        'Back',
        false,
        ScanMode.QR,
      );
      if (!mounted) return;
      setState(() {
        qrCode = scanner;
      });
      addConversation(scanner);
    } on PlatformException {}
  }

  void addConversation(String qrString) {
    final arr = qrString.split("@");
    final address = arr[1];
    final key = arr[2];
    final number = arr[3];
    final username = arr[4];
    ChatDatabase.instance.createPerson(Person(
      number: int.parse(number),
      username: username,
      displayPicture: "",
      publicKey: key,
      address: address,
    ));
    refreshChats();
  }

  FutureOr update(dynamic value) {
    refreshChats();
  }
}
