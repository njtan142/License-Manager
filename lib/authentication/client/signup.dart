import 'package:flutter/material.dart';
import 'package:license_manager/authentication/client/login.dart';
import 'package:license_manager/firebase/auth.dart';
import 'package:license_manager/firebase/profiles/client.dart';
import 'package:license_manager/widget_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientSignInPage extends StatefulWidget {
  const ClientSignInPage({super.key});

  @override
  State<ClientSignInPage> createState() => _ClientSignInPageState();
}

class _ClientSignInPageState extends State<ClientSignInPage> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Create Client Account"),
            createInput(
              context,
              300,
              "Email",
              controller: emailController,
              validator: (email) {
                if (email == null || email.isEmpty) {
                  return "Email is empty";
                }
                if (!emailValidationExpression.hasMatch(email)) {
                  return '\u26A0 Email is empty';
                }
                return null;
              },
            ),
            SizedBox(
                width: 300,
                child: PasswordField(
                    hintText: "Password", controller: passwordController)),
            actionButton(context, "Sign Up", onPressed: signUp),
            actionButton(
              context,
              "Login",
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )),
      ),
    );
  }

  Future signUp() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    showToast("Sign in up... Please wait");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userType", "client");
    // create the data
    Map<String, dynamic> data = {
      "email": emailController.text.trim(),
    };
    await Client().setProfile(data, email: emailController.text);
    String result = await Auth().createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    if (result == "Success") {
      showToast("Sign up success");
      restart();
    } else {
      if (!mounted) {
        return;
      }
      showAlert(context, result);
    }
  }
}
