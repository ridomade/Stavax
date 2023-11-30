import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../provider/classSong.dart';

Future<List<Songs>> artistSongFetch() async {
  List<Songs> artistSongArr = [];

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("ArtistSong")
      .get()
      .then(
    (querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        DocumentReference<Map<String, dynamic>> favoriteSongRef =
            docSnapshot.data()["song"];
        var adder = await favoriteSongRef.get();
        Songs song = Songs(
          id: adder.id,
          title: adder['songTitle'],
          artist: adder['artistName'],
          image: adder['imageUrl'],
          song: adder['songUrl'],
        );
        artistSongArr.add(song);
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return artistSongArr;
}
