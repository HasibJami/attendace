import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sorkhposhan/constants/constants.dart';
import 'message_service.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference attendanceRef =
    FirebaseFirestore.instance.collection('Attendance');

void createRecord(BuildContext context) async {
  try {
    if (nameController.text.isEmpty ||
        lastController.text.isEmpty ||
        playerNumberController.text.isEmpty ||
        playerpositionController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const CustomDialog(
          isSuccess: false,
          title: '!متاسفم',
          message: '.باید تمام خانه ها را پر کنید',
          buttonText: '!باشه',
        ),
      );
      return;
    }

    CollectionReference collRef =
        FirebaseFirestore.instance.collection('players');

    DocumentReference docRef = collRef.doc();
    await collRef.add({
      'myid': docRef.id,
      'Name': nameController.text,
      'last Name': lastController.text,
      'player Number': playerNumberController.text,
      'player Position': playerpositionController.text,
    }).then((value) {
      showDialog(
          context: context,
          builder: (context) => const CustomDialog(
                isSuccess: true,
                title: '!موفقانه',
                message: '.بازیکن مورد نظر ثبت شد',
                buttonText: '!باشه',
              ));
    }).catchError((error) {
      print("Failed to add user: $error");
      showDialog(
        context: context,
        builder: (context) => const CustomDialog(
          isSuccess: false,
          title: '!متاسفم',
          message: '.بازیکن مورد نظر اضافه نشد',
          buttonText: '!باشه',
        ),
      );
    });
  } catch (err) {
    showDialog(
      context: context,
      builder: (context) => const CustomDialog(
        isSuccess: false,
        title: '!متاسفم',
        message: '.دوباره امتحان کنید',
        buttonText: '!باشه',
      ),
    );
  }

  nameController.clear();
  lastController.clear();
  playerNumberController.clear();
  playerpositionController.clear();
}

Future<void> getAttendanceMethod({
  required List<Map<String, dynamic>> allData,
  required Jalali selectedDate,
  required BuildContext context,
}) async {
  try {
    for (var data in allData) {
      await FirebaseFirestore.instance.collection('Attendance').add({
        'myid': data['myid'],
        'Name': data['Name'],
        'last Name': data['last Name'],
        'isPresent': data['isPresent'],
        'player Number': data['player Number'],
        'player Position': data['player Position'],
        'Date': {
          'year': selectedDate.year,
          'month': selectedDate.month,
          'day': selectedDate.day,
        }, // Store selected Shamsi date
      });
    }
    showDialog(
      context: context,
      builder: (context) => const CustomDialog(
        isSuccess: true,
        title: '!موفقانه انجام شد',
        message: '.حاضری موفقانه ثبت شد',
        buttonText: '!باشه',
      ),
    );
  } catch (error) {
    showDialog(
      context: context,
      builder: (context) => const CustomDialog(
        isSuccess: false,
        title: '!متاسفم',
        message: '.حاضری ثبت نشد',
        buttonText: '!باشه',
      ),
    );
    print("!حاضری ثبت نشد: $error");
  }
}

Future<int> getIsPresentLength() async {
  QuerySnapshot querySnapshot = await attendanceRef.get();
  List<DocumentSnapshot> docs = querySnapshot.docs;
  List<DocumentSnapshot> isPresentDocs = docs.where((doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return data != null && data['isPresent'] == true;
  }).toList();

  return isPresentDocs.length;
}

// Fetch attendance data from Firestore
Future<List<Map<String, dynamic>>> fetchAttendanceData() async {
  QuerySnapshot snapshot = await attendanceRef.get();
  List<Map<String, dynamic>> attendanceData = snapshot.docs.map((doc) {
    return doc.data() as Map<String, dynamic>;
  }).toList();
  return attendanceData;
}

Future<void> deleteUser({
  required String userId,
  required BuildContext context,
}) async {
  try {
    // Find the document where the Name field matches userId
    QuerySnapshot snapshot = await _firestore
        .collection('players')
        .where('Name', isEqualTo: userId)
        .get();

    // Check if any documents were found
    if (snapshot.docs.isNotEmpty) {
      // Loop through the found documents and delete them
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Optionally show a success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User deleted successfully")),
        );
      }
    } else {
      // Handle the case where no matching documents are found
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found with that name")),
        );
      }
    }
  } catch (e) {
    print("Error on delete: $e");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete user: $e")),
      );
    }
  }
}

