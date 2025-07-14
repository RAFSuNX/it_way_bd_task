import 'task_status.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final TaskStatus status;
  final int userId;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.status,
    required this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    // Gracefully handle either JSONPlaceholder or custom backend
    final bool isCompleted =
        json.containsKey('completed') ? (json['completed'] ?? false) : false;
    // Assign a demo status if not completed
    TaskStatus status;
    if (isCompleted) {
      status = TaskStatus.completed;
    } else {
      final id = json['id'] as int? ?? 0;
      // Rotate status for demo (working, pending, due)
      if (id % 3 == 0) {
        status = TaskStatus.working;
      } else if (id % 3 == 1) {
        status = TaskStatus.pending;
      } else {
        status = TaskStatus.due;
      }
    }
    return Task(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? json['title'] ?? '',
      status: status,
      userId: json['userId'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status.toString().split('.').last,
        'userId': userId,
      };

  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskStatus? status,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
}
