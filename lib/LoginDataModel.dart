import 'package:flutter/material.dart';

class LoginResponse {
  LoginResponse({required this.status, required this.message});

  bool status = true;
  String message = "";

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
