import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentSnapshot(
      String path) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        getDocumentReference(path);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    return documentSnapshot;
  }

  DocumentReference<Map<String, dynamic>> getDocumentReference(String path) {
    DocumentReference<Map<String, dynamic>> documentReference =
        _firestore.doc(path);
    return documentReference;
  }

  Future<bool> checkIfExists(
      {String? path, DocumentSnapshot<Map<String, dynamic>>? reference}) async {
    if (path != null && reference == null) {
      print(path);
      reference = await getDocumentSnapshot(path);
    }

    if (reference != null) {
      bool exist = reference.exists;
      return exist;
    } else {
      return false;
    }
  }

  Future<bool> checkIfExistsWithin(
      String collectionPath, String field, dynamic value) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection(collectionPath).where(field, isEqualTo: value);
    AggregateQuerySnapshot queryCountAwait = await query.count().get();
    if (queryCountAwait.count > 0) {
      return true;
    } else {
      return false;
    }
  }

  CollectionReference<Map<String, dynamic>> getCollection(String path) {
    CollectionReference<Map<String, dynamic>> collectionReference =
        _firestore.collection(path);
    return collectionReference;
  }

  Future<int> getCollectionCount(String path) async {
    try {
      CollectionReference<Map<String, dynamic>> collectionReference =
          getCollection(path);
      AggregateQuery collectionCount = collectionReference.count();
      AggregateQuerySnapshot collectionCountSnapshot =
          await collectionCount.get();
      return collectionCountSnapshot.count;
    } catch (e) {
      await Future.delayed(Duration(seconds: 5));
      return getCollectionCount(path);
    }
  }

  String generateID() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    String id = '';
    for (int i = 0; i < 32; i++) {
      id += chars[random.nextInt(chars.length)];
    }
    return id;
  }

  Future<void> setDocumentData(String path, Map<String, dynamic> data) async {
    bool shouldUpdate = await Database().checkIfExists(path: path);
    DocumentReference<Map<String, dynamic>> documentReference =
        Database().getDocumentReference(path);
    await documentReference.set(data, SetOptions(merge: shouldUpdate));
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDocs(
      String path) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        Database().getCollection(path);
    QuerySnapshot<Map<String, dynamic>> collectionQuerySnapshot =
        await collectionReference.get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> documentsList =
        collectionQuerySnapshot.docs;
    return documentsList;
  }

  Future<void> deleteDocument(String path) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        Database().getDocumentReference(path);
    await documentReference.delete();
  }
}
