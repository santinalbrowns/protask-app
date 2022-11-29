import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:app/models/user.dart';

class AuthRepo {
  static const url =
      "https://protask-api-production.up.railway.app/api/users/login";

  /// static const url = "http://localhost:5000/api/users/login";
  /// requires mongodb to be installed

  final _storage = const FlutterSecureStorage();

  //Token from local storage
  Future<String> restore() async {
    final token = await _storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw 'Auth token not found.';
    }

    return token;
  }

  Future<User> login(String email, String passowrd) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode(
          <String, String>{
            'email': email,
            'password': passowrd,
          },
        ),
      );

      if (response.statusCode == 400) {
        throw 'Your email or password is incorrect';
      }

      final json = jsonDecode(response.body);

      final user = User.fromJson(json);

      await _storage.write(key: 'token', value: user.token);

      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
