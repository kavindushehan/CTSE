import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ctseproject/Screens/todolist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import '../widget/plus_button.dart';

class BudgectScreen extends StatefulWidget {
  String id;
  String categoryId;

  BudgectScreen(this.id, this.categoryId);

  @override
  _BudgectScreenState createState() => _BudgectScreenState();
}

class _BudgectScreenState extends State<BudgectScreen> {
  void _enterTransaction(String id, String categoryId) {
    insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      id,
      categoryId,
    );
    setState(() {
      _textcontrollerITEM.text = "";
      _textcontrollerAMOUNT.text = "";
    });
  }

  Future insert(
      String name, String amount, String id, String categoryId) async {
    if (FirebaseFirestore.instance == null) return;
    var data = {
      'name': name,
      'amount': amount,
    };

    CollectionReference ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Categories')
        .doc(categoryId)
        .collection('Todo')
        .doc(id)
        .collection("Budget");
    ref.add(data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Budget Adding Successfully",
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textcontrollerITEM.dispose();
    _textcontrollerAMOUNT.dispose();
    super.dispose();
  }

  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  var name = '';
  var amount = '';

  List<Color> myColors = [
    Color(0xFFFCE4EC),
    Color(0xFFE8F5E9),
    Color(0xFFE3F2FD),
    Color(0xFFFFF3E0),
    Color(0xFFE8EAF6),
    Color(0xFFFFEBEE),
    Color(0xFFFFFDE7),
    Color(0xFFEFEBE9),
    Color(0xFFE0F2F1),
    Color(0xFFF3E5F5),
  ];

  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('Budget'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?',
                              ),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Enter a name';
                                }
                                return null;
                              },
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction(widget.id, widget.categoryId);
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  void _newEditAndDeleteTransaction(
      DocumentReference<Object?> reference, Map? data) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('Budget'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Expense'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('Income'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                //initialValue: amount,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              //initialValue:name,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?',
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                        Text('Delete', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      delete(reference);
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: Text('Edit', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        save(reference, data);
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _newTransaction,
        child: Icon(
          Icons.add,
          color: Colors.white70,
        ),
        backgroundColor: Colors.grey[700],
      ),
      appBar: AppBar(
        title: Text("Budget"),
        backgroundColor: Color(0xff0095FF),
      ),
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Categories')
            .doc(widget.categoryId)
            .collection('Todo')
            .doc(widget.id)
            .collection("Budget")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length == 0) {
              return Center(
                child: Text(
                  "You have no saved Budget !",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Random random = new Random();
                Color bg = myColors[random.nextInt(4)];
                Map? data = snapshot.data!.docs[index].data() as Map?;

                return InkWell(
                  onTap: () {
                    _newEditAndDeleteTransaction(
                        snapshot.data!.docs[index].reference, data);
                  },
                  child: Card(
                    color: bg,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data!['name']}",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: "lato",
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          //
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${data['amount']}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "lato",
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
    );
  }

  void delete(DocumentReference<Object?> reference) async {
    // delete from db
    if (reference != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Delete Successfully",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      );
      await reference.delete();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Delete Faild",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      );
    }

    Navigator.pop(context);
  }

  void save(DocumentReference<Object?> reference, Map? data) async {
    if (_formKey.currentState!.validate()) {
      // TODo : showing any kind of alert that new changes have been saved
      double amount = 0.0;
      String name = "";
      if (_isIncome == true) {
        amount = double.parse(_textcontrollerAMOUNT.text) +
            double.parse(data!['amount']);
      }
      if (_isIncome == false) {
        amount = double.parse(data!['amount']) -
            double.parse(_textcontrollerAMOUNT.text);
      }
      if (_textcontrollerITEM.text == "") {
        name = data!['name'];
      } else {
        name = _textcontrollerITEM.text;
      }
      if (amount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Update Successfully",
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        );
        await reference.update(
          {'name': name, 'amount': amount.toString()},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Amount is low",
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        );
      }

      Navigator.of(context).pop();
    }
  }
}
