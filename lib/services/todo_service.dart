import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class TodoService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var InProgressitems = [];
  var Completeditems = [];
  bool isLoading = false;
  String _title = '';
  String _description = '';
  String _taskdate = '';
  bool _made = false;

  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  String get taskdate => _taskdate;
  set taskdate(String taskdate) {
    _taskdate = taskdate;
    notifyListeners();
  }

  get description => _description;
  set description(description) {
    _description = description;
    notifyListeners();
  }

  bool get made => _made;
  set made(bool value) {
    _made = value;
    notifyListeners();
  }

  TodoService() {
    loadinProgressTodos();
    loadinCompletedTodos();
  }

  clearData() {
    InProgressitems = [];
    Completeditems = [];
    notifyListeners();
  }

  Future loadinProgressTodos() async {
    InProgressitems = [];
    isLoading = true;
    notifyListeners();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return;
      }
      final res = await _firestore
          .collection('todos')
          .where('userId', isEqualTo: userId)
          .where('made', isEqualTo: false) 
          .get();

      for (var element in res.docs) {
        InProgressitems.add(element);
      }
      isLoading = false;
      notifyListeners();
      return InProgressitems;
    } catch (e) {
      print(e);
    }
  }

  Future loadinCompletedTodos() async {
    Completeditems = [];
    isLoading = true;
    notifyListeners();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return;
      }
      final res = await _firestore
          .collection('todos')
          .where('userId', isEqualTo: userId)
          .where('made', isEqualTo: true) 
          .get();

      for (var element in res.docs) {
        Completeditems.add(element);
      }
      isLoading = false;
      notifyListeners();
      return Completeditems;
    } catch (e) {
      print(e);
    }
  }

  Future deleteTodo({id}) async {
    try {
      await _firestore.collection('todos').doc(id).delete();
      loadinProgressTodos();
      loadinCompletedTodos();
      notifyListeners();
      return 'Deleted Todo';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'The email is badly formatted.';
      } else if (e.code == 'weak-password') {
        return "Password should be at least 6 characters";
      } else {
        return e.code;
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> postTodo({title, description, made, taskdate}) async {
    if (title == '' || description == '') return 'Fields empty';
    try {
      final todoId = const Uuid().v1();
      await _firestore.collection('todos').doc(todoId).set({
        "description": description,
        "made": made,
        "title": title,
        "taskdate": taskdate,
        "userId": _auth.currentUser!.uid,
      });
      loadinProgressTodos();
      loadinCompletedTodos();
      notifyListeners();
      return 'Created Todo';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'The email is badly formatted.';
      } else if (e.code == 'weak-password') {
        return "Password should be at least 6 characters";
      } else {
        return e.code;
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> updateTodo({id, title, description, made, taskdate}) async {
    if (title == '' || description == '') {
      return 'No changes. You must change title and description';
    }
    try {
      await _firestore.collection('todos').doc(id).update({
        "description": description,
        "made": made,
        "taskdate": taskdate,
        "title": title,
      });
      loadinProgressTodos();
      loadinCompletedTodos();
      description = '';
      title = '';
      notifyListeners();
      return 'Updated Todo';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'The email is badly formatted.';
      } else if (e.code == 'weak-password') {
        return "Password should be at least 6 characters";
      } else {
        return e.code;
      }
    } catch (e) {
      return 'Error';
    }
  }
}
