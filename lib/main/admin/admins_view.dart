import 'package:flutter/material.dart';
import 'package:license_manager/main/admin/create_admin.dart';
import '../../firebase/profiles/admin.dart';
import '../../widget_builder.dart';

class AdminManagement extends StatefulWidget {
  const AdminManagement({super.key});

  @override
  State<AdminManagement> createState() => _AdminManagementState();
}

class _AdminManagementState extends State<AdminManagement> {
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
    List<Map<String, dynamic>> adminListAwait = await Admin().getAdminsData();
    setState(() {
      adminList = adminListAwait;
      adminCount = adminListAwait.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Management"),
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
          goToPage(context, const AdminCreateForm());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
