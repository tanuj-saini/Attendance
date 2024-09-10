import 'dart:io';

import 'package:attendence/Utils/Colors.dart';
import 'package:attendence/Services/FilePicker.dart';
import 'package:attendence/Screen/Controller/UserProfileController.dart';
import 'package:attendence/Screen/Controller/SignContoller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Userprofilescreen extends StatefulWidget {
  Userprofilescreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _UserProfileScreen();
  }
}

class _UserProfileScreen extends State<Userprofilescreen> {
  final Userprofilecontroller userRepos = Get.put((Userprofilecontroller()));
  final SignViewModelContoller SignController =
      Get.put(SignViewModelContoller());
  File? image;
  final _formKey = GlobalKey<FormState>();
  void selectImage() async {
    var res = await pickImage();

    setState(() {
      image = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Usser Profile"),
        // actions: [

        //   // IconButton(
        //   //     onPressed: () {
        //   //       SignController.googleSignOut();
        //   //     },
        //   //     icon: Icon(Icons.logout))
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image == null
                    ? GestureDetector(
                        onTap: selectImage,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(80),
                              border: Border.all(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Icon(Icons.camera_alt_rounded,
                                  color: AppColors.navy),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImage,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: FileImage(image!),
                        ),
                      ),
                Obx(
                  () => TextFormField(
                    controller: userRepos.nameController.value,
                    decoration: InputDecoration(hintText: "Name:"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                Obx(() => TextFormField(
                      controller: userRepos.rollIdController.value,
                      decoration: InputDecoration(hintText: "Roll Number:"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your roll number';
                        } else if (value.length != 9 ||
                            !RegExp(r'^\d{9}$').hasMatch(value)) {
                          return 'Roll number must be 9 digits';
                        }
                        return null;
                      },
                    )),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    child: ElevatedButton(
                        onPressed: () {
                          if (image == null) {
                            Get.snackbar(
                                "No Photo Found", "Please Select a Photo");
                          }
                          if (_formKey.currentState!.validate()) {
                            userRepos.sendData(
                                SignController.emailController.value.text,
                                SignController.passwordController.value.text,
                                image!);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy, // Button color
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Obx(() => userRepos.isLoading.value == false
                            ? const Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              )
                            : const CircularProgressIndicator())),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
