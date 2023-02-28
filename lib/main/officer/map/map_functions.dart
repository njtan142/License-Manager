import 'package:location/location.dart';

class MapFunctions {
  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    LocationData currentLocation = await location.getLocation();
    return currentLocation;
  }
}
