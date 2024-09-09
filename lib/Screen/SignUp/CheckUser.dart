import 'package:attendence/Screen/SplashScreen/EmailVerification.dart';

import 'package:attendence/Screen/SignUp/Sign.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Checkuser extends StatefulWidget {
  Checkuser({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Checkuser();
  }
}

class _Checkuser extends State<Checkuser> {
  @override
  Widget build(BuildContext context) {
    return userCheck();
  }

  userCheck() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        return ();
      } else {
        Emailverification();
      }
    } else {
      SignUp();
    }
  }
}
