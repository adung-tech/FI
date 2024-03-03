import 'dart:convert';

class RegisterRequest {
  String name;
  String email;
  String password;

  RegisterRequest({required this.name,required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {"name":name,"email": email, "password": password};
  }

  String toJson() => json.encode(toMap());
}
