import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stavax_new/model/uploadToFirebase.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../constants/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class makePlaylist extends StatefulWidget {
  const makePlaylist({super.key});

  @override
  State<makePlaylist> createState() => _makePlaylistState();
}

class _makePlaylistState extends State<makePlaylist> {
  final namePlaylist = TextEditingController();
  final descPlaylist = TextEditingController();
  var filePath;
  var fileName;
  File? selectedImage;
  String?
      selectedImageFileName; // Tambahkan variabel untuk nama file gambar terpilih
  // Future<void> getImage() async {
  //   final imagePicker = ImagePicker();
  //   final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     Directory appDocDir = await getApplicationDocumentsDirectory();
  //     final imageFileName = pickedFile.name;
  //     final imageFile = File(pickedFile.path);
  //     final localImage = File('${appDocDir.path}/$imageFileName');
  //     String filepath = imageFile.path;
  //     String target = filepath.substring(filepath.lastIndexOf('/') + 1);
  //     // final imageref = FirebaseStorage.instance.ref().child('Playlist/$target');
  //     // File file = File(filepath);
  //     try {
  //       // await imageFile.copy(localImage.path);
  //       // await imageref.putFile(
  //       //     file,
  //       //     SettableMetadata(
  //       //       contentType: 'image/jpeg',
  //       //     ));
  //       // imageUrl = await imageref.getDownloadURL();
  //       print("ini filename ${target}");
  //       print("ini filepath ${filepath}");
  //       setState(() {
  //         fileName = target;
  //         filePath = filepath;
  //         selectedImage = localImage;
  //         selectedImageFileName = imageFileName;
  //       });
  //     } catch (e) {
  //       print('Error copying file: $e');
  //     }
  //   }
  // }

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  // ignore: prefer_typing_uninitialized_variables
  var imageUrl;
  Future<void> uplaodFile(String fileName, String filePath) async {
    File file = File(filePath);
    final uuid = Uuid();
    final uniqueId = uuid.v4();
    fileName = uniqueId.toString() + fileName;
    final imageref = firebaseStorage.ref('Playlist/$fileName');
    try {
      await imageref.putFile(
          file,
          SettableMetadata(
            contentType: 'image/jpeg',
          ));
      //       setState(() {
      //         imageNameInStorage = fileName;
      // });
      imageUrl = await imageref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Playlist")
          .add({
        "namePlaylist": namePlaylist.text,
        "descPlaylist": descPlaylist.text,
        "imageUrl": imageUrl,
        "imageName": fileName,
      });
      print("berhasil buat playlist");
    } catch (e) {
      print('Error copying file: $e');
    }
  }

  Future<void> getImage() async {
    final uuid = Uuid();
    final uniqueId = uuid.v4();
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

  Widget build(BuildContext context) {
    uploadToFirebase service = uploadToFirebase();
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color1,
        automaticallyImplyLeading: false,
        elevation: 0, // ilangin border
        title: Row(
          children: [
            // bisa taro banyak widget
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
              height: 63,
            ),
            Text(
              "Your playlist name",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff313842),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(4),
                ),
                onChanged: (value) {
                  namePlaylist.text = value;
                },
              ),
            ),
            SizedBox(
              height: 21,
            ),
            Text(
              "Your playlist description",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              height: 161,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff313842),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                maxLines: null, // Allow text to wrap to new lines
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  descPlaylist.text = value;
                },
              ),
            ),
            SizedBox(
              height: 22,
            ),
            InkWell(
              onTap: () async {
                await getImage();
                print("selected image : ${selectedImage}");
              },
              child: selectedImage != null
                  ? Container(
                      width: double.infinity,
                      height:
                          72, // Tinggi diatur ke 0 agar tidak ada ruang tambahan
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  : Container(
                      width: double.infinity,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xff313842),
                      ),
                      padding: EdgeInsets.all(6),
                      child: Container(
                        width: 337,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xff004e96),
                        ),
                        child: Center(
                          child: Text(
                            "Insert image",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 128,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  await uplaodFile(fileName, filePath);
                  context.read<UsersProvider>().tambahPlaylistBaru(
                        namePlaylist: namePlaylist.text,
                        descPlaylist: descPlaylist.text,
                        selectedImage: selectedImage,
                        selectedImageFileName: selectedImageFileName,
                        imageUrll: await imageUrl,
                        // imageNameInStorages : imageNameInStorage,
                      );
                  Navigator.pop(context);
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
                      "create",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ), // bisa naro cuma 1 widget
      ),
    );
  }
}
