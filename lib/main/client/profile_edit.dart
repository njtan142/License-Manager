import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:license_manager/firebase/profiles/client.dart';
import 'package:license_manager/widget_builder.dart';

import '../../main.dart';

class ClientProfileEdit extends StatefulWidget {
  const ClientProfileEdit({super.key});

  @override
  State<ClientProfileEdit> createState() => _ClientProfileEditState();
}

class _ClientProfileEditState extends State<ClientProfileEdit> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneNumberController = TextEditingController();

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
            actionButton(
              context,
              "Save",
              onPressed: () async {
                Map<String, dynamic> data = {
                  "name": nameController.text.trim(),
                  "age": ageController.text.trim(),
                  "phoneNumber": phoneNumberController.text.trim()
                };
                await Client().setProfile(data);
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
