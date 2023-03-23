import 'package:ctse_app/screens/aboutus.dart';
import 'package:ctse_app/screens/contactus.dart';
import 'package:ctse_app/screens/auth/profile.dart';
import 'package:ctse_app/screens/budget/budget_screen.dart';
import 'package:ctse_app/screens/note/note_screen.dart';
import 'package:ctse_app/screens/mainscreen.dart';
import 'package:flutter/material.dart';

import '../screens/todo/add_todo.dart';
import '../services/auth.dart';
import '../screens/auth/login.dart';
import '../services/todoService.dart';

class FabTabs extends StatefulWidget {
  int selectedIndex = 0;
  FabTabs({required this.selectedIndex});

  @override
  State<FabTabs> createState() => _FabTabsState();
}

class _FabTabsState extends State<FabTabs> {
  final AuthService auth = AuthService();
  final _todosService = TodosService();
  int currentIndex = 0;

  void onItemTapped(int index) async {
    setState(() {
      widget.selectedIndex = index;
      currentIndex = widget.selectedIndex;
    });

    if (currentIndex == 3) {
      dynamic result = await auth.signOut();
      if (result == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Successfully Signed Out'),
        ));
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EmailSignin()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error signing out'),
        ));
      }
    }
  }

  @override
  void initState() {
    onItemTapped(widget.selectedIndex);
    // TODO: implement initState
    super.initState();
  }

  final List<Widget> pages = [
    Home(),
    MyProfile(),
    // Team(),
    // More()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    Widget currentScreen = currentIndex == 0
        ? Home()
        : currentIndex == 1
            ? NoteScreen()
            : currentIndex == 2
                ? BudgetScreen()
                : currentIndex == 5
                ? ContactScreen()
                : currentIndex == 4
                    ? AboutUsPage()
                    : Home();
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade900,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTodoModal(
                onTodoAdded: (todo) async {
                  await _todosService.createTodos(todo);
                },
              );
            },
          );
          ;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentScreen = Home();
                        currentIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          color: currentIndex == 0
                              ? Colors.purple.shade900
                              : Colors.grey,
                        ),
                        Text(
                          "To-Do",
                          style: TextStyle(
                              color: currentIndex == 0
                                  ? Colors.purple.shade900
                                  : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentScreen = NoteScreen();
                        currentIndex = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note,
                          color: currentIndex == 1
                              ? Colors.purple.shade900
                              : Colors.grey,
                        ),
                        Text(
                          "Notes",
                          style: TextStyle(
                              color: currentIndex == 1
                                  ? Colors.purple.shade900
                                  : Colors.grey),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentScreen = BudgetScreen();
                        currentIndex = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wallet,
                          color: currentIndex == 2
                              ? Colors.purple.shade900
                              : Colors.grey,
                        ),
                        Text(
                          "Budget",
                          style: TextStyle(
                              color: currentIndex == 2
                                  ? Colors.purple.shade900
                                  : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () async {
                      dynamic result = await auth.signOut();
                      if (result == 'Success') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Successfully Signed Out'),
                        ));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => EmailSignin()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error signing out'),
                        ));
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: currentIndex == 3
                              ? Colors.purple.shade900
                              : Colors.grey,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                              color: currentIndex == 3
                                  ? Colors.purple.shade900
                                  : Colors.grey),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
