// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stavax_new/provider/classUser.dart';
// import 'package:stavax_new/screen/home.dart';
// import 'package:stavax_new/screen/loginAndSignUp.dart';

// class main_screen extends StatelessWidget {
//   const main_screen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               // FirebaseAuth.instance.currentUser!.uid;
//               return Home();
//             } else {
//               return loginAndSignUp();
//             }
//           }),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/provider/classListSongs.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/home.dart';
import 'package:stavax_new/screen/loginAndSignUp.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  Future<User?> _checkUser() async {
    return await FirebaseAuth.instance.authStateChanges().first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: _checkUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking authentication state.
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            context.read<ListOfSongs>().songArray = [];
            context.read<UsersProvider>().songArtist = [];
            context.read<UsersProvider>().playListArr = [];
            // FirebaseAuth.instance.currentUser!.uid;
            return Home();
          } else {
            return loginAndSignUp();
          }
        },
      ),
    );
  }
}
