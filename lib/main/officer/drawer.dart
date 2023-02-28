import 'package:flutter/material.dart';
import 'package:license_manager/firebase/profiles/officer.dart';
import 'package:license_manager/main.dart';
import 'package:license_manager/widget_builder.dart';

import '../../firebase/auth.dart';

class OfficerDrawer extends StatelessWidget {
  const OfficerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: GestureDetector(
                onTap: () {},
                child: ClipOval(
                  child: Image.network(
                    "https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              accountName: Text(Officer().name),
              accountEmail: Text(Officer().user!.email.toString())),
          Column(
            children: [
              ListTile(
                title: const Text("Signout"),
                onTap: () async {
                  bool? confirmed = await showSignOutDialog(context);
                  if (confirmed == null) {
                    return;
                  }
                  if (!confirmed) {
                    return;
                  }
                  await Auth().signOut();
                  showToast("Signed out");
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const MyApp()));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
