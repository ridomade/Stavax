import 'package:flutter/material.dart';
import 'package:stavax_new/provider/classSong.dart';

class Playlist extends ChangeNotifier {
  String id;
  String name;
  String image;
  String desc;
  String imageUrl;
  List<Songs> songList = [];

  Playlist({
    this.id = "",
    this.name = "",
    this.image = "",
    this.desc = "",
    this.imageUrl = "",
  });
  Future<void> tambahLagukePlaylistDariFetch({
    required Map datas,
    required Playlist playlist,
  }) async {
    for (var key in datas.keys) {
      for (var value in datas[key]) {
        if (playlist.name == key.name) {
          playlist.songList.add(value);
        }
      }
    }
  }
}
