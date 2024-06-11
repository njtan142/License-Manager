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
  List<Map<String, dynamic>> _filteredList = [];

  final searchInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getRecords();
    Future.delayed(const Duration(seconds: 2), getRecords);
    Future.delayed(const Duration(seconds: 5), filterBySearch);
  }

  Future<void> getRecords() async {
    if (!mounted) {
      return;
    }
    recordList = [];
    List<Map<String, dynamic>> recordListAwait = await Officer().getRecords();
    if (!mounted) {
      return;
    }
    setState(() {
      recordList = recordListAwait;
      recordCount = recordListAwait.length;
    });
  }

  Future filterBySearch() async {
    String search = searchInputController.text;
    List<Map<String, dynamic>> filteredList = [];
    if (search == "" || recordList.isEmpty) {
      setState(() {
        _filteredList = recordList;
      });
      return;
    }

    for (Map<String, dynamic> record in recordList) {
      for (dynamic value in record.values) {
        if (value is String) {
          if (value.toLowerCase().contains(search.toLowerCase())) {
            filteredList.add(record);
            break;
          }
        }
        // Perform other operations on non-string values
      }
      // Perform other operations on the record
    }

    setState(() {
      _filteredList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
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
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.search,
                      color: lightColor,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    createInputNoBorder(
                      context,
                      200,
                      "Search",
                      controller: searchInputController,
                      onChanged: (value) {
                        print(value);
                        filterBySearch();
                      },
                    ),
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
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(index);
                      Map<String, dynamic> report = _filteredList[index];
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          report["code"],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
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
                                            const Text(
                                              "Plate  Number: ",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(report["vehicle"]),
                                          ],
                                        ),
                                        whiteSpace(5),
                                        Row(
                                          children: [
                                            const Text(
                                              "Address: ",
                                            ),
                                            Flexible(
                                              child: Container(
                                                child: Text(
                                                  report["location"],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        whiteSpace(10),
                                        Row(
                                          children: [
                                            const Text(
                                              "Date Created: ",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              (report["date_created"]
                                                      as Timestamp)
                                                  .toDate()
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Last Updated: ",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              (report["last_updated"]
                                                      as Timestamp)
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
                                  // showToast(report["id"]);
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
              )
            ],
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  goToPage(context, CreateReport());
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(), //<-- SEE HERE
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.blue,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
