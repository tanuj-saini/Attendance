import 'package:attendence/Components/CustomTextFormField.dart';
import 'package:attendence/Screen/Controller/LoginController.dart';
import 'package:attendence/Screen/SignUp/Sign.dart';
import 'package:attendence/Screen/Controller/SignContoller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:attendence/Utils/Colors.dart';

class LoginUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    // final SignViewModelContoller signController =
    //     Get.find<SignViewModelContoller>();
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true, // Changed to true
      backgroundColor: AppColors.navy,
      body: SingleChildScrollView(
        // Wrapped with SingleChildScrollView
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: height * 0.15),
              Center(
                child: FadeIn(
                  delay: Durations.medium1,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 500,
                        child: SvgPicture.asset(
                          'assets/Logo.svg',
                          width: 250,
                          height: 250,
                        ),
                      ),
                      SizedBox(height: 10),
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
              SizedBox(height: height * 0.05),
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
                child: FadeInUp(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25),
                      Obx(() => CustomTextField(
                          controller:
                              loginController.emailControllerLogin.value,
                          hintText: "Email",
                          iconButton: const Icon(Icons.email))),
                      SizedBox(height: 15),
                      Obx(() => CustomTextField(
                          controller:
                              loginController.passwordControllerLogin.value,
                          hintText: "Password",
                          iconButton: const Icon(Icons.password))),
                      SizedBox(height: 20),
                      Obx(() => ElevatedButton(
                            onPressed: () {
                              if (!loginController.isLodingGoogle.value &&
                                  !loginController.isLodingPhone.value) {
                                loginController.emailPasswordLoginUser();
                              }
                            },
                            child: loginController.isLodingLogin.value == false
                                ? Text('Login',
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
                      SizedBox(height: 10),
                      // TextButton(
                      //   onPressed: () {
                      //     signController.forgetPassword();
                      //   },
                      //   child: Text(
                      //     "Forget Password",
                      //     style: TextStyle(
                      //       color: AppColors.navy,
                      //     ),
                      //     textAlign: TextAlign.end,
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      Text("- - - - - OR - - - - -"),
                      Obx(() => ElevatedButton(
                            onPressed: () {
                              loginController.googleSignIn();
                            },
                            child: loginController.isLodingSign.value == false
                                ? Text('Google Sign In',
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
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              'Sign Up',
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
