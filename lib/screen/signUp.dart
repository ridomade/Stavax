import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stavax_new/constants/colors.dart';
import 'package:stavax_new/model/users.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stavax_new/provider/classUser.dart';
import 'package:stavax_new/screen/home.dart';
import '../widgets/resuablePopUp.dart';

class singUp extends StatefulWidget {
  const singUp({super.key});

  @override
  State<singUp> createState() => _signUpUserState();
}

class _signUpUserState extends State<singUp> {
  final _emailTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: color1,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 116,
            ),
            Text(
              "Enter Email",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff313842),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _emailTextController.text = value;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(
              height: 39,
            ),
            Text(
              "Enter Username",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff313842),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _usernameTextController.text = value;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(
              height: 39,
            ),
            Text(
              "Create password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff313842),
              ),
              child: TextField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _passwordTextController.text = value;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(
              height: 39,
            ),
            Text(
              "Confirm password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff313842),
              ),
              child: TextField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _confirmPasswordTextController.text = value;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(
              height: 39,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 94,
                ),
                InkWell(
                  onTap: () async {
                    try {
                      if (_passwordTextController.text ==
                          _confirmPasswordTextController.text) {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailTextController.text.trim(),
                          password: _passwordTextController.text,
                        );

                        // Successfully created user
                        final cities =
                            FirebaseFirestore.instance.collection("Users");
                        final data = <String, dynamic>{
                          'userName': _usernameTextController.text,
                          'email': _emailTextController.text,
                          'artistRole': false,
                          'listenerRole': true,
                        };
                        cities
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set(data);

                        print("Berhasil buat akun");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                      } else {
                        showAlertDialog(context, "Password not matched");
                      }
                    } catch (error) {
                      // Handle specific errors
                      if (error is FirebaseAuthException) {
                        if (error.code == 'invalid-email') {
                          showAlertDialog(
                              context, "Email address is badly formatted");
                        } else if (error.code == 'weak-password') {
                          showAlertDialog(context,
                              "Password should be at least 6 characters");
                        } else {
                          // Handle other FirebaseAuthException errors if needed
                          showAlertDialog(
                              context, "Registration failed. ${error.message}");
                        }
                      } else {
                        // Handle other errors not related to FirebaseAuthException
                        showAlertDialog(context,
                            "Registration failed. ${error.toString()}");
                      }
                    }
                    // if (_passwordTextController.text ==
                    //     _confirmPasswordTextController.text) {
                    //   FirebaseAuth.instance
                    //       .createUserWithEmailAndPassword(
                    //           email: _emailTextController.text.trim(),
                    //           password: _passwordTextController.text)
                    //       .then((value) async {
                    //     final cities =
                    //         FirebaseFirestore.instance.collection("Users");
                    //     final data = <String, dynamic>{
                    //       'userName': _usernameTextController.text,
                    //       'email': _emailTextController.text,
                    //       'artistRole': false,
                    //       'listenerRole': true,
                    //     };
                    //     cities
                    //         .doc(FirebaseAuth.instance.currentUser!.uid)
                    //         .set(data);
                    //     print("Berhasil buat akun");
                    //     // await FirebaseFirestore.instance
                    //     //     .collection('Songs')
                    //     //     .get()
                    //     //     .then(
                    //     //   (querySnapshot) {
                    //     //     for (var docSnapshot in querySnapshot.docs) {
                    //     //       context.read<UsersProvider>().uploadSong2(
                    //     //             id: docSnapshot.id,
                    //     //             title: docSnapshot.data()['songTitle'],
                    //     //             //nama yang upload
                    //     //             artist: docSnapshot.data()['artistName'],
                    //     //             image: docSnapshot.data()['imageUrl'],
                    //     //             selectedImageFileName:
                    //     //                 docSnapshot.data()['songTitle'],
                    //     //             // download url song
                    //     //             song: docSnapshot.data()['songUrl'],
                    //     //           );
                    //     //     }
                    //     //   },
                    //     //   onError: (e) => print("Error completing: $e"),
                    //     // );
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => Home(),
                    //       ),
                    //     );
                    //   }).onError((error, stackTrace) {
                    //     if (error.toString() ==
                    //         "[firebase_auth/invalid-email] The email address is badly formatted.") {
                    //       showAlertDialog(
                    //           context, "email address is badly formatted");
                    //     } else if (error.toString() ==
                    //         "[firebase_auth/weak-password] Password should be at least 6 characters") {
                    //       showAlertDialog(context,
                    //           "Password should be at least 6 characters");
                    //     }
                    //   });
                    // } else {
                    //   showAlertDialog(context, "Password not matched");
                    // }
                  },
                  child: Container(
                    width: 94,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
