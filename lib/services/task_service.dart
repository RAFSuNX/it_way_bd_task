import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management_system/models/task.dart';

import '../utils/api/api_response.dart';


class TaskService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  TaskService({http.Client? client}) : _client = client ?? http.Client();

  // API endpoints
  static const String _tasksEndpoint = '/todos';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'User-Agent':
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
  };

  // Helper method for handling API responses
  Future<ApiResponse<T>> _handleResponse<T>({
    required Future<http.Response> Function() apiCall,
    required T Function(dynamic json) onSuccess,
    String successMessage = 'Success',
  }) async {
    try {
      final response = await apiCall();
      final statusCode = response.statusCode;
      print('API status: ' + statusCode.toString());
      print('API body: ' + response.body.toString());
      if (statusCode >= 200 && statusCode < 300) {
        final jsonData = json.decode(response.body);
        final data = onSuccess(jsonData);
        return ApiResponse.success(
          data: data,
          message: successMessage,
          statusCode: statusCode,
        );
      } else {
        print('Server error: ${response.statusCode} ${response.body}');
        return ApiResponse.error(
          message: 'Server error: ${response.statusCode}\n${response.body}',
          statusCode: statusCode,
        );
      }
    } on http.ClientException catch (e) {
      print('Network connection error: $e');
      return ApiResponse.error(message: 'Network connection error: $e');
    } catch (e) {
      print('Unknown error: $e');
      return ApiResponse.error(message: 'Error: $e');
    }
  }

  // Get all tasks
  Future<ApiResponse<List<Task>>> getTasks() async {
    return _handleResponse<List<Task>>(
      apiCall: () =>
          _client.get(Uri.parse('$_baseUrl$_tasksEndpoint'), headers: _headers),
      onSuccess: (dynamic json) {
        if (json is! List) throw Exception('Invalid response format');
        return json
            .map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>))
            .toList();
      },
      successMessage: 'Tasks fetched successfully',
    );
  }

  Future<ApiResponse<Task>> createTask({
    required String title,
    required String description,
  }) async {
    final body = json.encode({
      'title': title,
      'body': description, // JSONPlaceholder uses 'body'
      'completed': false,
      'userId': 1, // Default userId for JSONPlaceholder
    });

    return _handleResponse<Task>(
      apiCall: () => _client.post(
        Uri.parse('$_baseUrl$_tasksEndpoint'),
        headers: _headers,
        body: body,
      ),
      onSuccess: (json) => Task.fromJson(json),
      successMessage: 'Task created successfully',
    );
  }


  // Update task status
  Future<ApiResponse<bool>> updateTaskStatus({
    required int id,
    required bool isCompleted,
  }) async {
    final body = json.encode({'completed': isCompleted});

    return _handleResponse<bool>(
      apiCall: () => _client.patch(
        Uri.parse('$_baseUrl$_tasksEndpoint/$id'),
        headers: _headers,
        body: body,
      ),
      onSuccess: (json) => true,
      successMessage: 'Task status updated successfully',
    );
  }

  // Delete task
  Future<ApiResponse<bool>> deleteTask(int id) async {
    return _handleResponse<bool>(
      apiCall: () => _client.delete(
        Uri.parse('$_baseUrl$_tasksEndpoint/$id'),
      ),
      onSuccess: (json) => true,
      successMessage: 'Task deleted successfully',
    );
  }

  // Cleanup
  void dispose() {
    _client.close();
  }
}