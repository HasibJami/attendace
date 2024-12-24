import 'package:flutter/material.dart';
import 'package:sorkhposhan/constants/constants.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double fullScreenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 50,
      width: fullScreenWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: deepBlue,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "ذخیره",
          style: TextStyle(
            color:white,
            fontSize: 20,
            fontFamily: "TrajanPro",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
