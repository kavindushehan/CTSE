import 'package:ctse_app/screens/auth/login.dart';
import 'package:ctse_app/screens/auth/profile.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Me'),
      ),
      body: Column(
        children: <Widget>[
          Container(
          height: 70,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(
                  40), // fromHeight use double.infinity as width and 40 is the height
            ),
            child: const Text('Profile'),
            onPressed: () async {
            
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => MyProfile()));
            }
          )),
          Container(
          height: 70,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(
                  40), // fromHeight use double.infinity as width and 40 is the height
            ),
            child: const Text('Logout'),
            onPressed: () async {
              dynamic result = await auth.signOut();
              print(result);
              if (result == 'Success') {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Successfully Signed Out'),
                ));
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => EmailSignin()));
              }
            },
          ))
        ],
      ),
    );
  }
}
