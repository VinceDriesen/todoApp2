import './task_priority.dart';

class Task {
  final int? id;
  final String title;
  final String description;
  final bool isDone;
  final int listId; // foreign key
  final TaskPriority priority;

  Task({
    this.id,
    required this.title,
    this.description = '',
    this.isDone = false,
    required this.listId,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
      'listId': listId,
      'description': description,
      'priority': priority.index, // <-- serialize as int
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
      listId: map['listId'],
      description: map['description'] ?? '',
      priority:
          TaskPriority.values[map['priority']], // <-- deserialize from int
    );
  }

  Task copyWith({
    int? id,
    String? title,
    bool? isDone,
    int? listId,
    String? description,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      listId: listId ?? this.listId,
      description: description ?? this.description,
      priority: priority ?? this.priority,
    );
  }
}
