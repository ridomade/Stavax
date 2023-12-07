import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:stavax_new/constants/colors.dart';
import 'package:stavax_new/model/cleanCache.dart';
import 'package:stavax_new/provider/classListSongs.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classSong.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/artist.dart';
import 'package:stavax_new/screen/detailedPlaylist.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stavax_new/screen/loginAndSignUp.dart';
import 'package:stavax_new/screen/main_screen.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final db = FirebaseFirestore.instance;
  String userName = " ";
  String email = " ";
  bool artistRole = false;

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
          artistRole = event['artistRole'];
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
              onPressed: () async {
                // await db.collection('Songs').get().then(
                //   (querySnapshot) {
                //     for (var docSnapshot in querySnapshot.docs) {
                //       context.read<UsersProvider>().uploadSong2(
                //             id: docSnapshot.id,
                //             title: docSnapshot.data()['songTitle'],
                //             //nama yang upload
                //             artist: docSnapshot.data()['artistName'],
                //             image: docSnapshot.data()['imageUrl'],
                //             selectedImageFileName:
                //                 docSnapshot.data()['songTitle'],
                //             // download url song
                //             song: docSnapshot.data()['songUrl'],
                //           );
                //     }
                //   },
                //   onError: (e) => print("Error completing: $e"),
                // );
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(
              "Profile",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                SideSheet.right(
                  context: context,
                  sheetColor: color1,
                  width: MediaQuery.of(context).size.width * 0.7,
                  body: Container(
                    padding: EdgeInsets.all(20),
                    child: ProfileEdit(),
                  ),
                );
              },
              icon: Icon(
                Icons.menu,
                size: 30,
                color: Colors.white,
              ),
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
                    onTap: () async {
                      if (artistRole) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => artistscreen(),
                          ),
                        );
                      } else {
                        await showModalBottomSheet<void>(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    onTap: () async {
                                      await FirebaseFirestore.instance
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
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      width: 323,
                      height: 59,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Color(0xff3373b0),
                      ),
                      child: Center(
                        child: artistRole
                            ? Text(
                                "Move to Artist Page",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Join As Artist",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
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

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  bool isEditing = false;
  final db = FirebaseFirestore.instance;
  String userName = "";
  String email = "";
  late TextEditingController usernameController;
  String image = "";
  var filePath;
  var fileName;
  File? selectedImage;
  String? selectedImageFileName;

  @override
  void initState() {
    super.initState();
    getUser();
    usernameController = TextEditingController(text: userName);
  }

  void getUser() {
    final docRef =
        db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);
    docRef.snapshots().listen(
      (event) {
        setState(() {
          userName = event['userName'];
          email = event['email'];
        });
        // userName = event['userName'];
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final imageFileName = pickedFile.name;

      // Convert XFile to File
      final imageFile = File(pickedFile.path);
      String filepath = imageFile.path;
      // Create a destination File in the application's documents directory
      final localImage = File('${appDocDir.path}/$imageFileName');

      // Copy the File
      try {
        await imageFile.copy(localImage.path);
        setState(() {
          fileName = imageFileName;
          filePath = filepath;
          selectedImage = localImage;
          selectedImageFileName = imageFileName;
        });
      } catch (e) {
        print('Error copying file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isEditing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Stack(
                  children: [
                    InkWell(
                        onTap: () async {
                          await getImage();
                        },
                        child: selectedImage != null
                            ? Center(
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(
                                      File(selectedImage!.path.toString())),
                                ),
                              )
                            : Center(
                                child: image != null
                                    ? CircleAvatar(
                                        radius: 60,
                                        backgroundImage: FileImage(File(image)),
                                      )
                                    : CircleAvatar(
                                        radius: 60,
                                        backgroundImage: AssetImage(
                                            'assets/playlist1/playlist1_gambar2.jpg'),
                                      ))),
                    Positioned(
                      right: 55,
                      bottom: 0,
                      child: Icon(
                        Icons.add_circle,
                        size: 40,
                        color: color3,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 22),
                Text(
                  "Username",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: 37,
                  decoration: BoxDecoration(
                    color: Color(0xff25303d),
                  ),
                  child: TextField(
                    controller: usernameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      hintText: 'New Username',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                      child: Container(
                        width: 101,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            "Close",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isEditing = !isEditing;
                          image = selectedImage!.path.toString();
                        });
                        userName = usernameController.text;
                        final userNameRef = db
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        userNameRef
                            .update({"userName": usernameController.text}).then(
                                (value) => print(
                                    "DocumentSnapshot successfully updated!"),
                                onError: (e) =>
                                    print("Error updating document $e"));
                      },
                      child: Container(
                        width: 101,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff004e96),
                        ),
                        child: Center(
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          : Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Container(
                        child: image != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(File(image)),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage(
                                    'assets/playlist1/playlist1_gambar2.jpg'),
                              )),
                    SizedBox(height: 22),
                    Text(
                      usernameController.text.isEmpty
                          ? userName
                          : usernameController
                              .text, // Use the controller's text
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffd9d9d9),
                        ),
                        child: Center(
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: InkWell(
                    onTap: () async {
                      context.read<UsersProvider>().playListArr = [];
                      context.read<UsersProvider>().songArtist = [];
                      context.read<ListOfSongs>().songArray = [];
                      // print("ini panjang array of song");
                      // print(context.read<ListOfSongs>().songArray);
                      // for (var i = 0;
                      //     i < context.read<ListOfSongs>().songArray.length;
                      //     i++) {
                      //   context
                      //       .read<ListOfSongs>()
                      //       .songArray
                      //       .remove(context.read<ListOfSongs>().songArray[i]);
                      // }
                      // print(context.read<ListOfSongs>().songArray);
                      // print("ini panjang playl");
                      // print(context.read<UsersProvider>().playListArr);
                      // context.read<UsersProvider>().playListArr.clear();
                      // print(context.read<UsersProvider>().playListArr);
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => (loginAndSignUp()),
                        ),
                      );
                    },
                    child: Container(
                      width: 222,
                      height: 43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffff2020),
                      ),
                      child: Center(
                        child: Text(
                          "Log out",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                      Container(
                        alignment: Alignment.topCenter,
                        child: initialPlaylist.image != null
                            ? File(initialPlaylist.image)
                                    .existsSync() // Check if it's a local file
                                ? Image.file(
                                    File(initialPlaylist.image),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    initialPlaylist.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                            : SizedBox
                                .shrink(), // An empty container, you can use other widgets like Container() if needed
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
