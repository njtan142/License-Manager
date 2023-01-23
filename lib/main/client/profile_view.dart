import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:license_manager/firebase/profiles/client.dart';
import 'package:license_manager/main/client/profile_edit.dart';

import '../../widget_builder.dart';

TextStyle infoTextStyle = const TextStyle(fontSize: 18);

class ClientProfileView extends StatefulWidget {
  const ClientProfileView({super.key});

  @override
  State<ClientProfileView> createState() => _ClientProfileViewState();
}

class _ClientProfileViewState extends State<ClientProfileView> {
  String name = "N/A";
  String age = "N/A";
  String phoneNumber = "N/A";
  String email = Client().user!.email!;
  String? photoURL;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    Map<String, dynamic>? userData = await Client().getProfile();
    if (userData == null) {
      return;
    }
    Map<String, dynamic> address = userData["address"] ?? {};
    if (!mounted) {
      return;
    }
    setState(() {
      name = userData["name"] ?? name;
      age = userData["age"] ?? age;
      phoneNumber = userData["phoneNumber"] ?? phoneNumber;
      photoURL = userData["license"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: ClipOval(
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/mobile-ar-6984e.appspot.com/o/default%20profile%20picture.jpg?alt=media',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  createProfileInfo(context, "Name", name,
                      style: infoTextStyle),
                  const SizedBox(
                    height: 10,
                  ),
                  createProfileInfo(context, "Age", age, style: infoTextStyle),
                  const SizedBox(
                    height: 10,
                  ),
                  createProfileInfo(context, "Phone Number", phoneNumber,
                      style: infoTextStyle),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "License",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            photoURL != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        photoURL!,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          replacePage(context, ClientProfileEdit());
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
