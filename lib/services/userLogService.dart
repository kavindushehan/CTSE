import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_app/models/userLog.dart';
import 'package:firebase_auth/firebase_auth.dart';



class UserLogService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collectionName = "userLog";

  late final String _uid;

  UserLogService() {
    _uid = _auth.currentUser!.uid;
  }

  Stream<List<UserLog>> getTodos() {
    return _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserLog.fromMap(doc.data())).toList());
  }

}
