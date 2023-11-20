import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class uploadToFirebase {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  var imageUrl;
  Future<void> uplaodFile(String fileName, String filePath) async {
    File file = File(filePath);
    final imageref = firebaseStorage.ref('Playlist/$fileName');
    try {
      await imageref.putFile(
          file,
          SettableMetadata(
            contentType: 'image/jpeg',
          ));
      imageUrl = await imageref.getDownloadURL();
    } catch (e) {
      print('Error copying file: $e');
    }
  }

  Future<String> getImageUrl() {
    return imageUrl;
  }
}
