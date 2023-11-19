import 'package:flutter/material.dart';

import 'package:stavax_new/Screen/login.dart';
import 'package:stavax_new/Screen/signUp.dart';
import 'package:stavax_new/constants/colors.dart';

class loginAndSignUp extends StatefulWidget {
  const loginAndSignUp({super.key});

  @override
  State<loginAndSignUp> createState() => _loginAndSignUpState();
}

class _loginAndSignUpState extends State<loginAndSignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 202,
            ),
            Center(
              child: Text(
                "STAVAX",
                style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                "this is our home login page :)",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 336,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => singUp(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 39,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19.5),
                  color: Color(0xff3373b0),
                ),
                child: Center(
                  child: Text(
                    "Sign up free",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 17,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => login(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 39,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19.5),
                  color: Color(0xff3373b0),
                ),
                child: Center(
                  child: Text(
                    "Log in",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
