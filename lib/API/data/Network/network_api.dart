import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;

import '../../url_cosnt.dart';
import '../AppException.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse("${URLConst.baseURL}${url}"))
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      print("No Internet connection");
      throw InternetException();
    } on TimeoutException {
      print("Request timed out");
      throw RequestTimeOutException();
    } on HttpException {
      print("HTTP exception occurred");
      throw FetchDataException('HTTP exception occurred');
    } on FormatException {
      print("Invalid JSON format");
      throw FetchDataException('Invalid JSON format');
    }
    return responseJson;
  }

  Future<dynamic> postApi(dynamic data, String url) async {
    dynamic responseJson;
    try {
      print("hello");
      final response = await http
          .post(Uri.parse("${URLConst.baseURL}${url}"),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
      print("From Api");
      print(responseJson);
    } on SocketException {
      print("No Internet connection");
      throw InternetException();
    } on TimeoutException {
      print("Request timed out");
      throw RequestTimeOutException();
    } on HttpException {
      print("HTTP exception occurred");
      throw FetchDataException('HTTP exception occurred');
    } on FormatException {
      print("Invalid JSON format");
      throw FetchDataException('Invalid JSON format');
    } on EmailAlreadyExistsException {
      throw EmailAlreadyExistsException("Email Already Extist");
    }
    return responseJson;

//json
  }

  Future<dynamic> postApiWithHeaders(
      dynamic data, String url, Map<String, String>? headers) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse("${URLConst.baseURL}${url}"),
              headers: headers, body: data)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      print("No Internet connection");
      throw InternetException();
    } on TimeoutException {
      print("Request timed out");
      throw RequestTimeOutException();
    } on HttpException {
      print("HTTP exception occurred");
      throw FetchDataException('HTTP exception occurred');
    } on FormatException {
      print("Invalid JSON format");
      throw FetchDataException('Invalid JSON format');
    } on EmailAlreadyExistsException {
      throw EmailAlreadyExistsException("Email Already Extist");
    }
    return responseJson;
  }

  Future<dynamic> postApiWithHeadersData(
      dynamic data, String url, Map<String, String>? headers) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse("${URLConst.baseURL}${url}"),
              headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      print("No Internet connection");
      throw InternetException();
    } on TimeoutException {
      print("Request timed out");
      throw RequestTimeOutException();
    } on HttpException {
      print("HTTP exception occurred");
      throw FetchDataException('HTTP exception occurred');
    } on FormatException {
      print("Invalid JSON format");
      throw FetchDataException('Invalid JSON format');
    } on EmailAlreadyExistsException {
      throw EmailAlreadyExistsException("Email Already Extist");
    }
    return responseJson;
  }

  Future<dynamic> getApiWithHeaders(
      String url, Map<String, String>? headers) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse("${URLConst.baseURL}${url}"), headers: headers)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      print("No Internet connection");
      throw InternetException();
    } on TimeoutException {
      print("Request timed out");
      throw RequestTimeOutException();
    } on HttpException {
      print("HTTP exception occurred");
      throw FetchDataException('HTTP exception occurred');
    } on FormatException {
      print("Invalid JSON format");
      throw FetchDataException('Invalid JSON format');
    } on EmailAlreadyExistsException {
      throw EmailAlreadyExistsException("Email Already Extist");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = response.body;
        return responseJson;
      case 409:
        throw EmailAlreadyExistsException("Email already exists");
      case 400:
      case 401:
      case 403:
      case 422:
        throw InvalidUrlException(response.body);
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server: ${response.statusCode} "  "${response.body}');
    }
  }
}
