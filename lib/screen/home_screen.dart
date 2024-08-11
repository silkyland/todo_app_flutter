import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/config/app.dart';
import 'package:todo_app/model/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TodoModel> _todos = [];
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void createTodo() async {
    try {
      if (_formKey.currentState!.validate()) {
        final pref = await SharedPreferences.getInstance();
        final token = pref.getString('token');
        if (token == null) {
          throw Exception('Token not found');
        }
        final response = await http.post(
          Uri.parse('$API_URL/todos'),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
          body: jsonEncode({
            'title': _title.text,
            'description': _description.text,
          }),
        );

        if (response.statusCode == 201) {
          final String todoId = response.body;
          // Navigator.pushReplacementNamed(context, '/todo/$todoId');
          fetchTodos();
        } else {
          throw Exception('Failed to create todo');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create todo: ${e.toString()}'),
      ));
    }
  }

  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void fetchTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$API_URL/todos'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> todos = jsonDecode(response.body);
        setState(() {
          _todos.clear();
          _todos.addAll(todos.map((todo) => TodoModel.fromJson(todo)));
        });

        print(todos);
      } else {
        throw Exception('Failed to fetch todos');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch todos: ${e.toString()}'),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            ElevatedButton(
              onPressed: createTodo,
              child: const Text('Submit'),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_todos[index].title),
                  subtitle: Text(_todos[index].description),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
