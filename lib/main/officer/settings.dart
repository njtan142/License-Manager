import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:license_manager/firebase/auth.dart';
import 'package:license_manager/main/client/profile_edit.dart';
import 'package:license_manager/main/officer/create_report.dart';
import 'package:license_manager/widget_builder.dart';

class ClientSettings extends StatefulWidget {
  const ClientSettings({super.key});

  @override
  State<ClientSettings> createState() => _ClientSettingsState();
}

class _ClientSettingsState extends State<ClientSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              Text(
                "Settings",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5),
              ),
              whiteSpace(100),
              actionButton(
                context,
                "Edit Profile",
                width: 250,
                onPressed: () {
                  goToPage(context, ClientProfileEdit());
                },
              ),
              actionButton(
                context,
                "Create Report",
                width: 250,
                onPressed: () {
                  goToPage(context, CreateReport());
                },
              ),
              actionButton(
                context,
                "Logout",
                width: 250,
                onPressed: () async {
                  bool? confirmed = await showSignOutDialog(context);
                  if (confirmed == null) {
                    return;
                  }
                  if (confirmed) {
                    showToast("Logging out");
                    await Auth().signOut();
                    restart();
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
