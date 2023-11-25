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
                                  namePlaylist:
                                      docSnapshot.data()['namePlaylist'],
                                  descPlaylist:
                                      docSnapshot.data()['descPlaylist'],
                                  selectedImage: docSnapshot.data()['imageUrl'],
                                  selectedImageFileName:
                                      docSnapshot.data()['imageName'],
                                  imageUrll: docSnapshot.data()['imageUrl'],
                                );
                            Playlist playlist = Playlist(
                                name: docSnapshot.data()['namePlaylist'],
                                image: docSnapshot.data()['imageName'],
                                desc: docSnapshot.data()['descPlaylist'],
                                imageUrl: docSnapshot.data()['imageUrl']);
                            Songs song = Songs(
                                id: "d3b6a72f-2e57-4cfd-8a18-76ed283cc831",
                                title: "2",
                                artist: "Made Rido",
                                image:
                                    "https://firebasestorage.googleapis.com/v0/b/stavax-new.appspot.com/o/Song%2FImages%2F43b6f772-9d22-470a-880d-478e46c4d29cdownload.jpg?alt=media&token=a3cbaada-d1be-4245-90e3-ec62f34f32bb",
                                song:
                                    "https://firebasestorage.googleapis.com/v0/b/stavax-new.appspot.com/o/Song%2FSongs%2F3b9b7f27-89b8-4f23-981f-69e92599208ay2mate.com%20-%20DRUM%20ROLL%20SOUND%20EFFECT%20Awarding.mp3?alt=media&token=8c0d93cc-b809-476f-a3aa-e3744662c9e7");
                            context.read<UsersProvider>().tambahLagukePlaylist2(
                                //tambah lagu
                                playlist: playlist,
                                song: song);
                            print(playlist.name);
                            print(song.artist);
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
