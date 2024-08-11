import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/config/app.dart';
import 'package:todo_app/model/todo_model.dart';

class DetailScreen extends StatefulWidget {
  String id;
  DetailScreen({super.key, required this.id});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TodoModel _todo = TodoModel(title: '', description: '', id: '', completed: false, userId: '');
  void fetchTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$API_URL/todos/${widget.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> todo = jsonDecode(response.body);
        setState(() {
          _todo = TodoModel.fromJson(todo);
        });
      } else {
        throw Exception('Failed to fetch todo');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch todo: ${e.toString()}'),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ID: ${_todo.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Title: ${_todo.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${_todo.description}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              children: <Widget>[
                Text(
                  'Complete: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // Checkbox(
                //   value: _todo.complete,
                //   onChanged: (value) {
                //     setState(() {
                //       _todo.complete = value;
                //     });
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
