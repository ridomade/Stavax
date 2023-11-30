import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../provider/classSong.dart';

Future<Map> insidePlaylistFetch() async {
  var data = new Map();
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Playlist")
      .get()
      .then(
    (querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        List<Songs> songList = [];
        Playlist PlaylistArrData = Playlist(
          id: docSnapshot.id,
          name: docSnapshot.data()['namePlaylist'],
          desc: docSnapshot.data()['descPlaylist'],
          imageUrl: docSnapshot.data()['imageUrl'],
          image: docSnapshot.data()['imageName'],
        );
        for (var i = 0; i < docSnapshot.data()["song"].length; i++) {
          var song = await docSnapshot.data()["song"][i].get();
          Songs songAdder = Songs(
            id: song.id,
            title: song['songTitle'],
            artist: song['artistName'],
            image: song['imageUrl'],
            song: song['songUrl'],
          );
          songList.add(songAdder);
        }
        data[PlaylistArrData] = songList;
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  print(data);
  return data;
}
