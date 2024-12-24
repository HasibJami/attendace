import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:sorkhposhan/constants/constants.dart';
import 'package:sorkhposhan/services/auth.dart';
import 'package:sorkhposhan/views/player/players.dart';

class CheckAttendance extends StatefulWidget {
  const CheckAttendance({super.key});

  @override
  State<CheckAttendance> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<CheckAttendance> {
  // Store the ancestor context safely
  BuildContext? ancestorContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ancestorContext = context;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchAttendanceData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Map<String, dynamic>> playersData = snapshot.data ?? [];
              Map<String, int> presenceCount = countPresence(playersData);

              return ListView.builder(
                itemCount: presenceCount.length,
                itemBuilder: (context, index) {
                  String name = presenceCount.keys.elementAt(index);
                  int count = presenceCount[name] ?? 0;
                  final lastName = playersData.firstWhere(
                    (player) => player['Name'] == name,
                    orElse: () => <String, dynamic>{},
                  )['last Name'] as String?;
                  return Card(
                    color: Colors.white,
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              // Fetch player data for editing
                              final player = playersData.firstWhere(
                                  (player) => player['Name'] == name);
                              print(player['Name']);
                              showEditDialog(context, player);
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Directionality(
                                      textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      title: Text('تایید حذف اطلاعات',),
                                      content: Text('آیا میخواهید این اطلاعات را حدف کنید'),
                                      actions: [
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: TextButton(
                                            onPressed: () {
                                              // Delete from attendance list
                                              setState(() {
                                                deleteUserAttendanceList(userId: name, context: context);
                                                Navigator.of(context).pop();
                                              });

                                            },
                                            child: Text('حذف از لست حاضری'),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              // Delete from players
                                              deleteUser(userId: name, context: context);
                                              Navigator.of(context).pop();
                                            });// Close the dialog
                                          },
                                          child: Text('حدف از لست بازیکنان'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              // Delete from players
                                              deleteUser(userId: name, context: context);
                                              Navigator.of(context).pop();
                                            });// Close the dialog
                                          },
                                          child: Text('حدف هر دو'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Cancel and close the dialog
                                          },
                                          child: Text('لغو'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: deepBlue,
                            child: Text(
                              '$count',
                              style: TextStyle(color: white),
                            ),
                          ),
                          title: Text("$name $lastName"),
                          onTap: () {
                            final playerName = playersData.firstWhere(
                              (player) => player['Name'] == name,
                              orElse: () => <String, dynamic>{},
                            )['myid'] as String?;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Players(id: playerName as String)));
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void showEditDialog(BuildContext context, Map<String, dynamic> player) {
    // Initialize controllers with player data
    nameController.text = player['Name'] ?? '';
    lastController.text = player['last Name'] ?? '';
    playerNumberController.text = player['player Number'] ?? '';
    playerpositionController.text = player['player Position'] ?? '';
    isPresentValue = player['isPresent'] ? 'حاضر' : 'غیر حاضر';
    Jalali? selectedAttendanceDate;

    // Fetch available dates for the player
    Future<List<Jalali>> availableDates = fetchAvailableDates(player['myid']);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Player'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: lastController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  DropdownButtonFormField<String>(
                    value: isPresentValue,
                    items: const [
                      DropdownMenuItem(value: 'حاضر', child: Text('حاضر')),
                      DropdownMenuItem(
                          value: 'غیر حاضر', child: Text('غیر حاضر')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        isPresentValue = value!;
                      });
                    },
                    decoration:
                        const InputDecoration(labelText: 'Attendance Status'),
                  ),
                  TextFormField(
                    controller: playerNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Player Number'),
                  ),
                  TextFormField(
                    controller: playerpositionController,
                    decoration:
                        const InputDecoration(labelText: 'Player Position'),
                  ),
                  FutureBuilder<List<Jalali>>(
                    future: availableDates,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error loading dates');
                      } else {
                        List<Jalali> dates = snapshot.data!;
                        return DropdownButtonFormField<Jalali>(
                          value: selectedAttendanceDate,
                          items: dates.map((date) {
                            return DropdownMenuItem(
                              value: date,
                              child: Text(date.formatFullDate()),
                            );
                          }).toList(),
                          onChanged: (Jalali? newDate) {
                            setState(() {
                              selectedAttendanceDate = newDate;
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Select Date'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Update user with new data and selected attendance date
                editUser(
                  userId: player['myid'],
                  name: nameController.text,
                  lastName: lastController.text,
                  isPresent: isPresentValue == 'حاضر',
                  playerNumber: playerNumberController.text,
                  positionNumber: playerpositionController.text,
                  context: context,
                  selectedDate: selectedAttendanceDate, // Pass selected date
                );

                // Clear fields after editing
                nameController.clear();
                lastController.clear();
                playerNumberController.clear();
                playerpositionController.clear();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
