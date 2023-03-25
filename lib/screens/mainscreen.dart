import 'package:ctse_app/widgets/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/todo.dart';
import '../services/todoService.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TodosService _todosService = TodosService();
  late TextEditingController _searchController;
  bool _showLow = false;
  bool _showHigh = false;
  bool _showMedium = false;
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

  Color _getColor(String priority) {
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
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                    hintText: "Search todos...",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : const Text("To Do"),
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
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                if (value == 'all') {
                  _showLow = true;
                  _showHigh = true;
                  _showMedium = true;
                } else {
                  _showLow = value == 'Low';
                  _showHigh = value == 'High';
                  _showMedium = value == 'Medium';
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
                value: 'Low',
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Low'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Medium',
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Medium'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'High',
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.red),
                    SizedBox(width: 8),
                    Text('High'),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.filter_alt, color: Colors.white),
          )
        ],
      ),
      body: StreamBuilder<List<Todos>>(
        stream: _todosService.getTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Todos> todos = snapshot.data!;
          if (_isSearching) {
            final query = _searchController.text.toLowerCase();
            todos = todos.where((todo) {
              final title = todo.title.toLowerCase();
              final description = todo.subTask.toLowerCase();
              return title.contains(query) || description.contains(query);
            }).toList();
          }

          List<Todos> filteredTodos = [];

          if (_showLow && _showMedium && _showHigh) {
            filteredTodos = todos;
          } else if (_showLow) {
            filteredTodos =
                todos.where((todo) => todo.priority == 'Low').toList();
          } else if (_showMedium) {
            filteredTodos =
                todos.where((todo) => todo.priority == 'Medium').toList();
          } else if (_showHigh) {
            filteredTodos =
                todos.where((todo) => todo.priority == 'High').toList();
          }

          return ListView.builder(
            itemCount:
                filteredTodos.length == 0 ? todos.length : filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = filteredTodos.length == 0
                  ? todos[index]
                  : filteredTodos[index];
              final DateTime today = DateTime.now();
              final DateTime todoDate = todo.dateTime;
              final bool isOverdue =
                  DateTime(today.year, today.month, today.day).isAfter(
                      DateTime(todoDate.year, todoDate.month, todoDate.day));
              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.purple.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 16.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getColor(todo.priority),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        todo.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        todo.subTask,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 8.0),
                      // Text(
                      //   todo.priority,
                      //   style: TextStyle(
                      //     fontSize: 20.0,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            todo.dateTime.toLocal().toString().substring(0, 10),
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          const Icon(
                            Icons.access_time,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            todo.dateTime
                                .toLocal()
                                .toString()
                                .substring(10, 16),
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isOverdue)
                            TextButton.icon(
                              onPressed: () {
                                _showEditTodoDialog(context, todo);
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              label: const Text('Edit',
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          const SizedBox(width: 16.0),
                          TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Todo"),
                                    content: Text(
                                        "Are you sure you want to delete this todo?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _todosService.deleteTodos(todo.id);
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(
                                              msg: "Todo deleted successfully");
                                        },
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
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

  void _showEditTodoDialog(BuildContext context, Todos todo) {
    final TextEditingController titleController =
        TextEditingController(text: todo.title);
    final TextEditingController descriptionController =
        TextEditingController(text: todo.subTask);
    DateTime selectedDate = todo.dateTime;
    String selectedPriority = todo.priority;

    List<String> priorities = ['Low', 'Medium', 'High'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Sub Task",
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Date:"),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Text(
                          selectedDate.toLocal().toString().substring(0, 10),
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Time:"),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return TextButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(selectedDate),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                picked.hour,
                                picked.minute,
                              );
                            });
                          }
                        },
                        child: Text(
                          selectedDate.toLocal().toString().substring(10, 16),
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Priority:"),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return DropdownButton<String>(
                          value: selectedPriority,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedPriority = newValue;
                              });
                            }
                          },
                          items: priorities
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _getColorForPriority(value),
                                    ),
                                  ),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          const Text("Cancel", style: TextStyle(fontSize: 16)),
                    ),
                    TextButton(
                      onPressed: () {
                        todo.title = titleController.text;
                        todo.subTask = descriptionController.text;
                        todo.dateTime = selectedDate;
                        todo.priority = selectedPriority;
                        _todosService.updateTodos(todo);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: "Todo updated successfully");
                      },
                      child: const Text("Save", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
