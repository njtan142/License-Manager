import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:license_manager/firebase/profiles/client.dart';
import 'package:license_manager/main/client/drawer.dart';
import 'package:license_manager/main/client/profile_edit.dart';
import 'package:license_manager/widget_builder.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  bool completeProfile = true;
  Timer? locationTimer;

  @override
  void initState() {
    super.initState();
    checkProfileComplete();
    getLocation();
    locationTimer =
        Timer.periodic(const Duration(minutes: 1), (timer) => getLocation());
  }

  Future checkProfileComplete() async {
    bool complete = await Client().checkIfProfileIsComplete();
    print(complete);
    if (!mounted) {
      return;
    }
    setState(() {
      completeProfile = complete;
    });
  }

  Future getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    Client().updateLocation(position.latitude, position.longitude);
  }

  @override
  void dispose() {
    locationTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      drawer: const ClientDrawer(),
      body: Center(
          child: Column(
        children: [
          !completeProfile
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Your profile is not complete yet"),
                          TextButton(
                              onPressed: () {
                                goToPage(context, ClientProfileEdit());
                              },
                              child: Text("Edit profile")),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      )),
    );
  }
}
