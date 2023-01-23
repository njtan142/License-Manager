import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:license_manager/firebase/profiles/client.dart';
import 'package:license_manager/main/client/drawer.dart';

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  bool completeProfile = true;

  Future checkProfileComplete() async {
    bool complete = await Client().checkIfProfileIsComplete();
    setState(() {
      completeProfile = complete;
    });
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
              ? Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Your profile is not complete yet"),
                      TextButton(onPressed: () {}, child: Text("Edit profile")),
                    ],
                  ),
                )
              : Container(),
        ],
      )),
    );
  }
}
