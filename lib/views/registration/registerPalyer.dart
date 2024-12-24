import 'package:flutter/material.dart';
import 'package:sorkhposhan/components/inputs/inputs.dart';
import 'package:sorkhposhan/services/auth.dart';
import 'package:sorkhposhan/constants/constants.dart';
import '../../components/buttons/reg_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    double fullScreenHeight = MediaQuery.of(context).size.height;
    double fullScreenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: fullScreenHeight,
        width: fullScreenWidth,
        color: white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: white,
                    image: DecorationImage(
                      image: AssetImage("assets/images/bkg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  InputField(
                    controller: nameController,
                    hintText: "نام",
                  ),
                  const SizedBox(height: 8),
                  InputField(
                    controller: lastController,
                    hintText: "فامیلی",
                  ),
                  const SizedBox(height: 8),
                  InputField(
                    controller: playerNumberController,
                    hintText: "شماره پیراهن",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  InputField(
                    controller: playerpositionController,
                    hintText: "پست بازیکن",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SaveButton(
                onPressed: () => createRecord(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
