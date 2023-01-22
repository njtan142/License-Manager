import 'package:flutter/material.dart';
import 'package:license_manager/authentication/admin/login.dart';
import 'package:license_manager/authentication/officer/login.dart';
import 'package:license_manager/authentication/client/login.dart';
import 'package:license_manager/widget_builder.dart';

class AuthTypeChoose extends StatefulWidget {
  const AuthTypeChoose({super.key});

  @override
  State<AuthTypeChoose> createState() => _AuthTypeChooseState();
}

class _AuthTypeChooseState extends State<AuthTypeChoose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("Choose Login Type"),
          actionButton(
            context,
            "Continue as Admin",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminLoginPage()));
            },
          ),
          actionButton(
            context,
            "Continue as Officer",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OfficerLoginPage()));
            },
          ),
          actionButton(
            context,
            "Continue as User/Client",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientLoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
