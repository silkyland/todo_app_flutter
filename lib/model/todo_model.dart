import 'package:todo_app/model/user_model.dart';

class TodoModel {
  final String title;
  final String description;
  final String id;
  final String userId;
  final bool completed;
  final UserModel? user;
  TodoModel({
    required this.title,
    required this.description,
    required this.id,
    required this.completed,
    required this.userId,
    this.user,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      title: json['title'],
      description: json['description'],
      id: json['_id'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }
}
