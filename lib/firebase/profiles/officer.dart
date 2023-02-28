import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:license_manager/firebase/profiles/profile.dart';
import '../database.dart';

class Officer extends Profile {
  @override
  String name = "Officer";

  Future<void> setProfile(Map<String, dynamic> data, {String? email}) async {
    String? path;
    if (email != null) {
      path = "users/officer/list/$email";
    } else {
      path = "users/officer/list/${user!.email}";
    }
    await Database().setDocumentData(path, data);
  }

  Future<void> updateActiveStatus() async {
    if (user == null) {
      return;
    }
    String path = "users/officer/list/${user!.email}";
    DateTime currentTime = DateTime.now();
    Timestamp currentTimeStamp = Timestamp.fromDate(currentTime);
    var data = {
      "active_at": currentTimeStamp,
    };
    await Database().setDocumentData(path, data);
  }

  Future checkIfProfileIsComplete() async {
    String path = "users/officer/list/${user!.email}";
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
    return true;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    String path = "users/officer/list/${user!.email}";
    DocumentSnapshot<Map<String, dynamic>> dataSnapshot =
        await Database().getDocumentSnapshot(path);
    Map<String, dynamic>? data = dataSnapshot.data();
    return data;
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    Database().setDocumentData(
      "users/officer/list/${user!.email}",
      {
        "location": {"latitude": latitude, "longitude": longitude},
      },
    );
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    String path = "users/officer/records/";
    List<QueryDocumentSnapshot<Map<String, dynamic>>> collectionList =
        await Database().getDocs(path);

    List<Map<String, dynamic>> recordList = [];
    await Future.forEach(collectionList, (adminSnapshot) {
      Map<String, dynamic> data = adminSnapshot.data();
      data["id"] = adminSnapshot.id;
      recordList.add(data);
    });
    return recordList;
  }

  Future<void> setRecord(Map<String, dynamic> data) async {
    String path = "users/officer/records/";
    await FirebaseFirestore.instance
        .collection("users")
        .doc("officer")
        .collection("records")
        .doc(data["id"])
        .set(data, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getClientData() async {
    String path = "users/client/list/";
    List<QueryDocumentSnapshot<Map<String, dynamic>>> collectionList =
        await Database().getDocs(path);

    List<Map<String, dynamic>> adminList = [];
    await Future.forEach(collectionList, (adminSnapshot) {
      Map<String, dynamic> data = adminSnapshot.data();
      Timestamp? activeAt = data["active_at"];
      if (activeAt != null) {
        final activeDate = activeAt.toDate();
        final now = DateTime.now();
        final twoMinutesAgo = now.subtract(const Duration(minutes: 5));
        data["isOnline"] =
            activeDate.isAfter(twoMinutesAgo) && activeDate.isBefore(now);
      } else {
        data["isOnline"] = false;
      }
      if (data["email"] != null) {
        adminList.add(data);
      }
    });

    adminList.sort((a, b) {
      if (a["active_at"] == null && b["active_at"] == null) {
        return 0;
      } else if (a["active_at"] == null) {
        return 1;
      } else if (b["active_at"] == null) {
        return -1;
      } else {
        return b["active_at"].compareTo(a["active_at"]);
      }
    });

    return adminList;
  }

  Future<List<Map<String, dynamic>>> getOfficersData() async {
    String path = "users/officer/list/";
    List<QueryDocumentSnapshot<Map<String, dynamic>>> collectionList =
        await Database().getDocs(path);

    List<Map<String, dynamic>> adminList = [];
    await Future.forEach(collectionList, (adminSnapshot) {
      Map<String, dynamic> data = adminSnapshot.data();
      Timestamp? activeAt = data["active_at"];
      if (activeAt != null) {
        final activeDate = activeAt.toDate();
        print(activeDate);
        final now = DateTime.now();
        final twoMinutesAgo = now.subtract(const Duration(minutes: 5));
        data["isOnline"] =
            activeDate.isAfter(twoMinutesAgo) && activeDate.isBefore(now);
      } else {
        data["isOnline"] = false;
      }
      adminList.add(data);
    });

    adminList.sort((a, b) {
      if (a["active_at"] == null && b["active_at"] == null) {
        return 0;
      } else if (a["active_at"] == null) {
        return 1;
      } else if (b["active_at"] == null) {
        return -1;
      } else {
        return b["active_at"].compareTo(a["active_at"]);
      }
    });

    return adminList;
  }
}
