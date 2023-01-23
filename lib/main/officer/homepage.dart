import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:license_manager/firebase/profiles/officer.dart';
import 'package:license_manager/widget_builder.dart';

class OfficerHomePage extends StatefulWidget {
  const OfficerHomePage({super.key});

  @override
  State<OfficerHomePage> createState() => _OfficerHomePageState();
}

class _OfficerHomePageState extends State<OfficerHomePage> {
  int recordCount = 0;
  List<Map<String, dynamic>> recordList = [];

  @override
  void initState() {
    super.initState();
    getRecords();
    Future.delayed(const Duration(seconds: 5), getRecords);
  }

  Future<void> getRecords() async {
    if (!mounted) {
      return;
    }
    List<Map<String, dynamic>> recordListAwait = await Officer().getRecords();
    setState(() {
      recordList = recordListAwait;
      recordCount = recordListAwait.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            width: 330,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.search,
                  color: lightColor,
                  size: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                createInputNoBorder(context, 200, "hintText"),
                Icon(
                  Icons.notifications,
                  color: lightColor,
                ),
                whiteSpace(5),
                ClipOval(
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/mobile-ar-6984e.appspot.com/o/default%20profile%20picture.jpg?alt=media',
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                ),
                whiteSpace(5),
              ],
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: recordCount,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> child = recordList[index];
                print(child);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              child["id"],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text("License Number: "),
                                Text(child["licenseNumber"]),
                              ],
                            ),
                            whiteSpace(5),
                            Row(
                              children: [
                                Text("Date Created: "),
                                Text((child["dateCreated"] as Timestamp)
                                    .toDate()
                                    .toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Last Updated: "),
                                Text((child["lastUpdated"] as Timestamp)
                                    .toDate()
                                    .toString()),
                              ],
                            ),
                            whiteSpace(10),
                            Container(
                              color: Colors.black,
                              height: 2,
                            ),
                            whiteSpace(10),
                            Text(child["violation"])
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
