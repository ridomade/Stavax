import 'package:cloud_firestore/cloud_firestore.dart';
import '../provider/classSong.dart';

Future<List<Songs>> songFetch() async {
  List<Songs> songArr = [];
  QuerySnapshot songsSnapshot =
      await FirebaseFirestore.instance.collection('Songs').get();
  songsSnapshot.docs.forEach((doc) {
    Map<String, dynamic> songData = doc.data() as Map<String, dynamic>;

    Songs song = Songs(
      id: doc.id,
      title: songData['songTitle'],
      artist: songData['artistName'],
      image: songData['imageUrl'],
      song: songData['songUrl'],
    );
    songArr.add(song);
  });
  return songArr;
}
