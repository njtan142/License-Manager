import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:license_manager/firebase/profiles/officer.dart';
import 'package:license_manager/main/officer/profile_edit.dart';
import 'package:license_manager/widget_builder.dart';

class OfficerProfile extends StatefulWidget {
  const OfficerProfile({super.key});

  @override
  State<OfficerProfile> createState() => _OfficerProfileState();
}

class _OfficerProfileState extends State<OfficerProfile> {
  final String defaultInfo = "N/A";
  Map<String, dynamic> profileData = {};
  final TextStyle infoTextStyle = TextStyle(fontSize: 20);

  Future getProfile() async {
    Map<String, dynamic>? profile = await Officer().getProfile();
    if (profile == null) {
      return;
    }
    setState(() {
      profileData = profile;
    });
    print(profile);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Officer Profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                whiteSpace(20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      createProfileInfo(
                        context,
                        "Name",
                        profileData["name"] ?? defaultInfo,
                        style: infoTextStyle,
                      ),
                      whiteSpace(10),
                      createProfileInfo(
                        context,
                        "Age",
                        profileData["age"] ?? defaultInfo,
                        style: infoTextStyle,
                      ),
                      whiteSpace(10),
                      createProfileInfo(
                        context,
                        "Email",
                        profileData["email"] ?? defaultInfo,
                        style: infoTextStyle,
                      ),
                      whiteSpace(10),
                      createProfileInfo(
                        context,
                        "Phone Number",
                        profileData["phoneNumber"] ?? defaultInfo,
                        style: infoTextStyle,
                      ),
                      whiteSpace(10),
                      createProfileInfo(
                        context,
                        "Precinct Number",
                        profileData["precinct"] ?? defaultInfo,
                        style: infoTextStyle,
                      ),
                      whiteSpace(10),
                      createProfileInfo(
                        context,
                        "Position",
                        profileData["position"] ?? defaultInfo,
                        style: infoTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToPage(context, OfficerProfileEdit());
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
