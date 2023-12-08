import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../provider/classSong.dart';

Future<Map<String, String>> profileImageFetch() async {
  var profileImage = new Map<String, String>();
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("ProfileImage")
      .get()
      .then(
    (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        profileImage[docSnapshot.data()["profileImageName"]] =
            docSnapshot.data()["profileImageUrl"];
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return profileImage;
}
