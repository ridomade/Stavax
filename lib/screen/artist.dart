import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stavax_new/provider/classSong.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/uploadSong.dart';

class artistscreen extends StatefulWidget {
  const artistscreen({super.key});

  @override
  State<artistscreen> createState() => _artistscreenState();
}

class _artistscreenState extends State<artistscreen> {
  final db = FirebaseFirestore.instance;
  String userName = " ";
  String email = " ";

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() {
    final docRef =
        db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);
    docRef.snapshots().listen(
      (event) {
        final source = (event.metadata.hasPendingWrites) ? "Local" : "Server";

        setState(() {
          userName = event['userName'];
          email = event['email'];
        });
        // userName = event['userName'];
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color1,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Text(
                "Artist",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(
                width: 45,
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 60, // Image radius
                        backgroundImage: AssetImage(
                            'assets/playlist1/playlist1_gambar2.jpg'),
                      ),
                      SizedBox(
                        width: 33,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${userName}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Text(
                            "${email}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Your Song",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: context.watch<UsersProvider>().songArtist.isEmpty
                        ? Center(
                            child: Text(
                              "Your song is empty",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: context
                                .watch<UsersProvider>()
                                .songArtist
                                .length,
                            itemBuilder: (context, index) {
                              if (index <
                                  context
                                      .watch<UsersProvider>()
                                      .songArtist
                                      .length) {
                                return ListSong(
                                    inisong: context
                                        .watch<UsersProvider>()
                                        .songArtist[index],
                                    iniuser: context.watch<UsersProvider>(),
                                    currIdx: index);
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: 20, bottom: 20), // Add margin here
                    child: FloatingActionButton(
                      backgroundColor: color3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => uploadSong(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.add_rounded,
                        size: 50,
                        color: color1,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class ListSong extends StatelessWidget {
  final Songs inisong;
  final UsersProvider iniuser;
  final int currIdx;
  const ListSong({
    Key? key,
    required this.inisong,
    required this.iniuser,
    required this.currIdx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 82,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Color(0xff004e96),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: inisong.image != null
                        ? File(inisong.image)
                                .existsSync() // Check if it's a local file
                            ? Image.file(
                                File(inisong.image),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : inisong.image.startsWith(
                                    'assets/') // Check if it's an asset
                                ? Image.asset(
                                    inisong.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    inisong.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                        : SizedBox.shrink(),
                  ),
                  SizedBox(
                    width: 11,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inisong.title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        inisong.artist,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {
                        // Perform actions on tap
                        // e.g., call a function to remove the song
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 111,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFF004E96),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Delete Song",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
