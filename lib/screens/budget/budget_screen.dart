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
          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              // if (_searchQuery.isNotEmpty &&
              //     !budget.reason
              //         .toLowerCase()
              //         .contains(_searchQuery.toLowerCase())) {
              //   return Container();
              // }
              return Card(
                child: ListTile(
                  title: Text(budget.reason),
                  subtitle: Text(budget.amount),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                budget.reason = reasonController.text;
                budget.amount = amountController.text;
                _budgetsService.updateBudgets(budget);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
