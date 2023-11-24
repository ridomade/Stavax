import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stavax_new/provider/classSong.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class UsersProvider extends ChangeNotifier {
  String id;
  String email;
  String username;
  String password;
  String profileImage;
  bool artistRole;
  bool listenerRole;
  List<Playlist> playListArr = [];

  UsersProvider({
    this.id = "",
    this.email = "",
    this.username = "",
    this.password = "",
    this.profileImage = "",
    this.artistRole = true,
    this.listenerRole = true,
  });

  void tambahPlaylistBaru({
    required String namePlaylist,
    required String descPlaylist,
    required File? selectedImage,
    required String? selectedImageFileName,
    required String imageUrll,
    // required String imageNameInStorage,
  }) async {
    final uuid = Uuid();
    if (namePlaylist.isNotEmpty &&
        selectedImage != null &&
        selectedImageFileName != null) {
      // Mendapatkan direktori dokumen aplikasi
      final appDocDir = await getApplicationDocumentsDirectory();
      final imageFileName =
          selectedImageFileName; // Menggunakan nama file yang terpilih
      final localImage = File("${appDocDir.path}/$imageFileName");
      // Mengecek apakah file lokal ada
      if (await localImage.exists()) {
        final uniqueId = uuid.v4();
        // File lokal ada, Anda bisa menggunakan localImage untuk mengaksesnya
        // Tambahkan playlist baru dengan path gambar lokal
        playListArr.add(Playlist(
          id: uniqueId.toString(), // Sesuaikan dengan kebutuhan
          name: namePlaylist, // Menggunakan value dari namePlaylist
          image: localImage.path,
          desc: descPlaylist, // Menggunakan value dari descPlaylist
          imageUrl: imageUrll,
          // imageNameInStorages: imageNameInStorage,
        ));
        notifyListeners();
        // Bersihkan input setelah menambah playlist baru
        // Lakukan tindakan lain setelah berhasil menambahkan playlist
      } else {
        // File lokal tidak ditemukan, Anda perlu menanganinya sesuai kebutuhan Anda
        print('File lokal tidak ditemukan.');
      }
    }
  }

  void tambahPlaylistBaru2({
    required String namePlaylist,
    required String descPlaylist,
    required String selectedImage,
    required String? selectedImageFileName,
    required String imageUrll,
  }) async {
    final uuid = Uuid();
    final uniqueId = uuid.v4();
    if (namePlaylist.isNotEmpty &&
        selectedImage != null &&
        selectedImageFileName != null) {
      playListArr.add(Playlist(
        id: uniqueId.toString(), // Sesuaikan dengan kebutuhan
        name: namePlaylist, // Menggunakan value dari namePlaylist
        image: selectedImage,
        desc: descPlaylist, // Menggunakan value dari descPlaylist
        imageUrl: imageUrll,
      ));
      notifyListeners();
      // Bersihkan input setelah menambah playlist baru
      // Lakukan tindakan lain setelah berhasil menambahkan playlist
    }
  }

  void deletePlaylist({
    required Playlist playlist,
  }) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Playlist")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          if (await docSnapshot.data()["namePlaylist"] == playlist.name &&
              await docSnapshot.data()["descPlaylist"] == playlist.desc &&
              await docSnapshot.data()["imageUrl"] == playlist.imageUrl) {
            // print("ini image url dari database");
            // print(docSnapshot.data()['imageUrl']);
            // print("ini image url dari lokal");
            // print(playlist.image);
            String deleteStorage = await docSnapshot.data()["imageName"];
            final desertRef = FirebaseStorage.instance
                .ref()
                .child("Playlist/" + deleteStorage);
            await desertRef.delete();
            await docSnapshot.reference.delete();
            print("Berhasil Hapus Playlist");
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    playListArr.remove(playlist);
    notifyListeners();
  }

  void tambahLagukePlaylist({required Playlist playlist, required Songs song}) {
    playlist.songList.add(song);
    notifyListeners();
  }

  void hapusLagukePlaylist({required Playlist playlist, required Songs song}) {
    playlist.songList.remove(song);
    notifyListeners();
  }
}
