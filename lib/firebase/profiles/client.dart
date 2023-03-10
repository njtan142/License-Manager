import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:license_manager/firebase/profiles/profile.dart';

import '../database.dart';

class Client extends Profile {
  @override
  String name = "Client";

  Future<void> setProfile(Map<String, dynamic> data, {String? email}) async {
    String? path;
    if (email != null) {
      path = "users/client/list/$email";
    } else {
      path = "users/client/list/${user!.email}";
    }
    await Database().setDocumentData(path, data);
  }

  Future<void> updateActiveStatus() async {
    if (user == null) {
      return;
    }
    String path = "users/client/list/${user!.email}";
    DateTime currentTime = DateTime.now();
    Timestamp currentTimeStamp = Timestamp.fromDate(currentTime);
    var data = {
      "active_at": currentTimeStamp,
    };
    await Database().setDocumentData(path, data);
  }

  Future checkIfProfileIsComplete() async {
    String path = "users/client/list/${user!.email}";
    DocumentSnapshot<Map<String, dynamic>> dataSnapshot =
        await Database().getDocumentSnapshot(path);
    Map<String, dynamic>? data = dataSnapshot.data();
    if (data == null) {
      return false;
    }
    if (data["name"] == null) {
      return false;
    }
    if (data["age"] == null) {
      return false;
    }
    if (data["phoneNumber"] == null) {
      return false;
    }
    if (data["precinct"] == null) {
      return false;
    }
    return true;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    String path = "users/client/list/${user!.email}";
    DocumentSnapshot<Map<String, dynamic>> dataSnapshot =
        await Database().getDocumentSnapshot(path);
    Map<String, dynamic>? data = dataSnapshot.data();
    return data;
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    try {
      Database().setDocumentData(
        "users/client/list/${user!.email}",
        {
          "location": {"latitude": latitude, "longitude": longitude},
        },
      );
    } catch (e) {}
  }
}
