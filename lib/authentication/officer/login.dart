import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:license_manager/authentication/client/signup.dart';
import 'package:license_manager/widget_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase/auth.dart';
import '../../main.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future checkCredentials(String email, {bool shouldLogin = false}) async {
    email = email.trim();
    print("hello");
    bool isClientAwait = await Auth().checkIfOfficer(email);
    if (!mounted) {
      return;
    }
    setState(() {
      isOfficer = isClientAwait;
    });
    if (shouldLogin) {
      if (_formKey.currentState!.validate()) {
        login();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
            child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: const Text(
                  "Hello, Officer!",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: containerColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        SizedBox(height: 10),
                        SizedBox(
                            width: 300,
                            child: PasswordField(
                                hintText: "Password",
                                controller: passwordController)),
                        SizedBox(height: 30),
                        actionButton(
                            width: 300,
                            height: 50,
                            context,
                            "Login",
                            onPressed: login,
                            borderRadius: 20),
                      ],
                    ),
                  ),
                ),
              ),
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
    await prefs.setString("userType", "officer");
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
      Navigator.pop(context);
    } else {
      if (!mounted) {
        return;
      }
      showAlert(context, result);
    }
  }
}
