import 'dart:async';
import 'package:flutter/material.dart';
import 'package:license_manager/main/admin/dashboard.dart';
import 'package:license_manager/main/client/dashboard.dart';
import 'package:license_manager/main/officer/dashboard.dart';
import 'package:license_manager/widget_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreDashboard extends StatefulWidget {
  const PreDashboard({super.key});

  @override
  State<PreDashboard> createState() => _PreDashboardState();
}

class _PreDashboardState extends State<PreDashboard> {
  Timer? timer;

  @override
  void initState() {
    setDashboard();
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
      setDashboard();
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Future<void> setDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString("userType");

    if (userType == null) {
      return;
    }

    if (!mounted) {
      return;
    }
    print(userType);

    switch (userType) {
      case "admin":
        replacePage(context, const AdminDashboard());
        timer!.cancel();
        break;
      case "officer":
        replacePage(context, const OfficerDashboard());
        timer!.cancel();
        break;
      case "client":
        replacePage(context, const ClientDashboard());
        timer!.cancel();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
