import 'package:ctse_app/models/userLog.dart';
import 'package:ctse_app/services/userLogService.dart';
import 'package:flutter/material.dart';

class UserLogData extends StatefulWidget {
  const UserLogData({super.key});

  @override
  State<UserLogData> createState() => _UserLogDataState();
}

class _UserLogDataState extends State<UserLogData> {
  final UserLogService userLogService = UserLogService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In Log"),
        backgroundColor: Colors.purple.shade900,
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
                    children: <Widget>[
                      ListTile(
                        // leading: Icon(Icons.album),
                        title: Text(('Date: ') + (user.date ?? '')),
                        subtitle: Text(('Sign In Time: ') +
                            (user.hour ?? '') +
                            (':') +
                            (user.minute ?? '')),
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
