import 'package:flutter/material.dart';
import 'package:sorkhposhan/constants/constants.dart';

class Custom_app_bar extends StatelessWidget {
  String title;
  Custom_app_bar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        // foregroundColor: white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
              color: custeomeBlack,
              fontSize: 20,
              fontFamily: "TrajanPro",
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
