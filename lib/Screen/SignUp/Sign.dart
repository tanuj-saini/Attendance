import 'package:animate_do/animate_do.dart';
import 'package:attendence/Utils/Colors.dart';
import 'package:attendence/Screen/LogIn/Logins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:attendence/Components/CustomTextFormField.dart';
import 'package:attendence/Screen/Controller/SignContoller.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignViewModelContoller signController =
        Get.put(SignViewModelContoller());
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allow layout adjustments when keyboard appears
      backgroundColor: AppColors.navy,
      body: SingleChildScrollView(
        // Added to allow scrolling when content overflows
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: height * 0.15), // Adjusted top padding for logo
              Center(
                child: FadeIn(
                  delay: Durations.medium1,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 500,
                        child: SvgPicture.asset(
                          'assets/Logo.svg', // Replace with your asset image
                          width: 250,
                          height: 250,
                        ),
                      ),
                      SizedBox(
                          height: 10), // Added spacing between logo and text
                      Text(
                        'Indian Institute of Information Technology, Vadodara',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.05), // Spacing before form starts
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                decoration: BoxDecoration(
                  color: AppColors.foreground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                height: height *
                    0.55, // Increased height for better scrolling behavior
                child: FadeInUp(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25),
                      Obx(() => CustomTextField(
                            controller: signController.emailController.value,
                            hintText: "Email",
                            iconButton: Icon(Icons.email),
                          )),
                      SizedBox(height: 15),
                      Obx(() => CustomTextField(
                            controller: signController.passwordController.value,
                            hintText: "Password",
                            iconButton: Icon(Icons.password),
                          )),
                      SizedBox(height: 20),
                      //  Text("- - - - - OR - - - - -"),
                      //  Obx(() => ElevatedButton(
                      //       onPressed: () {
                      //         signController.googleSign();

                      //       },
                      //       child: signController.isLodingSign.value == false
                      //           ? Text('Googel Sign IN',
                      //               style: TextStyle(color: Colors.white)):CircularProgressIndicator(),

                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: AppColors.navy,
                      //         padding: EdgeInsets.symmetric(
                      //             horizontal: 100, vertical: 15),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(30),
                      //         ),
                      //       ),
                      //     )),
                      //       SizedBox(height: 10),

                      Obx(() => ElevatedButton(
                            onPressed: () {
                              signController.emailPasswordCreateUser(context);
                            },
                            child: signController.isLodingSign.value == false
                                ? Text('Email/Password User Sign',
                                    style: TextStyle(color: Colors.white))
                                : CircularProgressIndicator(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.navy,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          )),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginUser())); // Navigate to login
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
