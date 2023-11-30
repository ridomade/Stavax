import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stavax_new/provider/classSong.dart';
import 'package:stavax_new/provider/classUser.dart';

class ListOfSongs extends ChangeNotifier {
  List<Songs> songArray = [];

  void uploadSonglistDariFetch({
    required List<Songs> song,
  }) async {
    for (var i = 0; i < song.length; i++) {
      songArray.add(Songs(
        id: song[i].id,
        title: song[i].title,
        artist: song[i].artist,
        image: song[i].image,
        song: song[i].song,
      ));
    }
  }

  void uploadSong({
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
        songArray.add(Songs(
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

  void uploadSong2({
    required String title,
    required String artist,
    required String? image,
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
        songArray.add(Songs(
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

  void hapusLaguBener({
    required Songs song,
  }) async {
    songArray.remove(song);
    notifyListeners();
  }

  // void filterSongs(String searchString) {
  //   final filteredSongs = songArray
  //       .where((song) =>
  //           song.title.toLowerCase().contains(searchString.toLowerCase()))
  //       .toList();
  //   songArray = filteredSongs;
  //   notifyListeners();
  // }
}
