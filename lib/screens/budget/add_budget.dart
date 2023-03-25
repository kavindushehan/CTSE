import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/budget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBudgetModel extends StatefulWidget {
  final Function(Budgets) onBudgetAdded;

  const AddBudgetModel({super.key, required this.onBudgetAdded});

  @override
  // ignore: library_private_types_in_public_api
  _AddBudgetModalState createState() => _AddBudgetModalState();
}

class _AddBudgetModalState extends State<AddBudgetModel> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _amountController = TextEditingController();
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _incrementAmount() {
    setState(() {
      _amount++;
      _amountController.text = _amount.toString();
    });
  }

  void _decrementAmount() {
    setState(() {
      if (_amount > 0) {
        _amount--;
        _amountController.text = _amount.toString();
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _amountController.dispose();
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
      // ignore: use_build_context_synchronously
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
              'Add Budget',
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
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      labelText: 'Reason',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reason';
                      }
                      return null;
                    },
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: _decrementAmount,
                        icon: const Icon(Icons.remove),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _amount = double.parse(value);
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: _incrementAmount,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String id = const Uuid().v4();
                          String reason = _reasonController.text.trim();
                          String amount = _amountController.text.trim();
                          Budgets budget = Budgets(
                            id: id,
                            reason: reason,
                            amount: amount,
                            dateTime: DateTime(
                                _selectedDate.year,
                                _selectedDate.month,
                                _selectedDate.day,
                                _selectedTime.hour,
                                _selectedTime.minute),
                          );
                          await widget.onBudgetAdded(budget);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                        Fluttertoast.showToast(
                          msg: 'Budget added successfully!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[600],
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
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
