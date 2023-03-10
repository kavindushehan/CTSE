import 'package:ctse_app/screens/auth/profile.dart';
import 'package:ctse_app/home.dart';
import 'package:ctse_app/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'mainscreen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      return const Main();
    } else {
      return const EmailSignin();
    }
  }
}
