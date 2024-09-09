import 'package:attendence/Model/UserDto.dart';
import 'package:attendence/Screen/UserDashBord/UserDashBoard.dart';
import 'package:attendence/Screen/Controller/UserProfileController.dart';
import 'package:attendence/Screen/UserProfile/UserProfileScreen.dart';
import 'package:attendence/Services/AuthService.dart';
import 'package:attendence/Screen/SplashScreen/splashScreen.dart';
import 'package:attendence/Screen/SplashScreen/EmailVerification.dart';
import 'package:attendence/Screen/SignUp/Sign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignViewModelContoller extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // final AuthService _authService = AuthService();
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  RxBool isLodingLogin = false.obs;
  RxBool isLodingSign = false.obs;
  RxBool isLodingGoogle = false.obs;
  RxBool isLodingPhone = false.obs;
  void changeLodingState(bool value, RxBool booleans) {
    booleans.value = value;
  }

  final Userprofilecontroller userRepo = Get.put(Userprofilecontroller());
  void emailPasswordCreateUser(BuildContext context) async {
    String _email = emailController.value.text;
    String _password = passwordController.value.text;
    try {
      changeLodingState(true, isLodingSign);
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      await _credential.user?.sendEmailVerification();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Emailverification()));

      debugPrint('Please verify your email!');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("valid", "false");

      bool isTrue = await userRepo.sendDataSignup(_email, _password); //

      changeLodingState(false, isLodingSign);
      if (isTrue) {
        Get.snackbar("Verification Email Sent", "Please verify your email!");

        Get.to(Emailverification());
      } else {
        Get.snackbar("Verification Failed", "Falied!!");
        Get.to(SplashScreen());
      }
    } catch (e) {
      debugPrint('********************ERROR1****************');
      Get.snackbar("User Failed", "${e.toString()}");
      changeLodingState(false, isLodingSign);
      debugPrint(e.toString());
    }
  }

  void emailPasswordLoginUser() async {
    String _email = emailController.value.text;
    String _password = passwordController.value.text;
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

  void logoutUser() async {
    try {
      await _auth.signOut(); // Firebase signOut
      Get.snackbar("Logged Out", "You have been logged out successfully.");

      // After sign out, navigate to the login screen
      Get.offAll(() =>
          SplashScreen()); // Navigate to the Login screen and clear all previous screens
    } catch (e) {
      Get.snackbar("Logout Failed", "${e.toString()}");
    }
  }

  forgetPassword() async {
    if (emailController.value.text == "") {
      Get.snackbar("Email Error", "Please Enter Valid Email");
    }
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.value.text);
    Get.snackbar("Rest Password", "Email Send Successfull");
  }

  // void googleSign() async {
  //   User? user = await _authService.signInWithGoogle();
  //   if (user != null) {
  //     Get.to(SignUp());
  //   } else {
  //     //  SharedPreferences prefs = await SharedPreferences.getInstance();
  //     //   String? bool = prefs.getString('valid');
  //     //   if (bool == "true") {
  //     //     Get.offAll(UserDashBoard());
  //     //   } else {
  //     //     Get.offAll(Userprofilescreen());
  //     //   }

  //   }
  // }
}
