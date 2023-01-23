import 'dart:async';
import 'package:flutter/material.dart';
import 'package:license_manager/main/admin/officers_view.dart';

import '../../firebase/profiles/admin.dart';
import '../../widget_builder.dart';
import 'clients_view.dart';
import 'drawer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int parentCount = 0;
  int childCount = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initializeCountValues();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      initializeCountValues();
      Admin().updateActiveStatus();
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Future<void> initializeCountValues() async {
    int parentCountAwait = await Admin().getOfficerCount();
    int childCountAwait = await Admin().getClientCount();
    if (!mounted) {
      return;
    }
    setState(() {
      parentCount = parentCountAwait;
      childCount = childCountAwait;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      drawer: const AdminMenuBar(),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  goToPage(context, OfficerManagement());
                },
                child: CountOverview(
                    detail: "Officer Users: ", count: parentCount)),
            GestureDetector(
                onTap: () {
                  goToPage(context, const ClientManagement());
                },
                child:
                    CountOverview(detail: "Client Users: ", count: childCount)),
          ],
        ),
      ),
    );
  }
}
