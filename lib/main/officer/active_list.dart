import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:license_manager/main/officer/list/client.dart';
import 'package:license_manager/main/officer/list/officer.dart';

import '../../widget_builder.dart';
import 'homepage.dart';
import 'profile.dart';

class OfficerActiveList extends StatefulWidget {
  const OfficerActiveList({super.key});

  @override
  State<OfficerActiveList> createState() => _OfficerActiveListState();
}

class _OfficerActiveListState extends State<OfficerActiveList> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    OfficerClientViewList(),
    OfficerOfficerViewList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget renderClientList(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        fixedColor: lightColor,
        unselectedItemColor: fadedColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Clients",
              backgroundColor: containerColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.badge),
              label: "Officers",
              backgroundColor: containerColor),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
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
              icon: Icon(Icons.person),
              label: "Clients",
              backgroundColor: containerColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.badge),
              label: "Officers",
              backgroundColor: containerColor),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
