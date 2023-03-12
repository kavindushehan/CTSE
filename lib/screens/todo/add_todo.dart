import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/todo.dart';

class AddTodoModal extends StatefulWidget {
  final Function(Todos) onTodoAdded;

  AddTodoModal({required this.onTodoAdded});

  @override
  _AddTodoModalState createState() => _AddTodoModalState();
}

class _AddTodoModalState extends State<AddTodoModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Todo'),
      content: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String id = Uuid().v4();
                    String title = _titleController.text.trim();
                    String description = _descriptionController.text.trim();
                    Todos todo = Todos(
                      id: id,
                      title: title,
                      description: description,
                    );
                    await widget.onTodoAdded(todo);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
