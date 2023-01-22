import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:license_manager/authentication/client/signup.dart';
import 'package:license_manager/widget_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase/auth.dart';

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
    bool isClientAwait = await Auth().checkIfClient(email);
    if (!mounted) {
      return;
    }
    setState(() {
      isClient = isClientAwait;
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
            const Text("Login as Client"),
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
            PasswordField(hintText: "Password", controller: passwordController),
            actionButton(
              context,
              "Login",
              onPressed: login,
            ),
            actionButton(
              context,
              "Sign Up",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClientSignInPage()));
              },
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
    prefs.setString("userType", "client");
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
      restart();
    } else {
      if (!mounted) {
        return;
      }
      showAlert(context, result);
    }
  }
}
