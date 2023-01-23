import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widget_builder.dart';

class LicenseEdit extends StatefulWidget {
  const LicenseEdit({super.key});

  @override
  State<LicenseEdit> createState() => _LicenseEditState();
}

class _LicenseEditState extends State<LicenseEdit> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _imageFile = File(result.files.first.path!);
    });
  }

  Future uploadImage() async {
    if (_imageFile == null) {
      showToast("Select a file first!");
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    Fluttertoast.showToast(
        msg: "Uploading...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    String path = "licenses/" + FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(_imageFile!).then((p0) async {
      showToast("Uploaded, app will restart in 2 seconds");
      await Future.delayed(Duration(seconds: 2));
      restart();
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                color: Color.fromARGB(179, 200, 198, 198),
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
