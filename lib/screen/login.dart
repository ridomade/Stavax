import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/constants/colors.dart';
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
                    //tampilkan semua lagu dalam playlist
                    await context.read<UsersProvider>().tambahLagukePlaylist2();
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text.trim(),
                            password: _passwordTextController.text)
                        .then((value) async {
                      showAlertDialog(context, "Login Berhasil");

                      // tampilkan playlist per user
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("Playlist")
                          .get()
                          .then(
                        (querySnapshot) {
                          for (var docSnapshot in querySnapshot.docs) {
                            context.read<UsersProvider>().tambahPlaylistBaru2(
                                  id: docSnapshot.id,
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

                      // tampikan semua lagu milik artis
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("ArtistSong")
                          .get()
                          .then(
                        (querySnapshot) async {
                          for (var docSnapshot in querySnapshot.docs) {
                            DocumentReference<Map<String, dynamic>>
                                favoriteSongRef = docSnapshot.data()["song"];
                            var adder = await favoriteSongRef.get();
                            context.read<UsersProvider>().uploadSong3(
                                  id: adder.id,
                                  title: adder['songTitle'],
                                  //nama yang upload
                                  artist: adder['artistName'],
                                  image: adder['imageUrl'],
                                  selectedImageFileName: adder['songTitle'],
                                  // download url song
                                  song: adder['songUrl'],
                                );
                          }
                        },
                        onError: (e) => print("Error completing: $e"),
                      );
                      //tampilkan semua lagu yang ada
                      await FirebaseFirestore.instance
                          .collection('Songs')
                          .get()
                          .then(
                        (querySnapshot) {
                          for (var docSnapshot in querySnapshot.docs) {
                            context.read<UsersProvider>().uploadSong2(
                                  id: docSnapshot.id,
                                  title: docSnapshot.data()['songTitle'],
                                  //nama yang upload
                                  artist: docSnapshot.data()['artistName'],
                                  image: docSnapshot.data()['imageUrl'],
                                  selectedImageFileName:
                                      docSnapshot.data()['songTitle'],
                                  // download url song
                                  song: docSnapshot.data()['songUrl'],
                                );
                          }
                        },
                        onError: (e) => print("Error completing: $e"),
                      );

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
