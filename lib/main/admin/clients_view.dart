import 'package:flutter/material.dart';
import 'package:license_manager/main/admin/create_admin.dart';
import '../../firebase/profiles/admin.dart';
import '../../widget_builder.dart';

class ClientManagement extends StatefulWidget {
  const ClientManagement({super.key});

  @override
  State<ClientManagement> createState() => _ClientManagementState();
}

class _ClientManagementState extends State<ClientManagement> {
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
    List<Map<String, dynamic>> adminListAwait = await Admin().getClientData();
    setState(() {
      adminList = adminListAwait;
      adminCount = adminListAwait.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Management"),
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
