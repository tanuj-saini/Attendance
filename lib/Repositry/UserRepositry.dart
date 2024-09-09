import 'dart:convert';

import 'package:attendence/API/data/Network/network_api.dart';
import 'package:attendence/Model/UserDto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepositry {
  final _appService = NetworkApiServices();

  Future<UserModelDto> loginApi(dynamic data, String url) async {
    // Get the response from the API
    dynamic response = await _appService.postApi(data, url);

    // Decode the response to a map
    Map<String, dynamic> decodedResponse = jsonDecode(response);

    print("From repositry");
    print(decodedResponse);

    // Access 'user' and 'token' directly from the decoded map
    Map<String, dynamic> user = decodedResponse['user'];
    String token = decodedResponse['token'];

    print(user);
    print(token);

    // Save the token to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);

    // Retrieve the token to verify it was saved correctly
    String? jwt = await prefs.getString('jwtToken');
    print("jwt token");
    print(jwt);

    // Return UserModelDto from the 'user' part of the response
    return UserModelDto.fromJson(user);
  }

  Future<void> sendData(
      dynamic data, String url, Map<String, String> headers) async {
    // Get the response from the API
    await _appService.postApiWithHeadersData(data, url, headers);
  }

  Future sendJwtVerify(String url, Map<String, String> headers) async {
    // Get the response from the API
    var response = await _appService.postApiWithHeaders("", url, headers);
    print(response);

    return jsonDecode(response);
  }

  Future<UserModelDto> getUserData(
      String url, Map<String, String> headers) async {
    // Get the response from the API
    dynamic response = await _appService.getApiWithHeaders(url, headers);

    // Decode the response to a map
    Map<String, dynamic> decodedResponse = jsonDecode(response);

    print("From repositry");
    print(decodedResponse);

    // Access 'user' and 'token' directly from the decoded map
    Map<String, dynamic> user = decodedResponse['user'];
    String token = decodedResponse['token'];

    print(user);
    print(token);

    // Save the token to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);

    // Retrieve the token to verify it was saved correctly
    String? jwt = await prefs.getString('jwtToken');
    print("jwt token");
    print(jwt);

    // Return UserModelDto from the 'user' part of the response
    return UserModelDto.fromJson(user);
  }

  Future<UserModelDto> getUserDataSignIn(dynamic data, String url) async {
    // Get the response from the API
    dynamic response = await _appService.postApi(data, url);

    // Decode the response to a map
    Map<String, dynamic> decodedResponse = jsonDecode(response);

    print("From repositry");
    print(decodedResponse);

    // Access 'user' and 'token' directly from the decoded map
    Map<String, dynamic> user = decodedResponse['user'];
    String token = decodedResponse['token'];

    print(user);
    print(token);

    // Save the token to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);

    // Retrieve the token to verify it was saved correctly
    String? jwt = await prefs.getString('jwtToken');
    print("jwt token");
    print(jwt);

    // Return UserModelDto from the 'user' part of the response
    return UserModelDto.fromJson(user);
  }

  Future<void> getUserDataSignup(dynamic data, String url) async {
    // Get the response from the API
    dynamic response = await _appService.postApi(data, url);

    // Decode the response to a map
    Map<String, dynamic> decodedResponse = jsonDecode(response);

    print("From repositry");

    String token = decodedResponse['token'];

    print(token);

    // Save the token to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);

    // Retrieve the token to verify it was saved correctly
    String? jwt = await prefs.getString('jwtToken');
    print("jwt token");
    print(jwt);

    // Return UserModelDto from the 'user' part of the response
  }
}
