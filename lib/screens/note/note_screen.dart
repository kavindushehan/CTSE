import 'package:ctse_app/models/note.dart';
import 'package:ctse_app/screens/note/add_note.dart';
import 'package:ctse_app/services/noteService.dart';
import 'package:ctse_app/widgets/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _HomeState();
}

class _HomeState extends State<NoteScreen> {
  final NotesService _notesService = NotesService();
  List<Notes> _notes = [];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Search Notes"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          autofocus: true,
                          onChanged: (value) {
                            // Update search query
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Clear search query
                                setState(() {
                                  _searchQuery = '';
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Clear'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Search'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddNoteModel(
                    onNoteAdded: (note) async {
                      await _notesService.createNotes(note);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Notes>>(
        stream: _notesService.getNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Notes> notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              if (_searchQuery.isNotEmpty &&
                  !note.noteDescription
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase())) {
                return Container();
              }
              return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    title: Text(note.noteDescription),
                    //subtitle: Text(budget.amount),
                  ),
                  actions: [
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () {
                        _showEditNoteDialog(context, note);
                      },
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        _notesService.deleteNotes(note.noteId);
                      },
                    ),
                  ]);
            },
          );
        },
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, Notes note) {
    final TextEditingController noteDescriptionController =
        TextEditingController(text: note.noteDescription);
   // final TextEditingController amountController =
        //TextEditingController(text: budget.amount);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteDescriptionController,
                decoration: InputDecoration(
                  labelText: "Note Description",
                ),
              ),
              // TextField(
              //   controller: amountController,
              //   decoration: InputDecoration(
              //     labelText: "Amount",
              //   ),
              // ),
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
                note.noteDescription = noteDescriptionController.text;
                //budget.amount = amountController.text;
                _notesService.updateNotes(note);
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
