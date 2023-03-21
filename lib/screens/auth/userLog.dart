import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_app/models/userLog.dart';
import 'package:ctse_app/services/userLogService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UserLogData extends StatefulWidget {
  const UserLogData({super.key});

  @override
  State<UserLogData> createState() => _UserLogDataState();
}



class _UserLogDataState extends State<UserLogData> {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserLogService userLogService = UserLogService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In Log"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<UserLog>>(
        stream: userLogService.getTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<UserLog> userLog = snapshot.data!;
          return ListView.builder(
            itemCount: userLog.length,
            itemBuilder: (context, index) {
              final user = userLog[index];
              return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:  <Widget>[
            ListTile(
              // leading: Icon(Icons.album),
              title: Text(('Date: ')+(user.date ?? '')),
              subtitle: Text(('Sign In Time: ')+(user.hour ?? '') + (':') + (user.minute ?? '')),
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
}


// return Card(
//                 elevation: 4.0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(0.0),
//                 ),

//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user.date ?? '',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22.0,
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
                      
//                       Row(
//                         children: [
//                           Text(
//                         user.hour ?? '',
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(width: 4.0),
//                           Text(
//                             ":",
//                             style: TextStyle(
//                               fontSize: 20.0,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(width: 4.0),
//                           Text(
//                             user.minute ?? '',
//                             style: TextStyle(
//                               fontSize: 20.0,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ]
//                       ),
//                     ],
//                   ),
//                 ),
//               );

