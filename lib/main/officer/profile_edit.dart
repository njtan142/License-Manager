import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:license_manager/firebase/profiles/client.dart';
import 'package:license_manager/firebase/profiles/officer.dart';
import 'package:license_manager/main/officer/license_type.dart';
import 'package:license_manager/widget_builder.dart';

import '../../main.dart';

class OfficerProfileEdit extends StatefulWidget {
  const OfficerProfileEdit({super.key});

  @override
  State<OfficerProfileEdit> createState() => _OfficerProfileEditState();
}

class _OfficerProfileEditState extends State<OfficerProfileEdit> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final precinctNumberController = TextEditingController();
  String? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit your profile")),
      body: Center(
          child: SingleChildScrollView(
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            createInput(context, 300, "Name", controller: nameController),
            createInput(context, 300, "Age", controller: ageController),
            createInput(context, 300, "Phone Number",
                controller: phoneNumberController),
            createInput(context, 300, "Precint Number of Barangay",
                controller: precinctNumberController),
            OfficerPositionDropdown(
              onChanged: (value) {
                setState(() {
                  position = value;
                });
              },
            ),
            actionButton(
              context,
              "Save",
              onPressed: () async {
                Map<String, dynamic> data = {
                  "name": nameController.text.trim(),
                  "age": ageController.text.trim(),
                  "phoneNumber": phoneNumberController.text.trim(),
                  "precinct": precinctNumberController.text.trim(),
                  "position": position ?? "N/A"
                };
                await Officer().setProfile(data);
                showToast("Profile saved");
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MyApp()));
              },
            )
          ],
        )),
      )),
    );
  }
}
