import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../firebase/database.dart';

class ViolationsPage extends StatefulWidget {
  const ViolationsPage({super.key});

  @override
  State<ViolationsPage> createState() => _ViolationsPageState();
}

class _ViolationsPageState extends State<ViolationsPage> {
  List<Map<String, dynamic>> violations = [];

  @override
  void initState() {
    super.initState();
    getViolations();
  }

  Future getViolations() async {
    String path = "violations";
    List<QueryDocumentSnapshot<Map<String, dynamic>>> collectionList =
        await Database().getDocs(path);

    List<Map<String, dynamic>> violationList = [];
    await Future.forEach(collectionList, (violationSnapshot) async {
      violationList.add(violationSnapshot.data());
    });

    if (mounted) {
      setState(() {
        violations = violationList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Violations'),
      ),
      body: ListView.builder(
        itemCount: violations.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(violations[index]['violation']),
                subtitle: Text('Fee: \$${violations[index]['fee']}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
