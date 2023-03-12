import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/todo.dart';

class TodosService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collectionName = "todos";

  late final String _uid;

  TodosService() {
    _uid = _auth.currentUser!.uid;
  }

  Stream<List<Todos>> getTodos() {
    return _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .orderBy("title")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Todos.fromJson(doc.data())).toList());
  }

  Future<void> createTodos(Todos todo) async {
    await _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .doc(todo.id)
        .set(todo.toJson());
  }

  Future<void> updateTodos(Todos todo) async {
    await _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .doc(todo.id)
        .update(todo.toJson());
  }

  Future<void> deleteTodos(String id) async {
    await _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .doc(id)
        .delete();
  }
}
