import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/constants/colors.dart';
import 'package:stavax_new/provider/classListSongs.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classSong.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/home.dart';
import '../widgets/resuablePopUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    initializeFirestore();
  }

  void _showLoading() {
    EasyLoading.show();
  }

  void _hideLoading() {
    EasyLoading.dismiss();
  }

  Future<void> initializeFirestore() async {
    db = FirebaseFirestore.instance;
    // try {
    //   // Attempt to get the Firestore instance
    //   db = FirebaseFirestore.instance;
    //   // Access or perform operations on the Firestore instance as needed

    //   print("Firestore instance obtained successfully");
    // } catch (e) {
    //   // Handle the error
    //   print("Error accessing Firestore: $e");

    //   // Check if the error is due to no Firebase app being created
    //   if (e is FirebaseException && e.code == 'app-not-initialized') {
    //     print("No Firebase app has been created.");
    //     // You might want to initialize Firebase here or take appropriate action.
    //     // Example: Firebase.initializeApp();
    //   }
    // }
  }

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: color1,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 116,
            ),
            Text(
              "Email",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff313842),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _emailTextController.text = value;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(
              height: 39,
            ),
            Text(
              "Password",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff313842),
              ),
              child: TextField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _passwordTextController.text = value;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(
              height: 43,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 94,
                ),
                InkWell(
                  onTap: () async {
                    // tampilkan semua lagu dalam playlist
                    // await context.read<UsersProvider>().tambahLagukePlaylist2();
                    _showLoading();
                    if (_emailTextController.text != "" &&
                        _passwordTextController.text != "") {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailTextController.text.trim(),
                          password: _passwordTextController.text,
                        );

                        // Successful login
                        showAlertDialog(context, "Login Berhasil");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                      } catch (error) {
                        // Handle login failure
                        showAlertDialog(
                            context, "Email or Password is Incorrect");
                        print("Login error: $error");
                      }
                    } else {
                      if (_emailTextController.text == "" &&
                          _passwordTextController.text == "") {
                        showAlertDialog(
                            context, "You must fill in all the form fields!");
                      } else if (_passwordTextController.text == "") {
                        showAlertDialog(context, "Password Cannot be Empty!");
                      } else if (_emailTextController.text == "") {
                        showAlertDialog(context, "Email Cannot be Empty!");
                      }
                    }
                    _hideLoading();
                  },
                  child: Container(
                    width: 94,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
