import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../provider/classSong.dart';

Future<List<Playlist>> playlistFetch() async {
  List<Playlist> PlaylistArr = [];

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Playlist")
      .get()
      .then(
    (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        Playlist PlaylistArrData = Playlist(
          id: docSnapshot.id,
          name: docSnapshot.data()['namePlaylist'],
          desc: docSnapshot.data()['descPlaylist'],
          imageUrl: docSnapshot.data()['imageUrl'],
          image: docSnapshot.data()['imageName'],
        );
        PlaylistArr.add(PlaylistArrData);
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return PlaylistArr;
}
