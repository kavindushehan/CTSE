import 'package:ctse_app/models/budget.dart';
import 'package:ctse_app/screens/budget/add_budget.dart';
import 'package:ctse_app/services/budgetService.dart';
import 'package:ctse_app/widgets/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
        backgroundColor: Colors.blue,
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
                _showCompleted = value == 'completed';
                _showNonCompleted = value == 'non_completed';
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                    Text('Non-Completed'),
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
              final description = budget.amount.toLowerCase();
              return title.contains(query) || description.contains(query);
            }).toList();
          }
          List<Budgets> getCompletedBudgets(List<Budgets> budgets) {
            return budgets.where((budget) => budget.isCompleted).toList();
          }

          List<Budgets> getNonCompletedBudgets(List<Budgets> budgets) {
            return budgets.where((budget) => !budget.isCompleted).toList();
          }

          if (_showCompleted) {
            budgets = getCompletedBudgets(budgets);
          } else if (_showNonCompleted) {
            budgets = getNonCompletedBudgets(budgets);
          }

          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
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
        TextEditingController(text: budget.amount);

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
                budget.amount = amountController.text;
                _budgetsService.updateBudgets(budget);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}