import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:license_manager/widget_builder.dart';

class ClientProfileEdit extends StatefulWidget {
  const ClientProfileEdit({super.key});

  @override
  State<ClientProfileEdit> createState() => _ClientProfileEditState();
}

class _ClientProfileEditState extends State<ClientProfileEdit> {
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
            createInput(context, 300, "Name"),
            createInput(context, 300, "Age"),
            createInput(context, 300, "Phone Number"),
            actionButton(context, "Save")
          ],
        )),
      )),
    );
  }
}
