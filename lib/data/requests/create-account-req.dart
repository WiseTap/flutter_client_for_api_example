


import 'package:flutter_client_for_api_example/data/custom-claims.dart';

class CreateAccountReqBody {
  final String name;
  final String email;
  final String password;
  final CustomClaims role;

  CreateAccountReqBody ({
    required this.name,
    required this.email,
    required this.password,
    required this.role
  });

  Map<String,dynamic> toMap () => {
    'name': name,
    'email': email,
    'password': password,
    'role': role.toString().split('.').last,
  };

}