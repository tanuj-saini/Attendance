import 'dart:async';

import 'package:attendence/Screen/UserProfile/UserProfileScreen.dart';
import 'package:attendence/Utils/Colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Emailverification extends StatefulWidget {
  Emailverification({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Emailverification();
  }
}

class _Emailverification extends State<Emailverification> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer time;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.currentUser?.sendEmailVerification();
    time = Timer.periodic(Duration(seconds: 3), (time) {
      _auth.currentUser?.reload();
      if (_auth.currentUser?.emailVerified == true) {
        time.cancel();
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (ctx) => Userprofilescreen()));
        Get.offAll(Userprofilescreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.foreground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Email Verificatoin link is send",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {
                _auth.currentUser?.sendEmailVerification();
              },
              child: Text(
                "Rsend Verification Link",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       _auth.currentUser?.sendEmailVerification();
            //     },
            //     style: ,
            //     child: Text("Rsend Verification Link"))
          ],
        ),
      ),
    );
  }
}
