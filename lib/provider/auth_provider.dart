import 'package:flutter/material.dart';
import 'package:story_app/data/remote/api_response/auth/auth_repository.dart';
import 'package:story_app/data/remote/api_response/auth/login/login_request.dart';
import '../data/remote/api_response/auth/register/register_request.dart';
import '../data/remote/api_service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final AuthService authService;

  AuthProvider({required this.authRepository, required this.authService});

  bool isLoadingLogin = false;

  bool isLoadingLogout = false;

  bool isLoadingRegister = false;

  bool isLoggedIn = false;

  bool isSuccessRegister = false;

  bool visibilityPassword = false;

  Future<bool> doLogin(String email, String password) async {
     isLoadingLogin = true;
     notifyListeners();
      try {
        final loginResult = await authService.doLogin(
            LoginRequest(email: email, password: password));

        if (loginResult.loginResult.token.isNotEmpty) {
          isLoadingLogin = false;
          notifyListeners();
          await authRepository.setLogin();
          await authRepository.setToken(loginResult.loginResult.token);
          isLoggedIn = true;
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } catch (error) {
        isLoadingLogin = false;
        notifyListeners();
        print("Error during login: $error");
        return false;
      }
  }



  Future<bool> doRegister(String name, String email, String password) async {
    isLoadingRegister = true;
    notifyListeners();

    authService
        .doRegister(
            RegisterRequest(name: name, email: email, password: password))
        .then((value) {
      if (!value.error) {
       
        isSuccessRegister = true;
        notifyListeners();
      
      } else {
        isSuccessRegister = false;
        notifyListeners();
        
      }
    }).catchError((onError) {
      isSuccessRegister = false;
      notifyListeners();
    });

    isLoadingRegister = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 6000));

    return isSuccessRegister;
  }

  bool setVisibility() {
    visibilityPassword = !visibilityPassword;
    notifyListeners();
    return visibilityPassword;
  }
}
