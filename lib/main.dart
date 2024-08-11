import 'package:flutter/material.dart';
import 'package:toasted/toasted.dart';
import 'package:todo_app/screen/detail_screen.dart';
import 'package:todo_app/screen/home_screen.dart';
import 'package:todo_app/screen/login_screen.dart';
import 'package:todo_app/screen/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastedProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              );
            case '/register':
              return MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              );
            case '/home':
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
            case '/todo':
              final args = settings.arguments as Map<String, dynamic>;
              final id = args['id'];
              return MaterialPageRoute(
                builder: (context) => DetailScreen(
                  id: id,
                ),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
