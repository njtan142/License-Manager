import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

import 'map_functions.dart';

class PlacePicker extends StatefulWidget {
  final void Function(String, LatLng) stateUpdate;
  final Future<LatLng?> Function({String? address}) getLocation;

  const PlacePicker(
      {super.key, required this.stateUpdate, required this.getLocation});
  @override
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  LatLng? _pickedLocation;
  Set<Marker> markers = Set<Marker>();
  GoogleMapController? controller;

  void _selectLocation(LatLng position) async {
    setState(() {
      _pickedLocation = position;
    });
    Marker marker = Marker(
      markerId: MarkerId('Your location'),
      position: position,
    );
    markers.add(marker);
    String? placeId = await getPlaceID(position);
    if (placeId == null) {
      return;
    }
    PlaceInfo? placeInfo = await getPlaceInfo(placeId);
    if (placeInfo != null) {
      widget.stateUpdate(placeInfo.address, position);
      Fluttertoast.showToast(
          msg: "Selected " + placeInfo.address,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future goToPlace({bool isLocation = false}) async {
    if (controller == null) {
      return;
    }
    Fluttertoast.showToast(
        msg: "Getting your current location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    LocationData? locationdata =
        isLocation ? await MapFunctions().getCurrentLocation() : null;
    LatLng? targetPosition = !isLocation
        ? await widget.getLocation()
        : LatLng(locationdata!.latitude!, locationdata.longitude!);
    if (targetPosition == null) {
      return;
    }
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
        CameraPosition(target: targetPosition, zoom: 15));
    controller!.animateCamera(cameraUpdate);
    print(targetPosition);
    Marker marker = Marker(
      markerId: MarkerId('Your location'),
      position: targetPosition,
    );
    setState(() {
      markers.add(marker);
    });
    _selectLocation(targetPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place Picker"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.422, -122.084),
              zoom: 17.0,
            ),
            onTap: _selectLocation,
            markers: markers,
            onMapCreated: (controller) {
              setState(() {
                this.controller = controller;
              });
              goToPlace();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(62, 154, 171, 1),
        onPressed: () {
          goToPlace(isLocation: true);
        },
        child: Icon(Icons.gps_fixed),
      ),
    );
  }
}

class PlaceInfo {
  final String name;
  final String address;

  PlaceInfo({required this.name, required this.address});

  factory PlaceInfo.fromJson(Map<String, dynamic> json) {
    return PlaceInfo(
      name: json['name'],
      address: json['formatted_address'],
    );
  }
}

Future<String?> getPlaceID(LatLng location) async {
  final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
      'types=establishment&rankby=distance'
      '&location=${location.latitude},${location.longitude}'
      '&key=AIzaSyA036peXUIQNZBVdCKs6n3Ymin6K8OLenQ';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = convert.jsonDecode(response.body);
    final results = data['results'][0];
    if (results.length > 0) {
      return results["place_id"];
    } else {
      return null;
    }
  } else {
    return null;
  }
}

Future<PlaceInfo> getPlaceInfo(String placeId) async {
  final url = 'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId'
      '&key=AIzaSyA036peXUIQNZBVdCKs6n3Ymin6K8OLenQ';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = convert.jsonDecode(response.body);
    final result = data['result'];
    return PlaceInfo(
      name: result['name'],
      address: result['formatted_address'],
    );
  } else {
    throw Exception('Failed to get place');
  }
}
