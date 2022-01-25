import 'package:bluetooth_messenger/constants.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_messenger/screens/setting.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: secondaryColor,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: primaryColorAccent,
                ),
              ),
              Divider(
                height: screenHeight / 40,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: primaryColorAccent,
                          ),
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/taki.png'))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: primaryColorAccent,
                        ),
                        child: Center(
                          child: IconButton(
                            enableFeedback: false,
                            splashRadius: 1,
                            icon: const Icon(Icons.edit),
                            color: secondaryColor,
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: screenHeight / 40,
              ),
              buildTextField("Full Name", "Enter your name", false),
              buildTextField("E-mail", "Enter your Email", false),
              buildTextField(
                  "About you", "Describe something about you ", false),
              buildTextField("Pnone", "7672377623", false),
              Divider(
                height: screenHeight / 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    color: secondaryColorAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: primaryColorAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        style: const TextStyle(
          color: primaryColor,
        ),
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              width: 1.0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              width: 1.0,
            ),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: primaryColorAccent,
            fontSize: 16,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: placeholder,
          hintStyle: const TextStyle(
            color: primaryColorAccent,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
