import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:app/models/user.dart';
import 'package:app/repo/auth_repo.dart';

class UserRepo extends AuthRepo {
  static const url = "https://protask-api-production.up.railway.app/api/users";

  /// static const url = "http://localhost:5000/api/users";
  /// requires mongodb to be installed

  Future<User> getUser() async {
    try {
      final token = await restore();
      final response = await get(Uri.parse('$url/me'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

      Map<String, dynamic> json = jsonDecode(response.body);

      final user = User.fromJson(json);

      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteCurrentUser() async {
    try {
      final token = await restore();
      final response = await get(Uri.parse('$url/me'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

      Map<String, dynamic> json = jsonDecode(response.body);

      final user = User.fromJson(json);

      final res = await delete(Uri.parse("$url/${user.id}"),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

      if (res.statusCode != 200) {
        final json = jsonDecode(res.body);

        throw json['message'];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<User> addUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    try {
      final response = await post(
        Uri.parse(url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode(
          <String, String>{
            'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password,
          },
        ),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final user = User.fromJson(json);

        return user;
      }

      throw json['message'];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<User> update({
    required String id,
    String? firstname,
    String? lastname,
    String? email,
    String? password,
  }) async {
    try {
      final token = await restore();
      final response = await put(
        Uri.parse("$url/$id"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(
          <String, String?>{
            'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password,
          },
        ),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = User.fromJson(json);

        return user;
      }

      throw json['message'];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final token = await restore();

      final response = await get(Uri.parse(url),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

      final json = jsonDecode(response.body);

      final users = json.map<User>((user) => User.fromJson(user)).toList();

      return users;
    } catch (e) {
      throw Exception(e);
    }
  }
}
