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

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final violationController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final plateNumberController = TextEditingController();
  final addressController = TextEditingController();
  final violationCodeController = TextEditingController();

  LatLng? _coordinates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            createInput(context, 350, hint, controller: controller),
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
      appBar: AppBar(title: Text("Create Incident Report")),
      body: SingleChildScrollView(
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
            createIncidentReport(context, "Record Information", "Violation",
                violationController),
            whiteSpace(30),
            createIncidentReport(
                context, "Offender", "License Number", licenseNumberController),
            whiteSpace(30),
            createIncidentReport(
                context, "Vehicle", "Plate Number", plateNumberController),
            whiteSpace(30),
            createIncidentReport(
                context, "Location", "Address", addressController),
            whiteSpace(30),
            createIncidentReport(
                context, "Violation Code", "Code", violationCodeController),
            whiteSpace(20),
            actionButton(
              context,
              "Submit",
              onPressed: () async {
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
                  }
                };
                await Officer().setRecord(data);
                showToast("Incedent Report Saved");
                restart();
              },
              width: 300,
              height: 60,
              borderRadius: 20,
              color: Color.fromARGB(255, 149, 33, 243),
            )
          ],
        ),
      )),
    );
  }
}
