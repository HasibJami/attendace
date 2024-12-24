import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController lastController = TextEditingController();
final TextEditingController playerNumberController = TextEditingController();
final TextEditingController playerpositionController = TextEditingController();
String isPresentValue = 'حاضر';
String? selectedPlayerId;
Jalali? selectedDate;

const Color lightBlue = Color.fromRGBO(247, 247, 247, 1.0);
const Color deepBlue = Color.fromRGBO(68, 155, 200, 1.0);
const Color white = Color.fromRGBO(255, 255, 255, 1.0);
const Color custeomeBlack = Color.fromRGBO(2, 10, 31, 1.0);
const Color custeomeGray = Color.fromARGB(255, 158, 158, 158);


// double fullScreenHeight = MediaQuery.of(context).size.height;
// double fullScreenWidth = MediaQuery.of(context).size.width;
