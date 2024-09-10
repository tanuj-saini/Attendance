import 'package:attendence/Model/UserDto.dart';
import 'package:attendence/Repositry/UserRepositry.dart';
import 'package:attendence/Screen/Controller/UserProfileController.dart';
import 'package:attendence/Screen/UserDashBord/UserDashBoard.dart';
import 'package:attendence/Screen/UserProfile/UserProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailControllerLogin = TextEditingController().obs;
  final passwordControllerLogin = TextEditingController().obs;
  final _api = LoginRepositry();
  FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLodingLogin = false.obs;
  RxBool isLodingSign = false.obs;

  RxBool isLodingGoogle = false.obs;
  RxBool isLodingPhone = false.obs;
  void changeLodingState(bool value, RxBool booleans) {
    booleans.value = value;
  }

  @override
  void onClose() {
    // Dispose of the controllers when the controller is removed
    emailControllerLogin.value.dispose();
    passwordControllerLogin.value.dispose();

    super.onClose();
  }

  final Userprofilecontroller userRepo = Get.put(Userprofilecontroller());
  void emailPasswordLoginUser() async {
    String _email = emailControllerLogin.value.text;
    String _password = passwordControllerLogin.value.text;
    try {
      changeLodingState(true, isLodingLogin);
      UserCredential _credential = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      var _user = _credential.user;

      UserModelDto isTrue = await userRepo.sendDataSignIN(_email, _password);

      if (_user != null && isTrue.name != null) {
        Get.snackbar("User Successfully Logged In", "Welcome!");
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // String? bool = prefs.getString('valid');

        Get.offAll(UserDashBoard());
      } else {
        Get.offAll(Userprofilescreen());
        changeLodingState(false, isLodingLogin);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('********************ERROR2****************');
      Get.snackbar("User Failed", "${e.toString()}");
      debugPrint(e.toString());
      changeLodingState(false, isLodingLogin);
    }
  }

  void googleSignIn() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      changeLodingState(true, isLodingGoogle);
      print("start");

      var account = await _googleSignIn.signIn();

      if (account == null) {
        // User canceled the sign-in or sign-in failed
        changeLodingState(false, isLodingGoogle);
        Get.snackbar("Sign-In Canceled", "User canceled the sign-in.");
        return;
      }

      var authentication = await account.authentication;
      var tokenId = authentication.idToken;

      if (tokenId == null) {
        // Authentication failed or the token is null
        changeLodingState(false, isLodingGoogle);
        Get.snackbar("Authentication Failed", "Could not retrieve token.");
        return;
      }

      print(tokenId);
      print("startApi");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("isGoogle", "yes");
      _api.googleSignUp({
        "token": tokenId,
      }, "/user/googleSignup").then((value) {
        changeLodingState(false, isLodingGoogle);
        Get.snackbar("Successfully Logged In", "Welcome");

        Get.to(Userprofilescreen());
      }).catchError((error) {
        Get.snackbar("Error", error.toString());
        print("Error: $error");
        changeLodingState(false, isLodingGoogle);
      });
    } catch (e) {
      debugPrint('********************ERROR1********************');
      Get.snackbar("Login Failed", e.toString());
      changeLodingState(false, isLodingGoogle);
    }
  }
}
