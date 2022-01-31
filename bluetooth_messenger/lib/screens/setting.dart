import 'package:bluetooth_messenger/constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String bluetoothAddress = "";
  String RSAPublicKey = "";
  String phoneNumber = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    getBluetoothAddress();
    getRSAPublicKey();
    getPhoneNumber();
    getUsername();
  }

  void getBluetoothAddress() {}

  void getRSAPublicKey() async {
    final prefs = await SharedPreferences.getInstance();
    String storedRSAPublicKey = prefs.getString('RSAPublicKey') ?? "";
    RSAPublicKey = storedRSAPublicKey;
  }

  void getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    String storedPhoneNumber = prefs.getString('phoneNumber') ?? "";
    phoneNumber = storedPhoneNumber;
  }

  void getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String storedUsername = prefs.getString('username') ?? "";
    username = storedUsername;
  }

  String generateQRString() {
    return '@' +
        bluetoothAddress +
        '@' +
        RSAPublicKey +
        '@' +
        phoneNumber +
        '@' +
        username +
        '@';
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
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
        title: const Text(
          "Settings",
          style: TextStyle(
            color: secondaryColor,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              child: QrImage(
                data: generateQRString(),
                version: QrVersions.auto,
                size: screenWidth / 1.5,
                foregroundColor: Colors.grey[600],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, "Change password"),
            buildAccountOptionRow(context, "Content settings"),
            buildAccountOptionRow(context, "Social"),
            buildAccountOptionRow(context, "Language"),
            buildAccountOptionRow(context, "Privacy and security"),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: OutlineButton(
                padding: EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {},
                child: const Text("SIGN OUT",
                    style: TextStyle(
                        fontSize: 16, letterSpacing: 2.2, color: Colors.grey)),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
