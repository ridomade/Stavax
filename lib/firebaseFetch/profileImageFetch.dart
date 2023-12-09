import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stavax_new/provider/classPlaylist.dart';
import 'package:stavax_new/provider/classUser.dart';
import '../provider/classSong.dart';

Future<Map<String, String>> profileImageFetch() async {
  Map<String, String> profileImage = {};

  try {
    var snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      profileImage[data['profileImageName']] = data['profileImageUrl'];
    }
  } catch (error) {
    print("Error fetching profile image: $error");
  }

  return profileImage;
}
