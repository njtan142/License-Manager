import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:license_manager/widget_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase/auth.dart';

class OfficerLoginPage extends StatefulWidget {
  const OfficerLoginPage({super.key});

  @override
  State<OfficerLoginPage> createState() => _OfficerLoginPageState();
}

class _OfficerLoginPageState extends State<OfficerLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isOfficer = false;

  Future checkCredentials(String email, {bool shouldLogin = false}) async {
    email = email.trim();
    bool isOfficerAwait = await Auth().checkIfOfficer(email);
    if (!mounted) {
      return;
    }
    setState(() {
      isOfficer = isOfficerAwait;
    });
    if (_formKey.currentState!.validate() && shouldLogin) {
      login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login as Officer"),
            createInput(
              context,
              300,
              "Email",
              controller: emailController,
              onChanged: (email) {
                checkCredentials(email.trim());
              },
              validator: (email) {
                if (email == null || email.isEmpty) {
                  return "Email is empty";
                }
                if (!emailValidationExpression.hasMatch(email)) {
                  return '\u26A0 Email is empty';
                }
                if (!isOfficer) {
                  checkCredentials(email.trim(), shouldLogin: true);
                  return 'You are not an officer or is still being verified, try again after few seconds';
                }
                return null;
              },
            ),
            PasswordField(hintText: "Password", controller: passwordController),
            actionButton(
              context,
              "Login",
              onPressed: login,
            ),
          ],
        )),
      ),
    );
  }

  Future login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userType", "officer");
    String result = await Auth().signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    if (result == "Success") {
      Fluttertoast.showToast(
          msg: "Login success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (!mounted) {
        return;
      }
      showAlert(context, result);
    }
  }
}
