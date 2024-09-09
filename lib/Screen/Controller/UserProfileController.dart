import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:attendence/API/data/AppException.dart';
import 'package:attendence/API/url_cosnt.dart';
import 'package:attendence/Model/UserDto.dart';
import 'package:attendence/Model/UserModel.dart';
import 'package:attendence/Model/UserSendData.dart';
import 'package:attendence/Screen/UserDashBord/UserDashBoard.dart';
import 'package:attendence/Screen/UserProfile/UserProfileScreen.dart';
import 'package:attendence/Repositry/UserRepositry.dart';
import 'package:attendence/Screen/LogIn/Logins.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Userprofilecontroller extends GetxController {
  final nameController = TextEditingController().obs;
  final rollIdController = TextEditingController().obs;
  final classNumberController = TextEditingController().obs;
  final userModelU = UserModelDto().obs;
  final _api = LoginRepositry();
  RxBool isLoading = false.obs;
  RxBool isLoadingData = false.obs;
  RxString error = "".obs;
  RxString photoUrl = "".obs;
  void setIsLoading(RxBool isLoadings) {
    isLoading.value = isLoadings.value;
  }

  void setIsLoadingData(RxBool isLoadingsDatas) {
    isLoadingData.value = isLoadingsDatas.value;
  }

  void setError(String errorS) {
    error.value = errorS;
  }

  void setUserModelDto(UserModelDto userModel) {
    userModelU.value = userModel;
  }

  void sendData(String email, String password, File image) async {
    setIsLoading(true.obs);
    String photoUrlCLo = '';
    final cloudinary = CloudinaryPublic("dix3jqg7w", 'aqox8ip4');
    CloudinaryResponse response = await cloudinary
        .uploadFile(CloudinaryFile.fromFile(image.path, folder: email));
    photoUrlCLo = response.secureUrl;
    UserModel userModel = UserModel(
        name: nameController.value.text,
        emailAddress: email,
        rollNumber: rollIdController.value.text,
        password: password,
        imageUrl: photoUrlCLo);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _api.loginApi(userModel.toJson(), "/user/profile").then((value) {
      isLoading.value = false;
      setUserModelDto(value);
      print(value);
      prefs.setString("valid", "true");

      Get.snackbar("SuccessFully Login", "Welcome ");
      setIsLoading(false.obs);

      Get.to(UserDashBoard());
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      print("Error: $error");
      print("StackTrace: $stackTrace");
      setError(error.toString());

      isLoading.value = false;
    });
  }

  void checkUserToken() async {
    setIsLoading(true.obs);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');

    if (token == null) {
      prefs.setString('jwtToken', '');
    }

    _api.sendJwtVerify(
      "/tokenIsValid",
      <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token-w': token!,
      },
    ).then((value) {
      isLoading.value = false;
      print("yesTrue");
      if (value) {
        _api.getUserData(
          "/",
          <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token-w': token,
          },
        ).then((value) {
          print(value);
          setUserModelDto(value);
          Get.snackbar("Welcome", "Again ");
          setIsLoading(false.obs);
          String? token = prefs.getString('valid');
          if (token == "true") {
            Get.to(UserDashBoard());
          } else {
            Get.to(Userprofilescreen());
          }
        });
        isLoading.value = false;
      } else {
        Get.snackbar("No Auth Token Valid", "Validation Failed");
        Get.to(LoginUser());
        setIsLoading(false.obs);
      }
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      print("Error: $error");
      print("StackTrace: $stackTrace");
      setError(error.toString());

      isLoading.value = false;
    });
  }

  Future<UserModelDto> sendDataSignIN(String email, String password) async {
    setIsLoading(true.obs);

    try {
      final value = await _api.getUserDataSignIn(
          {"emailAddress": email, "password": password}, "/api/signin");

      isLoading.value = false;
      setUserModelDto(value);
      print(value);

      // Get.snackbar("SuccessFully Login", "Welcome ");
      setIsLoading(false.obs);
      return userModelU.value; // Success case
    } catch (error, stackTrace) {
      Get.snackbar("Error", error.toString());
      print("Error: $error");
      print("StackTrace: $stackTrace");
      setError(error.toString());
      isLoading.value = false;
      return userModelU.value; // Error case
    }
  }

  Future<bool> sendDataSignup(String email, String password) async {
    setIsLoading(true.obs);

    try {
      await _api.getUserDataSignup(
          {"emailAddress": email, "password": password}, "/user/signup");

      isLoading.value = false;

      // Get.snackbar("SuccessFully Login", "Welcome ");
      setIsLoading(false.obs);
      return true; // Success case
    } catch (error, stackTrace) {
      Get.snackbar("Error", error.toString());
      print("Error: $error");
      print("StackTrace: $stackTrace");
      setError(error.toString());
      isLoading.value = false;
      return false; // Error case
    }
  }

  void sendUserData(UserModelSendData userModelData) async {
    setIsLoadingData(true.obs);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');

    if (token == null) {
      prefs.setString('jwtToken', '');
    }
    print("send data");
    _api.sendData(
      userModelData.toJson(),
      "/sendData",
      <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token-w': token!,
      },
    ).then((value) {
      isLoadingData.value = false;

      Get.snackbar("Attendence Mark", "😀😀");
      setIsLoading(false.obs);
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      print("Error: $error");
      print("StackTrace: $stackTrace");
      setError(error.toString());

      isLoading.value = false;
    });
  }

  Future<void> sendUserDataBytes(UserModelSendData userData) async {
    try {
      setIsLoadingData(true.obs);

      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwtToken');

      if (token == null || token.isEmpty) {
        print("No token found, please log in again.");
        return;
      }

      // Create the request
      var url = Uri.parse("${URLConst.baseURL}/sendData");
      var request = http.MultipartRequest('POST', url);

      // Add headers (Authorization)
      request.headers['x-auth-token-w'] = '$token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Convert the rest of the user model to JSON and send as part of the request
      Map<String, dynamic> userJson = userData.toJson();
      userJson.remove('imageUrl'); // Exclude imageUrl from fields
      userJson.remove('audioUrl'); // Exclude audioUrl from fields

      // Handle location and wifiNetworks as JSON formatted strings
      if (userData.location != null) {
        // Convert location to a JSON string
        request.fields['location'] =
            "{ \"latitude\": ${userData.location!.latitude}, \"longitude\": ${userData.location!.longitude} }";
      }

      if (userData.wifiNetworks != null) {
        // Convert wifiNetworks list to a JSON string
        request.fields['wifiNetworks'] = jsonEncode(userData.wifiNetworks!
                .map((v) => {"ssid": v.ssid, "strength": v.strength})
                .toList())
            .toString();
      }

      // Add other fields except for location and wifiNetworks
      userJson.forEach((key, value) {
        if (key != 'location' && key != 'wifiNetworks') {
          request.fields[key] = value?.toString() ?? '';
        }
      });

      // Add image file if available
      if (userData.imageUrl != null) {
        final mimeTypeData =
            lookupMimeType('', headerBytes: userData.imageUrl!)!.split('/');
        request.files.add(http.MultipartFile.fromBytes(
          'imageUrl',
          userData.imageUrl!,
          filename: 'image.jpg',
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }

      // Add audio file if available
      if (userData.audioUrl != null) {
        final mimeTypeData =
            lookupMimeType('', headerBytes: userData.audioUrl!)!.split('/');
        request.files.add(http.MultipartFile.fromBytes(
          'audioUrl',
          userData.audioUrl!,
          filename: 'audio.mp3',
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }

      // Send the request
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      setIsLoadingData(false.obs);
      Get.snackbar("Attendence Mark", "Success");
      return;
    } on SocketException {
      setIsLoadingData(false.obs);
      print("No Internet connection");
    } on TimeoutException {
      setIsLoadingData(false.obs);
      print("Request timed out");
    } on HttpException {
      setIsLoadingData(false.obs);
      print("HTTP exception occurred");
    } on FormatException {
      setIsLoadingData(false.obs);
      print("Invalid JSON format");
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return;
      case 400:
      case 401:
      case 403:
      case 422:
        throw Exception(response.body);
      case 500:
      default:
        setIsLoading(false.obs);
        throw Exception('Error occurred while communicating with server');
    }
  }
}
