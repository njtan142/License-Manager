import 'package:flutter/material.dart';
import '../../firebase/profiles/officer.dart';
import 'dart:collection';

class OfficerTopList extends StatefulWidget {
  const OfficerTopList({super.key});

  @override
  State<OfficerTopList> createState() => _OfficerTopListState();
}

class _OfficerTopListState extends State<OfficerTopList> {
  List<Map<String, dynamic>> recordList = [];
  Map<String, int> offenderRecords = {};
  bool showTopViolations = false;

  @override
  void initState() {
    super.initState();
    getRecords();
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
      offenderRecords = groupByOffender(recordList);
      sortRecordList();
    });
  }

  void sortRecordList() {
    recordList.sort((a, b) {
      var feeA = a['fee'] ?? 0;
      var feeB = b['fee'] ?? 0;
      return feeB.compareTo(feeA);
    });
  }

  Map<String, int> groupByOffender(List<Map<String, dynamic>> records) {
    var groupByOffender = SplayTreeMap<String, int>();
    for (var record in records) {
      var offender = record['offender'] as String;
      groupByOffender.update(offender, (value) => value + 1, ifAbsent: () => 1);
    }
    return groupByOffender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 20),
        child: Column(
          children: [
            GestureDetector(
              child: Text(
                showTopViolations ? 'Top Violations' : 'Violators',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
              onTap: () {
                setState(() {
                  showTopViolations = !showTopViolations;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20),
                itemCount: showTopViolations
                    ? recordList.length
                    : offenderRecords.length,
                itemBuilder: (context, index) {
                  if (showTopViolations) {
                    var record = recordList[index];
                    return ListTile(
                      title: Text(
                          record['offender'] + "  |  " + record["violation"]),
                      trailing: Text('\$${record['fee'] ?? 0}'),
                    );
                  } else {
                    var offender = offenderRecords.keys.elementAt(index);
                    var records = offenderRecords[offender];
                    return ListTile(
                      title: Text(offender),
                      trailing: Text('$records records'),
                    );
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
