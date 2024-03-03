class RegisterResponse {
  bool error;
  String message;

  RegisterResponse({
    required this.error,
    required this.message,
  });

  factory RegisterResponse.fromMap(Map<String, dynamic> map) {
    return RegisterResponse(error: map["error"], message: map["message"]);
  }
}
