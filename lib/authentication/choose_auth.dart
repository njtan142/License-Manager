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
      body: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  actionButton(
                    textsize: 18,
                    fontWeight: FontWeight.bold,
                    width: 300,
                    height: 50,
                    context,
                    "Continue as Admin",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminLoginPage()));
                    },
                    borderRadius: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  actionButton(
                    textsize: 18,
                    fontWeight: FontWeight.bold,
                    width: 300,
                    height: 50,
                    context,
                    "Continue as Officer",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OfficerLoginPage()));
                    },
                    borderRadius: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  actionButton(
                    textsize: 18,
                    fontWeight: FontWeight.bold,
                    width: 300,
                    height: 50,
                    context,
                    "Continue as Client",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ClientLoginPage()));
                    },
                    borderRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
