import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NotesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collectionName = "notes";

  late final String _uid;

  NotesService() {
    _uid = _auth.currentUser!.uid;
  }

  Stream<List<Notes>> getNotes() {
    return _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .orderBy("noteTitle")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Notes.fromJson(doc.data())).toList());
  }

  Future<void> createNotes(Notes note) async {
    await _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .doc(note.noteId)
        .set(note.toJson());
  }

  Future<void> updateNotes(Notes note) async {
    await _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .doc(note.noteId)
        .update(note.toJson());
  }

  Future<void> deleteNotes(String noteId) async {
    await _db
        .collection('userData')
        .doc(_uid)
        .collection(collectionName)
        .doc(noteId)
        .delete();
  }
}
