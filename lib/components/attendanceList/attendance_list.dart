import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sorkhposhan/constants/constants.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class AttendanceList extends StatefulWidget {
  final List<Map<String, dynamic>> allData;
  final Function(List<Map<String, dynamic>>) updateData;

  const AttendanceList({
    Key? key,
    required this.allData,
    required this.updateData,
  }) : super(key: key);

  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  late List<Map<String, dynamic>> updatedData;
  final _equality = const DeepCollectionEquality();

  @override
  void initState() {
    super.initState();
    updatedData = List.from(widget.allData);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('players').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> newData =
              snapshot.data?.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    data['isPresent'] = data['isPresent'] ?? true;
                    data['id'] = document.id;
                    return data;
                  }).toList() ??
                  [];
          if (!_equality.equals(newData, updatedData)) {
            updatedData = List.from(newData);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.updateData(List.from(updatedData));
            });
          }

          return ListView(
            children: updatedData.map((data) {
              return Card(
                color: lightBlue,
                child: ListTile(
                  trailing: CircleAvatar(
                    backgroundColor: deepBlue,
                    child: Text(
                      "${data['player Number']}",
                      style: TextStyle(color: white),
                    ),
                  ),
                  leading: Switch(
                    onChanged: (val) {
                      setState(() {
                        int index = updatedData
                            .indexWhere((item) => item['id'] == data['id']);
                        updatedData[index] = {...data, 'isPresent': val};

                        FirebaseFirestore.instance
                            .collection('players')
                            .doc(data['id'])
                            .update({'isPresent': val});

                        widget.updateData(List.from(updatedData));
                      });
                    },
                    value: data['isPresent'] ?? true,
                    inactiveTrackColor: Colors.red,
                    activeTrackColor: deepBlue,
                    trackOutlineWidth: WidgetStatePropertyAll(0),
                    thumbColor: WidgetStatePropertyAll(Colors.white),
                    thumbIcon: WidgetStatePropertyAll(
                      Icon(
                        data['isPresent'] == true ? Icons.check : Icons.close,
                        size: 20,
                        color: data['isPresent'] == true
                            ? Colors.black
                            : Colors.red,
                      ),
                    ),
                  ),
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${data['Name']} ${data['last Name']}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
