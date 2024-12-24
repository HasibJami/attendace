import 'package:flutter/material.dart';
import 'package:sorkhposhan/components/attendanceList/attendance_list.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:sorkhposhan/constants/constants.dart';
import '../../components/buttons/atten_button.dart';

class GetAttendance extends StatefulWidget {
  const GetAttendance({super.key});

  @override
  State<GetAttendance> createState() => _GetAttendanceState();
}

class _GetAttendanceState extends State<GetAttendance> {
  List<Map<String, dynamic>> allData = [];
  Jalali? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    Jalali? pickedDate = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1390, 8),
      lastDate: Jalali(1450, 9),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          AttendanceList(
            allData: allData,
            updateData: (updatedData) {
              setState(() {
                allData = List.from(updatedData);
              });
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                width: 200,
                child:
                    AttenButton(allData: allData, selectedDate: selectedDate),
              ),
            ),
          ), // Pass selectedDate
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () => _selectDate(context),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: deepBlue,
          child: const Icon(
            Icons.date_range_outlined,
            color: white,
          ),
        ),
      ),
    );
  }
}
