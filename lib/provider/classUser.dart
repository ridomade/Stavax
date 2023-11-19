import 'package:flutter/material.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stavax_new/provider/classSong.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

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

  void deletePlaylist({required Playlist playlist}) async {
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
