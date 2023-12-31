import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../provider/classSong.dart';

Future<Map<Playlist, dynamic>> insidePlaylistFetch() async {
  var data = new Map<Playlist, dynamic>();
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
        try {
          if (docSnapshot.data()["song"] != null) {
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
          } else {
            print("The 'song' field is null in the document.");
            // Handle the case where 'song' field is null
          }
        } catch (e) {
          print("Error fetching songs: $e");
          // Handle the error as needed
        }
        data[PlaylistArrData] = songList;
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return data;
}
