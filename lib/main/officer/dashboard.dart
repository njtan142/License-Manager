import 'package:flutter/material.dart';
import 'package:license_manager/main/client/drawer.dart';
import 'package:license_manager/main/officer/drawer.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({super.key});

  @override
  State<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      drawer: const OfficerDrawer(),
      body: Center(
          child: Column(
        children: [],
      )),
    );
  }
}
