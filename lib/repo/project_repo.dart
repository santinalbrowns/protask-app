import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:app/models/models.dart';
import 'package:app/repo/auth_repo.dart';

class ProjectRepo extends AuthRepo {
  //static const url =  "https://protask-api-production.up.railway.app/api/projects";
  static const url = "http://localhost:5000/api/projects";

  Future<Project> create(
      {required String name,
      required String description,
      required String due}) async {
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
            'description': description,
            'due': due,
          },
        ),
      );

      Map<String, dynamic> json = jsonDecode(response.body);

      final project = Project.fromJson(json);

      return project;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Project> getOne(String id) async {
    try {
      final token = await restore();
      final response = await http.get(Uri.parse("$url/$id"), headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      Map<String, dynamic> json = jsonDecode(response.body);

      final project = Project.fromJson(json);

      return project;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Project>> getAll() async {
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

      List<Project> projects =
          json.map<Project>((json) => Project.fromJson(json)).toList();

      projects.sort((a, b) => a.due.compareTo(b.due));

      return projects;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Task>> getTasks(String id) async {
    try {
      final token = await restore();
      final response = await http.get(Uri.parse("$url/$id/tasks"), headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      final json = jsonDecode(response.body);

      List<Task> tasks = json.map<Task>((json) => Task.fromJson(json)).toList();

      return tasks;
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
        throw 'Something went wrong deleting the project';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Project> update(String id, Map<String, dynamic> body) async {
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

      final project = Project.fromJson(json);

      return project;
    } catch (e) {
      throw e.toString();
    }
  }
}
