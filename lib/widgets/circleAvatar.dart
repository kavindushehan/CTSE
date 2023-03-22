
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomCircleAvatar extends StatefulWidget {
  NetworkImage myImage;
   CustomCircleAvatar({super.key, required this.myImage});

  @override
  State<CustomCircleAvatar> createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(backgroundImage: widget.myImage,);
  }
}