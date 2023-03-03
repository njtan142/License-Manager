import 'package:flutter/material.dart';
import 'package:license_manager/main/admin/violations_create.dart';
import 'package:license_manager/widget_builder.dart';
import '../../firebase/profiles/admin.dart';

class AdminViolationsManagement extends StatefulWidget {
  const AdminViolationsManagement({super.key});

  @override
  State<AdminViolationsManagement> createState() =>
      _AdminViolationsManagementState();
}

class _AdminViolationsManagementState extends State<AdminViolationsManagement> {
  int adminCount = 0;
  List<Map<String, dynamic>> adminList = [];

  @override
  void initState() {
    super.initState();
    getAdmins();
    Future.delayed(const Duration(seconds: 5), getAdmins);
  }

  Future<void> getAdmins() async {
    if (!mounted) {
      return;
    }
    List<Map<String, dynamic>> adminListAwait =
        await Admin().getViolationList();
    setState(() {
      adminList = adminListAwait;
      adminCount = adminListAwait.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Violations"),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: adminCount,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> child = adminList[index];
            return ListTile(
              onTap: () {},
              title: Text(child["violation"]),
              trailing: Text("₱ ${child["fee"]}"),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToPage(context, AdminViolationsCreate());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
