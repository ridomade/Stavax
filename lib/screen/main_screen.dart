import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/home.dart';
import 'package:stavax_new/screen/loginAndSignUp.dart';

class main_screen extends StatelessWidget {
  const main_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              FirebaseAuth.instance.currentUser!.uid;
              return Home();
            } else {
              return loginAndSignUp();
            }
          }),
    );
  }
}
