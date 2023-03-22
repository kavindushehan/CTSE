import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/todo.dart';

class AddTodoModal extends StatefulWidget {
  final Function(Todos) onTodoAdded;

  const AddTodoModal({required this.onTodoAdded});

  @override
  _AddTodoModalState createState() => _AddTodoModalState();
}

class _AddTodoModalState extends State<AddTodoModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subTaskController = TextEditingController();
  final List<String> _priorities = ['High', 'Medium', 'Low'];
  String _selectedPriority = 'Low';

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    _subTaskController.dispose();
    super.dispose();
  }

  Future<void> _showDateTimePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  Color _getColorForPriority(String priority) {
    // return color based on priority
    if (priority == 'High') {
      return Colors.red;
    } else if (priority == 'Medium') {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Todo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
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
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _subTaskController,
                    decoration: const InputDecoration(
                      labelText: 'Sub Task',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: _priorities
                        .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getColorForPriority(priority),
                                  ),
                                ),
                                Text(priority),
                              ],
                            )))
                        .toList(),
                  ),
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: () async {
                      await _showDateTimePicker();
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8.0),
                        Text(
                          '${_selectedDate.toLocal().toString().substring(0, 10)} ${_selectedTime.format(context)}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String id = const Uuid().v4();
                          String title = _titleController.text.trim();
                          String subTask = _subTaskController.text.trim();
                          Todos todo = Todos(
                              id: id,
                              title: title,
                              subTask: subTask,
                              dateTime: DateTime(
                                  _selectedDate.year,
                                  _selectedDate.month,
                                  _selectedDate.day,
                                  _selectedTime.hour,
                                  _selectedTime.minute),
                              priority: _selectedPriority);
                          await widget.onTodoAdded(todo);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
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
