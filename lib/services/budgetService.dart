// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/budget.dart';

class BudgetsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collectionName = "budgets";

  late final String _uid;

  BudgetsService() {
    _uid = _auth.currentUser!.uid;
  }

  Stream<List<Budgets>> getBudgets() {
    return _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .orderBy("reason")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Budgets.fromJson(doc.data())).toList());
  }

  Future<void> createBudgets(Budgets budget) async {
    await _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .doc(budget.id)
        .set(budget.toJson());
  }

  Future<void> updateBudgets(Budgets budget) async {
    await _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .doc(budget.id)
        .update(budget.toJson());
  }

  Future<void> deleteBudgets(String id) async {
    await _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .doc(id)
        .delete();
  }
}
