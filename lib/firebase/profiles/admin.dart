import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:license_manager/firebase/profiles/profile.dart';

import '../database.dart';

class Admin extends Profile {
  @override
  String name = "Admin";

  Future<int> getOfficerCount() async {
    String path = "users/officer/list/";
    int childCount = await Database().getCollectionCount(path);
    return childCount;
  }

  Future<int> getClientCount() async {
    String path = "users/client/list/";
    int childCount = await Database().getCollectionCount(path);
    return childCount;
  }

  Future<bool> addViolation(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection("violations")
          .doc()
          .set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAdminsData() async {
    String path = "users/admin/list/";
    List<QueryDocumentSnapshot<Map<String, dynamic>>> collectionList =
        await Database().getDocs(path);

    List<Map<String, dynamic>> adminList = [];
    await Future.forEach(collectionList, (adminSnapshot) {
      Map<String, dynamic> data = adminSnapshot.data();
      data["email"] = adminSnapshot.id;
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
    return adminList;
  }

  Future<void> updateActiveStatus() async {
    String path = "users/admin/list/${user!.email}";
    DateTime currentTime = DateTime.now();
    Timestamp currentTimeStamp = Timestamp.fromDate(currentTime);
    var data = {
      "active_at": currentTimeStamp,
    };
    await Database().setDocumentData(path, data);
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
    return adminList;
  }

  Future<List<Map<String, dynamic>>> getViolationList() async {
    String path = "violations/";
    List<QueryDocumentSnapshot<Map<String, dynamic>>> collectionList =
        await Database().getDocs(path);

    List<Map<String, dynamic>> violationList = [];
    await Future.forEach(collectionList, (violationSnapshot) {
      Map<String, dynamic> data = violationSnapshot.data();
      violationList.add(data);
    });
    return violationList;
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
    return adminList;
  }

  Future<UserCredential?> create(
      FirebaseApp app, String email, String password) async {
    try {
      return await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      return null;
    }
  }

  Future<bool> createAdmin(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: "secondary", options: Firebase.app().options);
    UserCredential? creationResult = await create(app, email, password);
    if (creationResult != null) {
      // data for child
      String path = "users/admin/list/$email";
      Map<String, dynamic> data = {
        "email": email,
      };
      await Database().setDocumentData(path, data);
      // data for parent
    }
    await app.delete();
    return creationResult != null;
  }

  Future<bool> createOfficer(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: "secondary", options: Firebase.app().options);
    UserCredential? creationResult = await create(app, email, password);
    if (creationResult != null) {
      // data for child
      String path = "users/officer/list/$email";
      Map<String, dynamic> data = {
        "email": email,
      };
      await Database().setDocumentData(path, data);
      // data for parent
    }
    await app.delete();
    return creationResult != null;
  }

  Future<bool> createParent(
      String email, String password, Map<String, dynamic> data) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: "secondary", options: Firebase.app().options);
    UserCredential? creationResult = await create(app, email, password);
    if (creationResult != null) {
      // data for child
      String path = "users/parent/list/$email";
      await Database().setDocumentData(path, data);
      // data for parent
    }
    await app.delete();
    return creationResult != null;
  }
}
