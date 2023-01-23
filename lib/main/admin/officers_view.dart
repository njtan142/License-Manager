import 'package:flutter/material.dart';
import 'package:license_manager/main/admin/create_admin.dart';
import 'package:license_manager/main/admin/create_officer.dart';
import '../../firebase/profiles/admin.dart';
import '../../widget_builder.dart';

class OfficerManagement extends StatefulWidget {
  const OfficerManagement({super.key});

  @override
  State<OfficerManagement> createState() => _OfficerManagementState();
}

class _OfficerManagementState extends State<OfficerManagement> {
  int adminCount = 0;
  List<Map<String, dynamic>> adminList = [];

  @override
  void initState() {
    super.initState();
    getOfficers();
    Future.delayed(const Duration(seconds: 5), getOfficers);
  }

  Future<void> getOfficers() async {
    if (!mounted) {
      return;
    }
    List<Map<String, dynamic>> adminListAwait = await Admin().getOfficersData();
    setState(() {
      adminList = adminListAwait;
      adminCount = adminListAwait.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Officer Management"),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: adminCount,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> child = adminList[index];
            return ListTile(
                onTap: () {},
                leading: Stack(
                  children: [
                    Icon(Icons.person),
                  ],
                ),
                title: Text(child["email"]));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToPage(context, const OfficerCreateForm());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
