import 'package:flutter/material.dart';
import 'package:sorkhposhan/services/auth.dart';
import 'package:sorkhposhan/constants/constants.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class AttenButton extends StatelessWidget {
  final List<Map<String, dynamic>> allData;
  final Jalali? selectedDate;

  const AttenButton(
      {required this.allData, required this.selectedDate, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: deepBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: MaterialButton(
            onPressed: () {
              if (selectedDate != null) {
                getAttendanceMethod(
                    allData: allData,
                    selectedDate: selectedDate!,
                    context: context);
              } else {
                // Show error if date not selected
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a date')),
                );
              }
            },
            child: const Text(
              "ذخیره",
              style: TextStyle(
                color: white,
                fontSize: 20,
                fontFamily: "TrajanPro",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
