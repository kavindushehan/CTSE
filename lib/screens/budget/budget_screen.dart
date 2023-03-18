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
  List<Budgets> _budgets = [];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        backgroundColor: Colors.blue,
        actions: [
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
          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              if (_searchQuery.isNotEmpty &&
                  !budget.reason
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase())) {
                return Container();
              }
              return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    title: Text(budget.reason),
                    subtitle: Text(budget.amount),
                  ),
                  actions: [
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () {
                        _showEditBudgetDialog(context, budget);
                      },
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        _budgetsService.deleteBudgets(budget.id);
                      },
                    ),
                  ]);
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
