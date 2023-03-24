import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/note.dart';

class AddNoteModel extends StatefulWidget {
  final Function(Notes) onNoteAdded;

  const AddNoteModel({required this.onNoteAdded});

  @override
  _AddNoteModalState createState() => _AddNoteModalState();
}

class _AddNoteModalState extends State<AddNoteModel> {
  final _formKey = GlobalKey<FormState>();
  final _noteTitleController = TextEditingController();
  final _noteDescriptionController = TextEditingController();
  final _noteTypeController = TextEditingController();
  double _noteDescription = 0;

  void _incrementAmount() {
    setState(() {
      _noteDescription++;
      _noteDescriptionController.text = _noteDescription.toString();
    });
  }

  void _decrementAmount() {
    setState(() {
      if (_noteDescription > 0) {
        _noteDescription--;
        _noteDescriptionController.text = _noteDescription.toString();
      }
    });
  }

  @override
  void dispose() {
    _noteDescriptionController.dispose();
   // _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Note',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _noteTitleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _noteDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String noteId = Uuid().v4();
                          String noteTitle = _noteTitleController.text.trim();
                          String noteDescription = _noteDescriptionController.text.trim();
                          //String noteDescription = _noteDescriptionController.text.trim();
                          //String amount = _amountController.text.trim();
                          Notes note = Notes(
                            noteId: noteId,
                            noteTitle: noteTitle,
                            noteDescription: noteDescription,
                            
                            //amount: amount,
                          );
                          await widget.onNoteAdded(note);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
