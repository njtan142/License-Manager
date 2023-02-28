import 'dart:async';

import 'package:flutter/material.dart';
import 'package:license_manager/firebase/profiles/officer.dart';
import 'package:license_manager/main/officer/active_list.dart';
import 'package:license_manager/main/officer/drawer.dart';
import 'package:license_manager/main/officer/homepage.dart';
import 'package:license_manager/main/officer/profile.dart';
import 'package:license_manager/widget_builder.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({super.key});

  @override
  State<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  Timer? activeStatusTimer;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    OfficerHomePage(),
    OfficerProfile(),
    Scaffold(),
    OfficerActiveList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future updateActiveStatus() async {
    await Officer().updateActiveStatus();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateActiveStatus();
    activeStatusTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      updateActiveStatus();
    });
  }

  @override
  void dispose() {
    activeStatusTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        fixedColor: lightColor,
        unselectedItemColor: fadedColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: containerColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              backgroundColor: containerColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_rounded),
              label: "Top List",
              backgroundColor: containerColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: "Active",
              backgroundColor: containerColor),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
