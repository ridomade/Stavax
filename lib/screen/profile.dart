import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/constants/colors.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/artist.dart';
import 'package:stavax_new/screen/detailedPlaylist.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
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
                size: 34,
              ),
            ),
            Text(
              "Profile",
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
      body: Container(
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
                  backgroundImage:
                      AssetImage('assets/playlist1/playlist1_gambar2.jpg'),
                ),
                SizedBox(
                  width: 33,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                      email,
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
              "Your Playlist",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: context.watch<UsersProvider>().playListArr.isEmpty
                  ? Center(
                      child: Text(
                        "Playlist is empty, please make one",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          context.watch<UsersProvider>().playListArr.length,
                      itemBuilder: (context, index) {
                        if (index <
                            context.watch<UsersProvider>().playListArr.length) {
                          return listPlaylist_user(
                            initialPlaylist: context
                                .watch<UsersProvider>()
                                .playListArr[index],
                            listPlaylist: context.watch<UsersProvider>(),
                            currIdx: index,
                          );
                        }
                      },
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                  width: double.infinity,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xff313842),
                  ),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            height: 200,
                            decoration: BoxDecoration(
                              color: Color(0xff004e96),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Are you sure want to join as STAVAX Artist?",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({'artistRole': true});
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => artistscreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 70,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xff3373b0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sure",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 323,
                      height: 59,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Color(0xff3373b0),
                      ),
                      child: Center(
                        child: Text("Join As Artist",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class listPlaylist_user extends StatelessWidget {
  final Playlist initialPlaylist;
  final UsersProvider listPlaylist;
  final int currIdx;

  const listPlaylist_user({
    Key? key,
    required this.initialPlaylist,
    required this.listPlaylist,
    required this.currIdx,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return detailedPlaylist(
                    iniPlaylist:
                        context.watch<UsersProvider>().playListArr[currIdx],
                    currIdx: currIdx,
                  );
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      Image.file(
                        File(initialPlaylist.image),
                        height: 70,
                        width: 70,
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            initialPlaylist.name,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Text(
                            initialPlaylist.desc,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
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
                            context
                                .read<UsersProvider>()
                                .deletePlaylist(playlist: initialPlaylist);
                            Navigator.pop(context);
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
                                  "Remove Playlist",
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
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
