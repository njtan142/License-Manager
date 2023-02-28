import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:license_manager/firebase/profiles/officer.dart';
import 'package:license_manager/main/officer/create_report.dart';
import 'package:license_manager/main/officer/view_edit_report.dart';
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
    recordList = [];
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
                createInputNoBorder(context, 200, "Search"),
                Icon(
                  Icons.notifications,
                  color: lightColor,
                ),
                whiteSpace(5),
                ClipOval(
                  child: Image.network(
                    "https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg",
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                ),
                whiteSpace(5),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recordCount,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> report = recordList[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
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
                                      report["code"],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "License Number: ",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          report["offender"],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    whiteSpace(5),
                                    Row(
                                      children: [
                                        Text(
                                          "Plate  Number: ",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(report["vehicle"]),
                                      ],
                                    ),
                                    whiteSpace(5),
                                    Row(
                                      children: [
                                        Text(
                                          "Address: ",
                                        ),
                                        Flexible(
                                          child: Container(
                                            child: Text(
                                              report["location"],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    whiteSpace(10),
                                    Row(
                                      children: [
                                        Text(
                                          "Date Created: ",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          (report["date_created"] as Timestamp)
                                              .toDate()
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Last Updated: ",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          (report["last_updated"] as Timestamp)
                                              .toDate()
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    whiteSpace(10),
                                    Container(
                                      color: Colors.black,
                                      height: 2,
                                    ),
                                    whiteSpace(10),
                                    Text(
                                      report["violation"],
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              showToast(report["id"]);
                              goToPage(
                                  context,
                                  ReportViewAndEdit(
                                    data: report,
                                    onExit: getRecords,
                                  ));
                            },
                          ),
                        ],
                      ),
                      whiteSpace(10),
                    ],
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToPage(context, CreateReport());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
