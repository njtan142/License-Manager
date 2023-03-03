import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:license_manager/firebase/profiles/admin.dart';
import 'package:license_manager/widget_builder.dart';

class AdminViolationsCreate extends StatefulWidget {
  const AdminViolationsCreate({super.key});

  @override
  State<AdminViolationsCreate> createState() => _AdminViolationsCreateState();
}

class _AdminViolationsCreateState extends State<AdminViolationsCreate> {
  final violationInputController = TextEditingController();
  final feeInputController = TextEditingController();

  Future createViolation() async {
    if (!isFormValid()) {
      return;
    }
    showToast("Submitting, please wait");
    var data = {
      "violation": violationInputController.text,
      "fee": feeInputController.text,
    };

    bool success = await Admin().addViolation(data);
    if (success) {
      showToast("Submitted");
      Navigator.pop(context);
    } else {
      showToast("Something went wrong");
    }
  }

  bool isFormValid() {
    String violation = violationInputController.text;
    String fee = feeInputController.text;

    if (violation == "") {
      showToast("Please fill out the form (Violation)");
      return false;
    }

    if (fee == "") {
      showToast("Please fill out the form (Fee)");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Violation Form"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            createInput(context, 300, "Violation",
                controller: violationInputController),
            whiteSpace(15),
            createInput(context, 300, "Fee", controller: feeInputController),
            whiteSpace(20),
            actionButton(context, "Submit",
                width: 300, onPressed: createViolation)
          ],
        ),
      ),
    );
  }
}
