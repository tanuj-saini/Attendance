import 'package:attendence/Screen/UserDashBord/UserDashBoard.dart';
import 'package:attendence/Screen/LogIn/Verification/CheckingUserJwt.dart';
import 'package:attendence/Screen/SplashScreen/splashScreen.dart';
import 'package:attendence/Screen/SignUp/Sign.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? typeOfUser = prefs.getString('jwtToken');
  if (typeOfUser == null) {
    prefs.setString('jwtToken', "");
  }
  runApp(MyApp(
    typeOfUser: typeOfUser,
  ));
}

class MyApp extends StatelessWidget {
  final String? typeOfUser;
  const MyApp({super.key, required this.typeOfUser});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendence',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: Userprofilescreen()
        home: typeOfUser == null
            ? SplashScreen()
            : Checkinguserjwt(jwtToken: typeOfUser!));
  }
}
// class AuthWrapper extends StatelessWidget {
//   final String? typeOfUser;
//   AuthWrapper({required this .typeOfUser});
//   @override
//   Widget build(BuildContext context) {

//     User? user = FirebaseAuth.instance.currentUser;

   
//     if (user != null) {
//       return UserDashBoard(); 
//     } else {
      
//     }
//   }
// }
