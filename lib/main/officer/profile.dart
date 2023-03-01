import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String? photoURL;
  final TextStyle infoTextStyle = TextStyle(fontSize: 20);
  final imagePicker = ImagePicker();

  Future getProfile() async {
    Map<String, dynamic>? profile = await Officer().getProfile();

    if (profile == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      photoURL = profile["license"];
      profileData = profile;
    });
    print(profile);
  }

  Future captureImage() async {
    try {
      final image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image == null) {
        showToast("Operation Cancelled");
      }
      uploadImage(File(image!.path));
    } catch (e) {
      print(e);
      showToast(e.toString());
    }
  }

  Future takeImage() async {
    try {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        showToast("Operation Cancelled");
      }
      uploadImage(File(image!.path));
    } catch (e) {
      print(e);
      showToast(e.toString());
    }
  }

  Future uploadImage(File image) async {
    if (image == null) {
      showToast("Select a file first!");
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    showToast("Uploading...");

    String path = "licenses/" + FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref().child(path);

    ref.putFile(image).then((result) async {
      showToast("Uploaded, app will restart in 2 seconds");
      await Future.delayed(Duration(seconds: 2));
      String url = await ref.getDownloadURL();
      Map<String, dynamic> data = {
        "license": url,
      };
      await Officer().setProfile(data);
      restart();
    }).catchError((e) {
      showToast(e.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  void uploadDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            return true;
          },
          child: AlertDialog(
            backgroundColor: Color.fromARGB(255, 50, 45, 71),
            content: Text(
              message,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Column(
                children: [
                  actionButton(
                    context,
                    "Take a picture",
                    width: 200,
                    onPressed: captureImage,
                  ),
                  actionButton(
                    context,
                    "Pick from gallery",
                    width: 200,
                    onPressed: takeImage,
                  ),
                  actionButton(
                    context,
                    "Cancel",
                    width: 200,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
                      whiteSpace(10),
                      Container(
                        width: 400,
                        height: 300,
                        child: Stack(
                          children: [
                            if (photoURL != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      uploadDialog(context, "Change photo");
                                    },
                                    child: Image.network(
                                      photoURL!,
                                      width: 350,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Container(
                                width: 400,
                                height: 300,
                                alignment: AlignmentDirectional.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "You have not yet uploaded your license",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    whiteSpace(20),
                                    actionButton(
                                      context,
                                      "Upload License",
                                      onPressed: () {
                                        uploadDialog(context, "Upload a photo");
                                      },
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                      whiteSpace(60),
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
