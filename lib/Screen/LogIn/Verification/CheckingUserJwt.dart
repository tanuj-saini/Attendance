import 'package:attendence/Screen/Controller/UserProfileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Checkinguserjwt extends StatefulWidget {
  final String jwtToken;
  Checkinguserjwt({required this.jwtToken, super.key});
  @override
  State<StatefulWidget> createState() {
    return _CheckingUser();
  }
}

class _CheckingUser extends State<Checkinguserjwt> {
  final Userprofilecontroller userRepos = Get.put((Userprofilecontroller()));
  @override
  void initState() {
    userRepos.checkUserToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Obx(() => userRepos.isLoading.value != true
              ? Text("Validating Credentails")
              : CircularProgressIndicator())),
    );
  }
}
