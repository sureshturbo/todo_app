import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'getData.dart';

class TodoProvider extends ChangeNotifier {

  late FirebaseFirestore _firestore;
  late CollectionReference _todosCollection;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  TodoProvider() {
    _firestore = FirebaseFirestore.instance;
    _todosCollection = _firestore.collection('todos');
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      final querySnapshot = await _todosCollection.get();
      final todos = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Todo(
            id: doc.id,
            title: data['title'] ?? '',
            completed: data['completed'] ?? false,
          );
        }).toList();

        ///
      _todos = todos;
      notifyListeners();
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  Future<void> addTodo(String title) async {
    try {
      final newTodo = {
        'title': title,
        'completed': false,
      };

      final docRef = await _todosCollection.add(newTodo);
      final todo = Todo(
        id: docRef.id,
        title: title,
        completed: false,
      );

      _todos.add(todo);
      notifyListeners();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> toggleTodoStatus(Todo todo) async {
    try {
      final docRef = _todosCollection.doc(todo.id);
      await docRef.update({'completed': !todo.completed});

      final updatedTodos = _todos.map((t) {
        if (t.id == todo.id) {
          return Todo(
            id: t.id,
            title: t.title,
            completed: !t.completed,
          );
        }
        return t;
      }).toList();

      _todos = updatedTodos;
      notifyListeners();
    } catch (e) {
      print('Error toggling todo status: $e');
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    try {
      final docRef = _todosCollection.doc(todo.id);
      await docRef.delete();

      _todos.remove(todo);
      notifyListeners();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }


}
