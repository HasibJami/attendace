import 'package:flutter/material.dart';
import 'package:sorkhposhan/constants/constants.dart';
import 'package:sorkhposhan/views/attendance/checkAttendance.dart';
import 'package:sorkhposhan/views/attendance/getAttendance.dart';
import 'package:sorkhposhan/views/registration/registerPalyer.dart';
import 'package:sorkhposhan/views/widgets/custom_app_bar.dart';

class GetStart extends StatefulWidget {
  const GetStart({super.key});

  @override
  State<GetStart> createState() => _GetStartState();
}

class _GetStartState extends State<GetStart> {
  int _currentIndex = 0;

  // List of titles for the app bar based on selected BottomNavigationBarItem
  final List<String> _titles = ['ثبت نام', 'گرفتن حاضری', 'دیدن حاضری'];

  final List<Widget> _children = [
    const Register(),
    const GetAttendance(),
    const CheckAttendance(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Custom_app_bar(
            title: _titles[_currentIndex], // Set the app bar title dynamically
          )),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: white,
        selectedItemColor: custeomeBlack,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/addUser.png',
              width: 24,
              height: 24,
              color: custeomeBlack,
            ),
            label: 'ثبت نام',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/attend.png',
              width: 24,
              height: 24,
              color: custeomeBlack,
            ),
            label: 'گرفتن حاضری',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/participant.png',
              width: 24,
              height: 24,
              color: custeomeBlack,
            ),
            label: 'دیدن حاضری',
          ),
        ],
      ),
    );
  }
}
