import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  static const API_KEY = 'AIzaSyCop4wWo-Pg6ZkDQ9gs_2fP1-YQx0Oj3vs';

  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(String email, String password, bool signUp) async {
    final url = signUp
        ? 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY'
        : 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$API_KEY';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      // errors
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, true);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, false);
  }
}
