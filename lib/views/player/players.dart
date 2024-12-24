import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sorkhposhan/constants/constants.dart';
import 'package:sorkhposhan/services/auth.dart';
import 'package:sorkhposhan/views/widgets/custom_app_bar.dart';

class Players extends StatefulWidget {
  final String id;

  const Players({super.key, required this.id});

  @override
  State<Players> createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  late Future<List<Map<String, dynamic>>> presentAbsentData;

  @override
  void initState() {
    super.initState();
    // Call the function and store the result in the future
    presentAbsentData = presentAndAbsentRecords(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Custom_app_bar(
          title: "تعداد روز های حضور و غیاب",
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              // Use FutureBuilder to display the attendance data
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: presentAbsentData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Show loading indicator while waiting
                  } else if (snapshot.hasError) {
                    return const Text('Error loading data'); // Handle errors
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Display each attendance record with an icon
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var record = snapshot.data![index];
                        bool isPresent = record['isPresent'] == true;
                        var date = record['Date'];

                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              trailing: Image.asset(
                                isPresent
                                    ? 'assets/icons/check.png'
                                    : 'assets/icons/close.png',
                                width: 32,
                                height: 32,
                              ),
                              title: Text(
                                '${date['day']},${date['month']},${date['year']}',
                                style: TextStyle(
                                  color: isPresent ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No attendance data available');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
