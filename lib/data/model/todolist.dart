class TodoList {
  final int? id;
  final String name;

  TodoList({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory TodoList.fromMap(Map<String, dynamic> map) {
    return TodoList(id: map['id'], name: map['name']);
  }
}
