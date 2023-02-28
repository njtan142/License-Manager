import 'package:flutter/material.dart';
import 'package:license_manager/firebase/profiles/client.dart';
import 'package:license_manager/main.dart';
import 'package:license_manager/main/client/driver_license_upload.dart';
import 'package:license_manager/main/client/profile_view.dart';
import 'package:license_manager/main/client/violations_view.dart';
import 'package:license_manager/widget_builder.dart';

import '../../firebase/auth.dart';

class ClientDrawer extends StatelessWidget {
  const ClientDrawer({super.key});

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
              accountName: Text(Client().name),
              accountEmail: Text(Client().user!.email.toString())),
          Column(
            children: [
              ListTile(
                title: const Text("View Profile"),
                onTap: () async {
                  goToPage(context, ClientProfileView());
                },
              ),
              ListTile(
                title: const Text("Upload License"),
                onTap: () async {
                  goToPage(context, LicenseEdit());
                },
              ),
              ListTile(
                title: const Text("View Violations"),
                onTap: () async {
                  goToPage(context, ViolationsPage());
                },
              ),
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
                  await Client().updateActiveStatus();
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
