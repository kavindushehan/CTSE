import 'package:flutter/material.dart';

class LoadingTransparentPage extends StatelessWidget {
  const LoadingTransparentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent ,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}