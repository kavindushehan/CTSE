import 'package:ctse_app/widgets/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      drawer: const SideMenu(),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                    hintText: "Search todos...",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : const Text("To Do"),
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
              final description = todo.description.toLowerCase();
              return title.contains(query) || description.contains(query);
            }).toList();
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.yellow.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        todo.description,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 20.0,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '${todo.dateTime.toLocal().toString().substring(0, 10)}',
                            style: TextStyle(
                              fontSize: 20.0,
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
                            '${todo.dateTime.toLocal().toString().substring(10, 16)}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                              _todosService.deleteTodos(todo.id);
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

  void _showEditTodoDialog(BuildContext context, Todos todo) {
    final TextEditingController titleController =
        TextEditingController(text: todo.title);
    final TextEditingController descriptionController =
        TextEditingController(text: todo.description);
    DateTime selectedDate = todo.dateTime;

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
                    labelText: "Description",
                  ),
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
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != selectedDate)
                          setState(() {
                            selectedDate = picked;
                          });
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
                        todo.description = descriptionController.text;
                        todo.dateTime = selectedDate;
                        _todosService.updateTodos(todo);
                        Navigator.pop(context);
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
