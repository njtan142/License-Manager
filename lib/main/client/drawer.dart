import 'package:flutter/material.dart';
import 'package:license_manager/firebase/profiles/client.dart';
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
                onTap: () {
                  Navigator.pushNamed(context, "/dashboard/profile_child");
                },
                child: ClipOval(
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/mobile-ar-6984e.appspot.com/o/default%20profile%20picture.jpg?alt=media',
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
                  Navigator.pushNamed(context, "/dashboard/profile_child");
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
                  Auth().signOut().then((value) =>
                      Navigator.pushReplacementNamed(context, "/home"));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
