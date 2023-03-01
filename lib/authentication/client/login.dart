import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:license_manager/authentication/client/signup.dart';
import 'package:license_manager/widget_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase/auth.dart';
import '../../main.dart';

class ClientLoginPage extends StatefulWidget {
  const ClientLoginPage({super.key});

  @override
  State<ClientLoginPage> createState() => _ClientLoginPageState();
}

class _ClientLoginPageState extends State<ClientLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isClient = false;

  Future checkCredentials(String email, {bool shouldLogin = false}) async {
    email = email.trim();
    print("hello");
    bool isClientAwait = await Auth().checkIfClient(email);
    if (!mounted) {
      return;
    }
    setState(() {
      isClient = isClientAwait;
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
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login as Client",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2),
            ),
            whiteSpace(20),
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
                if (!isClient) {
                  checkCredentials(email.trim(), shouldLogin: true);
                  return 'You are not a client or is still being verified, try again after few seconds';
                }
                return null;
              },
            ),
            whiteSpace(10),
            SizedBox(
                width: 300,
                child: PasswordField(
                    hintText: "Password", controller: passwordController)),
            whiteSpace(15),
            actionButton(
              context,
              "Login",
              width: 250,
              onPressed: login,
            ),
            whiteSpace(5),
            TextButton(
                onPressed: () {
                  goToPage(context, ClientSignInPage());
                },
                child: Text("Create Account")),
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
    await prefs.setString("userType", "client");
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
