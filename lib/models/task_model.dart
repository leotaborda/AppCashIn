class TaskModel {
  final String id;
  final String title;
  final bool completed;

  TaskModel({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      completed: map['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}
