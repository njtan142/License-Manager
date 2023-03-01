import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:license_manager/firebase/profiles/officer.dart';
import 'package:license_manager/main/officer/map/place_picker.dart';
import 'package:license_manager/widget_builder.dart';
import '../../firebase/database.dart';

class ReportViewAndEdit extends StatefulWidget {
  final void Function() onExit;
  final Map<String, dynamic> data;
  const ReportViewAndEdit(
      {super.key, required this.onExit, required this.data});

  @override
  State<ReportViewAndEdit> createState() => _ReportViewAndEditState();
}

class _ReportViewAndEditState extends State<ReportViewAndEdit> {
  final violationController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final plateNumberController = TextEditingController();
  final addressController = TextEditingController();
  final violationCodeController = TextEditingController();

  LatLng? _coordinates;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    try {
      violationController.text = widget.data["violation"];
      licenseNumberController.text = widget.data["offender"];
      plateNumberController.text = widget.data["vehicle"];
      addressController.text = widget.data["location"];
      violationCodeController.text = widget.data["code"];
      _coordinates = LatLng(widget.data["coordinates"]["latitude"],
          widget.data["coordinates"]["longitude"]);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    widget.onExit();
    super.dispose();
  }

  void editState() {
    setState(() {
      isEditing = true;
    });
  }

  void saveChanges() {
    setState(() {
      isEditing = false;
    });
    saveData();
  }

  void saveData() async {
    var data = {
      "violation": violationController.text.trim(),
      "code": violationCodeController.text.trim(),
      "offender": licenseNumberController.text.trim(),
      "vehicle": plateNumberController.text.trim(),
      "location": addressController.text.trim(),
      "date_created": Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      "last_updated": Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      "coordinates": {
        "latitude": _coordinates?.latitude,
        "longitude": _coordinates?.longitude,
      },
      "id": widget.data["id"],
    };
    await Officer().setRecord(data);
    showToast("Incedent Report Saved");
  }

  Widget createIncidentReport(BuildContext context, String heading, String hint,
      TextEditingController controller) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              heading,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
        whiteSpace(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            createInput(context, 350, hint,
                controller: controller, readonly: !isEditing),
          ],
        )
      ],
    );
  }

  void updateEndLocation(String address, LatLng coordinates) {
    setState(() {
      addressController.text = address;
      _coordinates = coordinates;
    });
  }

  Future<LatLng?> goToPlaceStart({String? address}) async {
    try {
      if (addressController.text == "") {
        return null;
      }
      List<Location> locations =
          await locationFromAddress(addressController.text);
      Location location = locations.first;
      return LatLng(location.latitude, location.longitude);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View/Edit Incident Report")),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Coordinates",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  whiteSpace(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Latitude:",
                                style: const TextStyle(fontSize: 18),
                              ),
                              whiteSpace(10),
                              Text(
                                _coordinates != null
                                    ? _coordinates!.latitude.toStringAsFixed(5)
                                    : "",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Longitude:",
                                style: const TextStyle(fontSize: 18),
                              ),
                              whiteSpace(10),
                              Text(
                                _coordinates != null
                                    ? _coordinates!.longitude.toStringAsFixed(5)
                                    : "",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          )
                        ],
                      ),
                      actionButton(
                        context,
                        "Pick",
                        width: 100,
                        borderRadius: 20,
                        color: Color.fromARGB(255, 149, 33, 243),
                        onPressed: () {
                          goToPage(
                              context,
                              PlacePicker(
                                  stateUpdate: updateEndLocation,
                                  getLocation: goToPlaceStart));
                        },
                      ),
                    ],
                  ),
                  whiteSpace(30),
                  createIncidentReport(context, "Record Information",
                      "Violation", violationController),
                  whiteSpace(30),
                  createIncidentReport(context, "Offender", "License Number",
                      licenseNumberController),
                  whiteSpace(30),
                  createIncidentReport(context, "Vehicle", "Plate Number",
                      plateNumberController),
                  whiteSpace(30),
                  createIncidentReport(
                      context, "Location", "Address", addressController),
                  whiteSpace(30),
                  createIncidentReport(context, "Violation Code", "Code",
                      violationCodeController),
                  whiteSpace(20),
                ],
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  if (!isEditing) {
                    editState();
                  } else {
                    saveChanges();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(), //<-- SEE HERE
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.blue,
                ),
                child: Icon(
                  !isEditing ? Icons.edit : Icons.check,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(!isEditing ? Icons.edit : Icons.check),
      //   onPressed: () {
      //     if (!isEditing) {
      //       editState();
      //     } else {
      //       saveChanges();
      //     }
      //   },
      // ),
    );
  }
}
