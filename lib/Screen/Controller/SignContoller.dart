import 'package:attendence/Model/UserDto.dart';
import 'package:attendence/Repositry/UserRepositry.dart';
import 'package:attendence/Screen/UserDashBord/UserDashBoard.dart';
import 'package:attendence/Screen/Controller/UserProfileController.dart';
import 'package:attendence/Screen/UserProfile/UserProfileScreen.dart';
import 'package:attendence/Services/AuthService.dart';
import 'package:attendence/Screen/SplashScreen/splashScreen.dart';
import 'package:attendence/Screen/SplashScreen/EmailVerification.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignViewModelContoller extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  //   final emailControllerSign = TextEditingController().obs;
  // final passwordControllerSign = TextEditingController().obs;
  RxBool isLodingLogin = false.obs;
  RxBool isLodingSign = false.obs;
  final _api = LoginRepositry();
  RxBool isLodingGoogle = false.obs;
  RxBool isLodingPhone = false.obs;
  void changeLodingState(bool value, RxBool booleans) {
    booleans.value = value;
  }

  @override
  void onClose() {
    // Dispose of the controllers when the controller is removed
    emailController.value.dispose();
    passwordController.value.dispose();
    // emailControllerSign.value.dispose();
    // passwordControllerSign.value.dispose()
    super.onClose();
  }
  //  @override
  // void onClose() {
  //   // Dispose of the controllers when the controller is removed
  //   emailController.value.dispose();
  //   passwordController.value.dispose();
  //   super.onClose();
  // }

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

  // void emailPasswordLoginUser() async {
  //   String _email = emailController.value.text;
  //   String _password = passwordController.value.text;
  //   try {
  //     changeLodingState(true, isLodingLogin);
  //     UserCredential _credential = await _auth.signInWithEmailAndPassword(
  //         email: _email, password: _password);
  //     var _user = _credential.user;

  //     UserModelDto isTrue = await userRepo.sendDataSignIN(_email, _password);

  //     if (_user != null && isTrue.name != null) {
  //       Get.snackbar("User Successfully Logged In", "Welcome!");
  //       // SharedPreferences prefs = await SharedPreferences.getInstance();
  //       // String? bool = prefs.getString('valid');

  //       Get.offAll(UserDashBoard());
  //     } else {
  //       Get.offAll(Userprofilescreen());
  //       changeLodingState(false, isLodingLogin);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     debugPrint('********************ERROR2****************');
  //     Get.snackbar("User Failed", "${e.toString()}");
  //     debugPrint(e.toString());
  //     changeLodingState(false, isLodingLogin);
  //   }
  // }

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
        .sendPasswordResetEmail(email: emailController.value.text)
        .then(
      (value) {
        // print(value!.toString());
      },
    );
    Get.snackbar("Reset Password", "Email Send Successfull");
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

  void googleSignOut() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      SharedPreferences getPref = await SharedPreferences.getInstance();
      // Check if the user is currently signed in
      if (await _googleSignIn.isSignedIn()) {
        // Attempt to sign out
        await _googleSignIn.signOut();
        getPref.setString("isGoogle", "");
        Get.snackbar("Logged Out", "You have successfully logged out.");
        Get.offAll(() => SplashScreen());
        print("User signed out from Google.");
      } else {
        // User is not signed in
        Get.snackbar(
            "Not Signed In", "No Google account is currently signed in.");
        print("No Google account is signed in.");
      }
    } catch (e) {
      // Handle any errors during sign out
      debugPrint('********************ERROR1********************');
      Get.snackbar("Sign-Out Failed", e.toString());
      print("Error signing out: $e");
    }
  }
}
