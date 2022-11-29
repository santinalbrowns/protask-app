import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:app/models/models.dart';
import 'package:app/repo/auth_repo.dart';

class TaskRepo extends AuthRepo {
  static const url = "https://protask-api-production.up.railway.app/api/tasks";

  /// static const url = "http://localhost:5000/api/tasks";
  /// requires mongodb to be installed

  Future<Task> create({
    required String name,
    required String project,
    required String user,
    required String due,
  }) async {
    try {
      final token = await restore();

      final response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(
          <String, String>{
            'name': name,
            'project': project,
            'user': user,
            'due': due,
          },
        ),
      );

      Map<String, dynamic> json = jsonDecode(response.body);

      final task = Task.fromJson(json);

      return task;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Task>> getCompleted() async {
    try {
      final token = await restore();

      final response = await http.get(
        Uri.parse('$url?filter=completed'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      final json = jsonDecode(response.body);

      final tasks = json.map<Task>((json) => Task.fromJson(json)).toList();

      return tasks;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Task>> getIncomplete() async {
    try {
      final token = await restore();

      final response = await http.get(
        Uri.parse('$url?filter=incomplete'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      final json = jsonDecode(response.body);

      final tasks = json.map<Task>((json) => Task.fromJson(json)).toList();

      return tasks;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Task>> getAll() async {
    try {
      final token = await restore();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      final json = jsonDecode(response.body);

      final tasks = json.map<Task>((json) => Task.fromJson(json)).toList();

      return tasks;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Task> markCompleted(String id) async {
    try {
      final token = await restore();

      final response = await http.put(
        Uri.parse('$url/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(<String, bool>{'complete': true}),
      );

      final json = jsonDecode(response.body);

      final task = Task.fromJson(json);

      return task;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Task> markIncomplete(String id) async {
    try {
      final token = await restore();

      final response = await http.put(
        Uri.parse('$url/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(<String, bool>{'complete': false}),
      );

      Map<String, dynamic> json = jsonDecode(response.body);

      final task = Task.fromJson(json);

      return task;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Task> update(String id, Map<String, dynamic> body) async {
    try {
      final token = await restore();

      final response = await http.put(
        Uri.parse('$url/$id'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(body),
      );

      Map<String, dynamic> json = jsonDecode(response.body);

      final task = Task.fromJson(json);

      return task;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> delete(String id) async {
    try {
      final token = await restore();

      final response = await http.delete(
        Uri.parse('$url/$id'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        throw response.body;
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
