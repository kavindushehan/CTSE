import 'package:ctse_app/models/budget.dart';
import 'package:ctse_app/screens/budget/add_budget.dart';
import 'package:ctse_app/services/budgetService.dart';
import 'package:ctse_app/widgets/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _HomeState();
}

class _HomeState extends State<BudgetScreen> {
  final BudgetsService _budgetsService = BudgetsService();
  late TextEditingController _searchController;
  List<Budgets> _budgets = [];
  String _searchQuery = '';
  bool _isSearching = false;
  bool _showCompleted = false;
  bool _showNonCompleted = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                    hintText: "Search budgets...",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : const Text("Budgets"),
        backgroundColor: Colors.purple.shade900,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddBudgetModel(
                    onBudgetAdded: (budget) async {
                      await _budgetsService.createBudgets(budget);
                    },
                  );
                },
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                if (value == 'all') {
                  _showCompleted = true;
                  _showNonCompleted = true;
                } else {
                  _showCompleted = value == 'completed';
                  _showNonCompleted = value == 'non_completed';
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('All'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'completed',
                child: Row(
                  children: [
                    Icon(Icons.done_all, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Completed'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'non_completed',
                child: Row(
                  children: [
                    Icon(Icons.list_alt, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Non Completed'),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.filter_alt, color: Colors.white),
          )
        ],
      ),
      body: StreamBuilder<List<Budgets>>(
        stream: _budgetsService.getBudgets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Budgets> budgets = snapshot.data!;
          if (_isSearching) {
            final query = _searchController.text.toLowerCase();
            budgets = budgets.where((budget) {
              final title = budget.reason.toLowerCase();
              final amount = budget.amount.toLowerCase();
              return title.contains(query) || amount.contains(query);
            }).toList();
          }

          List<Budgets> filteredBudgets = [];
          if (_showCompleted && _showNonCompleted) {
            filteredBudgets = budgets;
          } else if (_showCompleted) {
            filteredBudgets =
                budgets.where((budget) => budget.isCompleted).toList();
          } else if (_showNonCompleted) {
            filteredBudgets =
                budgets.where((budget) => !budget.isCompleted).toList();
          }

          return ListView.builder(
            itemCount: filteredBudgets.length,
            itemBuilder: (context, index) {
              final budget = filteredBudgets[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budget.reason,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Rs ${budget.amount}.00',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divider(thickness: 1.0, height: 0.0),
                    ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 20.0,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '${budget.dateTime.toLocal().toString().substring(0, 10)}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Icon(
                            Icons.access_time,
                            size: 20.0,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '${budget.dateTime.toLocal().toString().substring(10, 16)}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 3.0),
                          Checkbox(
                            value: budget.isCompleted,
                            onChanged: (value) {
                              setState(() {
                                budget.isCompleted = value!;
                                _budgetsService.updateBudgets(budget);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () {
                              _showEditBudgetDialog(context, budget);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _budgetsService.deleteBudgets(budget.id);
                              Fluttertoast.showToast(
                                  msg: "Budget deleted successfully");
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3.0),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, Budgets budget) {
    final TextEditingController reasonController =
        TextEditingController(text: budget.reason);
    final TextEditingController amountController =
        TextEditingController(text: budget.amount.toString());
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Budget"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: "Reason",
                ),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: "Amount",
                ),
                keyboardType: TextInputType.numberWithOptions(
                    decimal:
                        true), // set keyboard type to allow decimal numbers
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Date:"),
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day -
                                1), // set firstDate to the day before the selectedDate
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Text(
                      "${selectedDate.toLocal().toString().substring(0, 10)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Time:"),
                  TextButton(
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate),
                      );
                      if (picked != null)
                        setState(() {
                          selectedDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                    },
                    child: Text(
                      "${selectedDate.toLocal().toString().substring(10, 16)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                budget.reason = reasonController.text;
                budget.amount = amountController.text; // convert to double
                budget.dateTime = selectedDate;
                _budgetsService.updateBudgets(budget);
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Budget updated successfully");
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
