
class Login {
  String userId;
  String name;
  String token;

  Login({required this.userId, required this.name, required this.token});

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
        userId: map["userId"], name: map["name"], token: map["token"]);
  }


}

class LoginResponse {
  bool error;
  String message;
  Login loginResult;

  LoginResponse(
      {required this.error, required this.message, required this.loginResult});

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
        error: map["error"],
        message: map["message"],
        loginResult: Login.fromMap(map["loginResult"]));
  }
}
