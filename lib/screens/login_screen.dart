import 'package:My_ToDo_App/services/auth_service.dart';
import 'package:My_ToDo_App/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final todoService = Provider.of<TodoService>(context);
    final height = MediaQuery.of(context).size.height;

    register() async {
      Navigator.pushReplacementNamed(context, 'signup');
    }

    logIn() async {
      await todoService.loadinProgressTodos();
      await todoService.loadinCompletedTodos();
      String res = await AuthService()
          .logIn(email: authService.email, password: authService.password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));

      if (res == 'Welcome') {
        await todoService.loadinProgressTodos();
        await todoService.loadinCompletedTodos();
        Navigator.pushReplacementNamed(context, 'home');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My_ToDo_App'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                'Login',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 50),
              ),
              const SizedBox(height: 25),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.blueAccent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(48, 48, 48, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          authService.email = value;
                        },
                        decoration: const InputDecoration(
                          hintText: '',
                          labelText: 'Email',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(48, 48, 48, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          authService.password = value;
                        },
                        decoration: const InputDecoration(
                          hintText: '*******',
                          labelText: 'Password',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    MaterialButton(
                      color: const Color.fromRGBO(48, 48, 48, 1),
                      onPressed: logIn,
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 5),
                    MaterialButton(
                      color: const Color.fromRGBO(48, 48, 48, 1),
                      onPressed: register,
                      child: const Text('Create new account'),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
