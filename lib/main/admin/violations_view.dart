import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AdminViolationsManagement extends StatefulWidget {
  const AdminViolationsManagement({super.key});

  @override
  State<AdminViolationsManagement> createState() =>
      _AdminViolationsManagementState();
}

class _AdminViolationsManagementState extends State<AdminViolationsManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Violations"),
      ),
      body: SingleChildScrollView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
