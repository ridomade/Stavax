import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/constants/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:stavax_new/provider/classUser.dart';

class uploadSong extends StatefulWidget {
  const uploadSong({super.key});

  @override
  State<uploadSong> createState() => _uploadSongState();
}

class _uploadSongState extends State<uploadSong> {
  String? _songPath;
  String? _songFileName;

  Future<void> getSong() async {
    final filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (filePickerResult != null) {
      final songFileName = filePickerResult.files.first.name;
      final songFilePath = filePickerResult.files.first.path;

      setState(() {
        _songPath = songFilePath;
        _songFileName = songFileName;
        print("ini song path : $_songPath");
      });
    }
  }

  final songName = TextEditingController();
  File? selectedImage;
  String?
      selectedImageFileName; // Tambahkan variabel untuk nama file gambar terpilih

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final imageFileName = pickedFile.name;
      final imageFile = File(pickedFile.path);
      final localImage = File('${appDocDir.path}/$imageFileName');
      try {
        await imageFile.copy(localImage.path);
        setState(() {
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
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            SizedBox(
              width: 30,
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
              height: 60,
            ),
            Text(
              "Song Name",
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
                  songName.text = value;
                },
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "Music File",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () async {
                getSong();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xff313842),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // ElevatedButton(
                      //   onPressed: getSong,
                      //   child: Text('Pick MP3 Song'),
                      // ),
                      // SizedBox(height: 16),
                      // Text(_songFileName ?? 'No song selected'),
                      Container(
                        width: 70,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xffd9d9d9),
                        ),
                        child: Center(
                          child: Text(
                            "Select Music",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Text(
                        _songFileName ?? 'No song selected',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 26,
            ),
            InkWell(
              onTap: () {
                // await getImage();
                // if (selectedImage?.path != null) {
                //   print("masuk");
                // } else {
                //   print("gamasuk");
                // }

                getImage();
              },
              child: selectedImage != null
                  ? Container(
                      width: double.infinity,
                      height: 337,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.file(
                            File(selectedImage!.path.toString()),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      height: 337,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xff313842),
                      ),
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color(0xff004e96),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_rounded,
                                size: 80,
                                color: Colors.white,
                              ),
                              Text(
                                "Insert image here",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    context.read<UsersProvider>().uploadSong(
                        title: songName.text,
                        artist: "Asep",
                        image: selectedImage,
                        selectedImageFileName: selectedImageFileName,
                        song: _songPath.toString());
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 94,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xffd9d9d9),
                    ),
                    child: Center(
                      child: Text(
                        "Upload",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
