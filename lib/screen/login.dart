import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/constants/colors.dart';
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
                size: 34,
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
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text.trim(),
                            password: _passwordTextController.text)
                        .then((value) async {
                      showAlertDialog(context, "Login Berhasil");

                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("Playlist")
                          .get()
                          .then(
                        (querySnapshot) {
                          for (var docSnapshot in querySnapshot.docs) {
                            context.read<UsersProvider>().tambahPlaylistBaru2(
                                  namePlaylist:
                                      docSnapshot.data()['namePlaylist'],
                                  descPlaylist:
                                      docSnapshot.data()['descPlaylist'],
                                  selectedImage: docSnapshot.data()['imageUrl'],
                                  selectedImageFileName:
                                      docSnapshot.data()['imageName'],
                                  imageUrll: docSnapshot.data()['imageUrl'],
                                );
                          }
                        },
                        onError: (e) => print("Error completing: $e"),
                      );

                      // QuerySnapshot querySnapshot = await FirebaseFirestore
                      //     .instance
                      //     .collection('Users')
                      //     .doc(FirebaseAuth.instance.currentUser!.uid)
                      //     .collection("Playlist")
                      //     .get();
                      // final allData =
                      //     querySnapshot.docs.map((doc) => doc.data()).toList();
                      // print("INi all data :");
                      // for (var i = 0; i < allData.length; i++) {
                      //   print(allData[i]);
                      // }

                      // loop read all data playlist curr user
                      // context.read<UsersProvider>().showAllCurrUserPlaylist(
                      //     // namePlaylist: namePlaylist.text,
                      //     // descPlaylist: descPlaylist.text,
                      //     // selectedImage: selectedImage,
                      //     // selectedImageFileName: selectedImageFileName,
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    }).onError((error, stackTrace) {
                      showAlertDialog(context, "Email atau Password salah");
                    });
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
