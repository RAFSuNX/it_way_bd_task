import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/task_status.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<Task> _tasks = [];
  String? _errorMessage;
  bool _isLoading = false;

  List<Task> get tasks => _tasks;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  // Sample tasks for version 3.0 - Enhanced productivity features
  List<Task> get _sampleTasksV3 => [
    Task(
      id: 1001,
      title: 'Welcome to Task Manager v3.0!',
      description: 'Explore the new features and enhanced UI in this major update. Check out improved performance and better task organization.',
      status: TaskStatus.working,
      userId: 1,
    ),
    Task(
      id: 1002,
      title: 'Set up your workspace',
      description: 'Customize your task management environment. Organize your projects and set priorities for maximum productivity.',
      status: TaskStatus.pending,
      userId: 1,
    ),
    Task(
      id: 1003,
      title: 'Plan your weekly goals',
      description: 'Define clear objectives for the week. Break down large projects into manageable tasks and set realistic deadlines.',
      status: TaskStatus.pending,
      userId: 1,
    ),
    Task(
      id: 1004,
      title: 'Review completed projects',
      description: 'Analyze your recent accomplishments and identify areas for improvement. Celebrate your successes!',
      status: TaskStatus.completed,
      userId: 1,
    ),
    Task(
      id: 1005,
      title: 'Optimize your workflow',
      description: 'Implement new productivity techniques and tools. Streamline repetitive tasks and focus on high-impact activities.',
      status: TaskStatus.working,
      userId: 1,
    ),
    Task(
      id: 1006,
      title: 'Learn new skills',
      description: 'Invest time in professional development. Take online courses, read industry articles, or practice new technologies.',
      status: TaskStatus.pending,
      userId: 1,
    ),
  ];

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _taskService.getTasks();
      if (response.success && response.data != null) {
        // Combine API tasks with sample v3.0 tasks for enhanced experience
        _tasks = [..._sampleTasksV3, ...response.data!];
      } else {
        _errorMessage = response.message;
        // Use sample tasks as fallback when API fails
        _tasks = _sampleTasksV3;
      }
    } catch (e) {
      _errorMessage = e.toString();
      // Use sample tasks as fallback when API is unavailable
      _tasks = _sampleTasksV3;
    }
    _isLoading = false;
    notifyListeners();
  }

  List<Task> getFilteredTasks({TaskStatus? status}) {
    if (status == null) return _tasks;
    return _tasks.where((task) => task.status == status).toList();
  }

  Future<void> refreshTasks() async {
    await loadTasks();
  }

  Future<bool> createTask({
    required String title,
    required String description,
    required TaskStatus status,
  }) async {
    try {
      final response = await _taskService.createTask(
        title: title,
        description: description,
      );
      if (response.success && response.data != null) {
        // When creating, set the status as provided (service doesn't use it!)
        final createdTask = response.data!.copyWith(status: status);
        _tasks.insert(0, createdTask); // Insert at the start for visibility
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTaskStatus(Task task, TaskStatus newStatus) async {
    try {
      // Service expects isCompleted ONLY
      final response = await _taskService.updateTaskStatus(
        id: task.id,
        isCompleted: newStatus == TaskStatus.completed,
      );
      if (response.success) {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = task.copyWith(status: newStatus);
          notifyListeners();
        }
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(Task editedTask) async {
    try {
      // Only send status to API (because backend doesn't accept title/desc)
      final response = await _taskService.updateTaskStatus(
        id: editedTask.id,
        isCompleted: editedTask.status == TaskStatus.completed,
      );
      if (response.success) {
        final index = _tasks.indexWhere((t) => t.id == editedTask.id);
        if (index != -1) {
          _tasks[index] = editedTask;
          notifyListeners();
        }
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Shorthand: Mark as completed
  Future<bool> completeTask(Task task) {
    return updateTaskStatus(task, TaskStatus.completed);
  }

  /// Toggle a task between completed and working
  Future<void> toggleTaskStatus(Task task) async {
    final isNowCompleted = task.status != TaskStatus.completed;
    final newStatus =
        isNowCompleted ? TaskStatus.completed : TaskStatus.working;
    await updateTaskStatus(task, newStatus);
  }

  Future<bool> deleteTask(int id) async {
    try {
      final response = await _taskService.deleteTask(id);
      if (response.success) {
        _tasks.removeWhere((task) => task.id == id);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
