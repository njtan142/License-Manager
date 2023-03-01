import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:license_manager/firebase/profiles/officer.dart';

import '../../../firebase/profiles/admin.dart';
import '../../../widget_builder.dart';

class OfficerOfficerViewList extends StatefulWidget {
  const OfficerOfficerViewList({super.key});

  @override
  State<OfficerOfficerViewList> createState() => _OfficerOfficerViewListState();
}

class _OfficerOfficerViewListState extends State<OfficerOfficerViewList> {
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
        await Officer().getOfficersData();
    if (!mounted) {
      return;
    }
    setState(() {
      adminList = adminListAwait;
      adminCount = adminListAwait.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: adminCount,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> child = adminList[index];
            return ListTile(
                onTap: () {},
                leading: Stack(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 100, 73, 170),
                    ),
                    Positioned(
                      top: 0,
                      right: 2,
                      child: OnlineStatusIcon(isOnline: child['isOnline']),
                    ),
                  ],
                ),
                title: Text(child["email"]));
          }),
    );
  }
}
