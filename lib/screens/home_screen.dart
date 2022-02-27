import 'package:firebase_auth/firebase_auth.dart';
import 'package:My_ToDo_App/services/auth_service.dart';
import 'package:My_ToDo_App/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser!.email;
    final todoService = Provider.of<TodoService>(context);
    final authService = AuthService();
    signOut() async {
      await authService.signOut();
      Navigator.pushReplacementNamed(context, 'login');

    }

    dialog(id) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Remove'),
                content: const Text('Do you want remove?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () async {
                        await todoService.deleteTodo(id: id);
                        Navigator.pop(context);
                      },
                      child: const Text('OK')),
                ],
              ));
    }
int selectedIndex = 0; 
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.pushNamed(context, 'todo');
        },
      ),
      drawer: _drawer(email, signOut),
      body: !todoService.isLoading
          ? ListView.builder(
              itemCount: todoService.InProgressitems.length,
              itemBuilder: (BuildContext context, int index) {
                var item = todoService.InProgressitems[index];
                return InkWell(
                  onLongPress: () => dialog(item.id),
                  onTap: () =>
                      Navigator.pushNamed(context, 'update', arguments: item),
                  child: _CardTodos(item: item),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.fact_check_outlined),
        label: 'To do',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.done, size: 28),
        label: 'Completed',
      ),
    ],
    
    currentIndex: selectedIndex,
    onTap: (index) =>  {
          selectedIndex = index,
          if(selectedIndex==0){
            Navigator.pushReplacementNamed(context, 'home')
          }else{
            Navigator.pushReplacementNamed(context, 'Completed')
          }
    }
  ),
    );
    
  }

  Drawer _drawer(String? email, signOut) {
    return Drawer(
      child: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    child: const FlutterLogo(),
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text('$email', style: const TextStyle(fontSize: 25)),
              const Expanded(child: SizedBox()),
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: signOut,
                child: const Text('SignOut',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTodos extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final item;

  const _CardTodos({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 17),
        child: Column(
          children: [
            Text(
              item['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              item['description'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              item['taskdate'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Icon(item['made'] == true ? Icons.check : Icons.close),
          ],
        ),
      ),
    );
  }
}
