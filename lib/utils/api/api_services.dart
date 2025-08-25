
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/task.dart';
import '../../models/task_status.dart';
import '../../config/environment.dart';

class ApiService {
  static String get baseUrl => Environment.baseUrl;
  static String get apiKey => Environment.apiKey;

  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception(_friendlyExceptionMessage(response));
      }
    } catch (e) {
      throw Exception(_friendlyExceptionMessage(e));
    }
  }



  Future<Task> createTask({
    required String title,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/todos'),
        body: json.encode({
          'title': title,
          'body': description,
          'completed': false,
          'userId': 1, // Default userId
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception(_friendlyExceptionMessage(response));
      }
    } catch (e) {
      throw Exception(_friendlyExceptionMessage(e));
    }
  }

  Future<bool> updateTaskStatus(int id, bool isCompleted) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/todos/$id'),
        body: json.encode({'completed': isCompleted}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(_friendlyExceptionMessage(response));
      }
    } catch (e) {
      throw Exception(_friendlyExceptionMessage(e));
    }
  }

  Future<Task> editTask(Task task) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/todos/${task.id}'),
        body: json.encode({
          'title': task.title,
          'body': task.description,
          'completed': task.status.toString().toLowerCase().contains(
              'completed'),
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception(_friendlyExceptionMessage(response));
      }
    } catch (e) {
      throw Exception(_friendlyExceptionMessage(e));
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/todos/$id'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception(_friendlyExceptionMessage(response));
      }
    } catch (e) {
      throw Exception(_friendlyExceptionMessage(e));
    }
  }

  String _friendlyExceptionMessage(dynamic e) {
    if (e is http.Response) {
      final contentType = e.headers['content-type'] ?? '';
      if (contentType.contains('text/html') ||
          e.body.contains('<!DOCTYPE html>')) {
        return 'Server error: Unable to reach API (possible network or permission issue, status ${e
            .statusCode})';
      } else {
        // If there's a JSON error message field, try to show it!
        try {
          final decoded = json.decode(e.body);
          if (decoded is Map && decoded['message'] != null) {
            return 'API error: ${decoded['message']}';
          }
        } catch (_) {}
      }
      // Fallback with status
      return 'Server error (status ${e.statusCode})';
    }
    // fallback, short string
    final str = e.toString();
    if (str.contains('<!DOCTYPE html>')) {
      return 'Server error: Unable to reach API (possible network or permission issue)';
    }
    return str
        .split('\n')
        .first;
  }
}
