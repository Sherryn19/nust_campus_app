// features/task_tracker/models/task.dart

enum TaskPriority { low, medium, high, urgent }

enum TaskStatus { todo, inProgress, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final String? assignedTo;
  final List<String> labels;
  final DateTime createdDate;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.assignedTo,
    this.labels = const [],
    required this.createdDate,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    String? assignedTo,
    List<String>? labels,
    DateTime? createdDate,
    bool? isCompleted,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        dueDate: dueDate ?? this.dueDate,
        assignedTo: assignedTo ?? this.assignedTo,
        labels: labels ?? this.labels,
        createdDate: createdDate ?? this.createdDate,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  String get statusLabel {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  String get priorityLabel {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  bool get isOverdue =>
      dueDate != null &&
      dueDate!.isBefore(DateTime.now()) &&
      !isCompleted;
}
