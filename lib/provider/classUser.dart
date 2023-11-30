import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stavax_new/firebaseFetch/playlistFetch.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stavax_new/provider/classSong.dart';
import 'package:stavax_new/provider/classListSongs.dart';
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
  List<Songs> songArtist = [];

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
    required String id,
    required String namePlaylist,
    required String descPlaylist,
    required File? selectedImage,
    required String? selectedImageFileName,
    required String imageUrll,
    // required String imageNameInStorage,
  }) async {
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
        // File lokal ada, Anda bisa menggunakan localImage untuk mengaksesnya
        // Tambahkan playlist baru dengan path gambar lokal
        playListArr.add(Playlist(
          id: id, // Sesuaikan dengan kebutuhan
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

  void tambahPlaylistDariFetch({
    required List<Playlist> playlist,
  }) async {
    for (var i = 0; i < playlist.length; i++) {
      playListArr.add(Playlist(
        id: playlist[i].id,
        name: playlist[i].name,
        image: playlist[i].imageUrl,
        desc: playlist[i].desc,
        imageUrl: playlist[i].imageUrl,
      ));
    }
  }

  void tambahPlaylistBaru2({
    required String id,
    required String namePlaylist,
    required String descPlaylist,
    required String selectedImage,
    required String? selectedImageFileName,
    required String imageUrll,
  }) async {
    if (namePlaylist.isNotEmpty &&
        selectedImage != null &&
        selectedImageFileName != null) {
      playListArr.add(Playlist(
        id: id, // Sesuaikan dengan kebutuhan
        name: namePlaylist, // Menggunakan value dari namePlaylist
        image: selectedImage,
        desc: descPlaylist, // Menggunakan value dari descPlaylist
        imageUrl: imageUrll,
      ));
      // print(id);
      // print(namePlaylist);
      // print(selectedImage);
      // print(descPlaylist);
      // print(imageUrll);

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
            String deleteStorage = await docSnapshot.data()["imageName"];
            final desertRef = FirebaseStorage.instance
                .ref()
                .child("Playlist/" + deleteStorage);

            await desertRef.delete();
            await docSnapshot.reference.delete();
            print(desertRef);
            print(docSnapshot.reference);
            print("Berhasil Hapus Playlist");
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    // print(playlist.id);
    // print(playlist.name);
    // print(playlist.desc);
    // print(playlist.image);
    // print(playlist.imageUrl);
    playListArr.remove(playlist);
    notifyListeners();
  }

  Future<void> tambahLagukePlaylist(
      {required Playlist playlist, required Songs song}) async {
    // print(">>>>>>");
    // print(playlist.id);
    // print(playlist.name);
    // print(playlist.image);
    // print(playlist.desc);
    // print(playlist.imageUrl);
    // print(">>>>>>");
    // print(song.id);
    // print(song.title);
    // print(song.artist);
    // print(song.image);
    // print(song.song);
    // print(">>>>>>");
    playlist.songList.add(song);
    var songReference =
        FirebaseFirestore.instance.collection("Songs").doc(song.id);
    var db = FirebaseFirestore.instance;
    db
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Playlist")
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          if (await docSnapshot.data()["namePlaylist"] == playlist.name &&
              await docSnapshot.data()["descPlaylist"] == playlist.desc &&
              await docSnapshot.data()["imageUrl"] == playlist.imageUrl) {
            db
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("Playlist")
                .doc(docSnapshot.id.toString())
                .update({
              "song": FieldValue.arrayUnion([songReference]),
            });
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    notifyListeners();
  }

  Future<void> tambahLagukePlaylistDariFetch({
    required Map datas,
    required Playlist playlist,
  }) async {
    for (var key in datas.keys) {
      for (var value in datas[key]) {
        playlist.songList.add(value);
      }
    }
  }

  void hapusLagukePlaylist({required Playlist playlist, required Songs song}) {
    playlist.songList.remove(song);
    notifyListeners();
  }

  Future<void> hapusLaguArtist(
      {required UsersProvider user, required Songs song}) async {
    var deletedSongCollection =
        await FirebaseFirestore.instance.collection("Songs");

    var deletedArtistSongCollection = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("ArtistSong");

    deletedSongCollection.doc(song.id).get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;

      await FirebaseStorage.instance
          .ref()
          .child("Song/Songs/" + data["songNameUrl"])
          .delete();
      await FirebaseStorage.instance
          .ref()
          .child("Song/Images/" + data["imageNameUrl"])
          .delete();
      await deletedSongCollection.doc(song.id).delete();
      deletedArtistSongCollection
          .where("song", isEqualTo: deletedSongCollection.doc(song.id))
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await deletedArtistSongCollection.doc(docSnapshot.id).delete();
        }
      });
    });

    notifyListeners();
  }

  //hapus lagu dari collection Songs dan collection artisSong
  Future<void> deleteSongArtist(
      {required UsersProvider user, required Songs song}) async {
    var deletedSongCollection =
        await FirebaseFirestore.instance.collection("Songs");

    var deletedArtistSongCollection = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("ArtistSong");

    deletedSongCollection.doc(song.id).get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;

      await FirebaseStorage.instance
          .ref()
          .child("Song/Songs/" + data["songNameUrl"])
          .delete();
      await FirebaseStorage.instance
          .ref()
          .child("Song/Images/" + data["imageNameUrl"])
          .delete();
      // delete Songs Collection
      await deletedSongCollection.doc(song.id).delete();
      // delete ArtistSong Collection
      deletedArtistSongCollection
          .where("song", isEqualTo: deletedSongCollection.doc(song.id))
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await deletedArtistSongCollection.doc(docSnapshot.id).delete();
        }
      });
    });
    user.songArtist.remove(song);
    notifyListeners();
  }

  void uploadSongArtist({
    required String title,
    required String artist,
    required File? image,
    required String? selectedImageFileName,
    required String song,
    required String id,
  }) async {
    if (title.isNotEmpty && image != null && selectedImageFileName != null) {
      // Mendapatkan direktori dokumen aplikasi
      final appDocDir = await getApplicationDocumentsDirectory();
      final imageFileName =
          selectedImageFileName; // Menggunakan nama file yang terpilih
      final localImage = File("${appDocDir.path}/$imageFileName");
      // Mengecek apakah file lokal ada
      if (await localImage.exists()) {
        // File lokal ada, Anda bisa menggunakan localImage untuk mengaksesnya
        // Tambahkan playlist baru dengan path gambar lokal
        songArtist.add(Songs(
          id: id,
          title: title,
          artist: artist,
          image: localImage.path,
          song: song,
        ));

        // print(id);
        // print(title);
        // print(artist);
        // print(image);
        // print(song);
        notifyListeners();
        // Bersihkan input setelah menambah playlist baru
        // Lakukan tindakan lain setelah berhasil menambahkan playlist
      } else {
        // File lokal tidak ditemukan, Anda perlu menanganinya sesuai kebutuhan Anda
        print('File lokal tidak ditemukan.');
      }
    }
  }

  // Future<void> deleteSong({
  //   required String id,
  //   required String title,
  //   required String artist,
  //   required String image,
  //   required String song,
  // }) async {
  //   print(songArr[0].id);
  //   songArr.remove(Songs(
  //     id: id,
  //     title: title,
  //     artist: artist,
  //     image: image,
  //     song: song,
  //   ));
  //   songArtist.remove(Songs(
  //     id: id,
  //     title: title,
  //     artist: artist,
  //     image: image,
  //     song: song,
  //   ));
  //   print(songArr[0].id);

  //   // print(File(id));
  //   // print(title);
  //   // print(artist);
  //   // print(image);
  //   // print(song);
  //   var deletedSongCollection =
  //       await FirebaseFirestore.instance.collection("Songs");

  //   var deletedArtistSongCollection = await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("ArtistSong");

  //   deletedSongCollection.doc(id).get().then((DocumentSnapshot doc) async {
  //     final data = doc.data() as Map<String, dynamic>;

  //     await FirebaseStorage.instance
  //         .ref()
  //         .child("Song/Songs/" + data["songNameUrl"])
  //         .delete();
  //     await FirebaseStorage.instance
  //         .ref()
  //         .child("Song/Images/" + data["imageNameUrl"])
  //         .delete();
  //     await deletedSongCollection.doc(id).delete();
  //     deletedArtistSongCollection
  //         .where("song", isEqualTo: deletedSongCollection.doc(id))
  //         .get()
  //         .then((querySnapshot) async {
  //       for (var docSnapshot in querySnapshot.docs) {
  //         await deletedArtistSongCollection.doc(docSnapshot.id).delete();
  //       }
  //     });
  //   });
  //   notifyListeners();
  //   print("berhasil Hapus Lagu");
  // }

  // void uploadSong({
  //   required String title,
  //   required String artist,
  //   required File? image,
  //   required String? selectedImageFileName,
  //   required String song,
  //   required String id,
  //   required _ListOfSong listsong
  // }) async {
  //   if (title.isNotEmpty && image != null && selectedImageFileName != null) {
  //     // Mendapatkan direktori dokumen aplikasi
  //     final appDocDir = await getApplicationDocumentsDirectory();
  //     final imageFileName =
  //         selectedImageFileName; // Menggunakan nama file yang terpilih
  //     final localImage = File("${appDocDir.path}/$imageFileName");
  //     // Mengecek apakah file lokal ada
  //     if (await localImage.exists()) {
  //       // File lokal ada, Anda bisa menggunakan localImage untuk mengaksesnya
  //       // Tambahkan playlist baru dengan path gambar lokal
  //       _listofSong.songArray.add(Songs(
  //         id: id,
  //         title: title,
  //         artist: artist,
  //         image: localImage.path,
  //         song: song,
  //       ));
  //       songArtist.add(Songs(
  //         id: id,
  //         title: title,
  //         artist: artist,
  //         image: localImage.path,
  //         song: song,
  //       ));

  //       // print(id);
  //       // print(title);
  //       // print(artist);
  //       // print(image);
  //       // print(song);
  //       notifyListeners();
  //       // Bersihkan input setelah menambah playlist baru
  //       // Lakukan tindakan lain setelah berhasil menambahkan playlist
  //     } else {
  //       // File lokal tidak ditemukan, Anda perlu menanganinya sesuai kebutuhan Anda
  //       print('File lokal tidak ditemukan.');
  //     }
  //   }
  // }

  void uploadSong2({
    required String id,
    required String title,
    required String artist,
    required String image,
    required String selectedImageFileName,
    required String song,
    required ListOfSongs listOfSongs,
  }) async {
    if (title.isNotEmpty && image != null && selectedImageFileName != null) {
      listOfSongs.songArray.add(Songs(
        id: id,
        title: title,
        artist: artist,
        image: image,
        song: song,
      ));
      notifyListeners();
    }
  }

  // void uploadSong3({
  //   required String id,
  //   required String title,
  //   required String artist,
  //   required String image,
  //   required String selectedImageFileName,
  //   required String song,
  // }) async {
  //   if (title.isNotEmpty && image != null && selectedImageFileName != null) {
  //     songArtist.add(Songs(
  //       id: id,
  //       title: title,
  //       artist: artist,
  //       image: image,
  //       song: song,
  //     ));
  //     notifyListeners();
  //   }
  // }
  void uploadSongArtistlistDariFetch({
    required List<Songs> song,
  }) async {
    for (var i = 0; i < song.length; i++) {
      songArtist.add(Songs(
        id: song[i].id,
        title: song[i].title,
        artist: song[i].artist,
        image: song[i].image,
        song: song[i].song,
      ));
    }
  }
}
