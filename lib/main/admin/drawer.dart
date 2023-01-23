import 'package:flutter/material.dart';
import 'package:license_manager/firebase/auth.dart';
import 'package:license_manager/main/admin/admins_view.dart';
import 'package:license_manager/main/admin/clients_view.dart';
import 'package:license_manager/main/admin/officers_view.dart';

import '../../firebase/profiles/admin.dart';
import '../../main.dart';
import '../../widget_builder.dart';

class AdminMenuBar extends StatefulWidget {
  const AdminMenuBar({super.key});

  @override
  State<AdminMenuBar> createState() => _AdminMenuBarState();
}

class _AdminMenuBarState extends State<AdminMenuBar> {
  Future<bool?> _showSignOutDialog() async {
    Future<bool?> didSignOut = showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Sign Out'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    return await didSignOut;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(Admin().name),
              accountEmail: Text(Admin().user!.email.toString())),
          Column(
            children: [
              ListTile(
                title: const Text("Admins"),
                onTap: () {
                  goToPage(context, const AdminManagement());
                },
              ),
              ListTile(
                title: const Text("Officers"),
                onTap: () {
                  goToPage(context, const OfficerManagement());
                },
              ),
              ListTile(
                title: const Text("Clients"),
                onTap: () {
                  goToPage(context, const ClientManagement());
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
