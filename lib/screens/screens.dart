import 'package:My_ToDo_App/screens/home_screen.dart';
import 'package:My_ToDo_App/screens/login_screen.dart';
import 'package:My_ToDo_App/screens/signup_screen.dart';
import 'package:My_ToDo_App/screens/todo_screen.dart';
import 'package:My_ToDo_App/screens/update_todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:My_ToDo_App/screens/home_screen completed.dart';

final routes = <String, WidgetBuilder>{
  'login': (BuildContext _) => const LoginScreen(),
  'signup': (BuildContext _) => const SignUpScreen(),
  'home': (BuildContext _) => const HomeScreen(),
  'Completed': (BuildContext _) => const Completed(),
  'todo': (BuildContext _) => const TodoScreen(),
  'update': (BuildContext _) => const UpdateTodoScreen(),
};
