import 'package:ctse_app/screens/home.dart';
import 'package:ctse_app/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    final FirebaseAuth auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    print(user);
    if(user!=null){

      return const Home();
    }
    else{
      return  const EmailSignin();
    }

  }
}
