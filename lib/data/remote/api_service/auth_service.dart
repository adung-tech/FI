import 'package:story_app/data/remote/api_response/auth/register/register_request.dart';
import 'package:story_app/data/remote/api_response/auth/register/register_response.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api_response/auth/login/login_request.dart';
import '../api_response/auth/login/login_response.dart';

class AuthService {
  static const String baseUrl = "https://story-api.dicoding.dev/v1";
  

  Future<RegisterResponse> doRegister(RegisterRequest registerRequest) async {
    final response = await http.post(Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: registerRequest.toJson());
  
    if (response.statusCode == 201) {
      print("{$response.statusCode}");
      return RegisterResponse.fromMap(json.decode(response.body));
    } else {
  
      throw Exception("Failed to register");
    }
  }

  Future<LoginResponse> doLogin(LoginRequest loginRequest) async {
    final response = await http.post(Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: loginRequest.toJson());
    if (response.statusCode == 200) {
      return LoginResponse.fromMap(json.decode(response.body));
    } else {
      throw Exception("Failed to login");
    }
  }
}