Future<void> deleteUserAttendanceList({
  required String userId,
  required BuildContext context,
}) async {
  try {
    // Find the document where the Name field matches userId
    QuerySnapshot snapshot = await _firestore
        .collection('Attendance')
        .where('Name', isEqualTo: userId)
        .get();

    // Check if any documents were found
    if (snapshot.docs.isNotEmpty) {
      // Loop through the found documents and delete them
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Optionally show a success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User deleted successfully")),
        );
      }
    } else {
      // Handle the case where no matching documents are found
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found with that name")),
        );
      }
    }
  } catch (e) {
    print("Error on delete: $e");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete user: $e")),
      );
    }
  }
}

Map<String, int> countPresence(List<Map<String, dynamic>> playersData) {
  Map<String, int> presenceCount = {};

  for (var data in playersData) {
    String name = data['Name'];
    bool isPresent = data['isPresent'] ?? false;

    if (isPresent) {
      presenceCount[name] = (presenceCount[name] ?? 0) + 1;
    } else {
      presenceCount.putIfAbsent(name, () => 0);
    }
  }

  return presenceCount;
}

Future<void> editUser({
  required String userId,
  required String name,
  required String lastName,
  required bool isPresent,
  required String playerNumber,
  required String positionNumber,
  required Jalali? selectedDate, // New parameter
  required BuildContext context,
}) async {
  try {
    // Fetch the player's documents in the 'players' collection
    QuerySnapshot snapshot = await _firestore
        .collection('players')
        .where('myid', isEqualTo: userId)
        .get();

    // Fetch and update attendance based on selectedDate
    if (selectedDate != null) {
      QuerySnapshot snapshotAtt = await _firestore
          .collection('Attendance')
          .where('myid', isEqualTo: userId)
          .where('Date.year', isEqualTo: selectedDate.year)
          .where('Date.month', isEqualTo: selectedDate.month)
          .where('Date.day', isEqualTo: selectedDate.day)
          .get();

      for (var doc in snapshotAtt.docs) {
        await doc.reference.update({
          'isPresent': isPresent,
        });
      }
    }

    // Update user data in 'players' collection
    for (var doc in snapshot.docs) {
      await doc.reference.update({
        'Name': name,
        'last Name': lastName,
        'player Number': playerNumber,
        'player Position': positionNumber,
      });
    }

    // Update user name in 'Attendance' collection if the 'myid' matches
    QuerySnapshot attendanceSnapshot = await _firestore
        .collection('Attendance')
        .where('myid', isEqualTo: userId)
        .get();

    for (var doc in attendanceSnapshot.docs) {
      await doc.reference.update({
        'Name': name,
        'last Name': lastName,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User updated successfully")),
    );
  } catch (e) {
    print("Error on update: $e");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update user: $e")),
      );
    }
  }
}

Future<List<Jalali>> fetchAvailableDates(String userId) async {
  List<Jalali> dates = [];
  QuerySnapshot snapshot = await _firestore
      .collection('Attendance')
      .where('myid', isEqualTo: userId)
      .get();

  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final date = data['Date'];
    dates.add(Jalali(date['year'], date['month'], date['day']));
  }

  return dates;
}

// Function to fetch player data for editing
Future<Map<String, dynamic>?> getPlayerData(String userId) async {
  QuerySnapshot snapshot = await _firestore
      .collection('players')
      .where('myid', isEqualTo: userId)
      .get();

  if (snapshot.docs.isNotEmpty) {
    return snapshot.docs.first.data() as Map<String, dynamic>;
  }
  return null;
}

Future<List<Map<String, dynamic>>> presentAndAbsentRecords(
    String playerId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot snapshot = await _firestore
        .collection('Attendance')
        .where('myid', isEqualTo: playerId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> attendanceRecords = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        attendanceRecords.add(data);
      }
      return attendanceRecords;
    } else {
      return [];
    }
  } catch (e) {
    throw Exception('Error retrieving data: $e');
  }
}
