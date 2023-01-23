import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Success";
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Success";
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Success";
    } catch (error) {
      return error.toString();
    }
  }

  Future<bool> checkIfAdmin(String email) async {
    try {
      Database database = Database();
      bool isAdmin =
          await database.checkIfExists(path: "users/admin/list/$email");
      return isAdmin;
    } catch (e) {
      await Future.delayed(const Duration(seconds: 3));
      return await checkIfAdmin(email);
    }
  }

  Future<bool> checkIfOfficer(String email) async {
    try {
      Database database = Database();
      bool isOfficer =
          await database.checkIfExists(path: "users/officer/list/$email");
      return isOfficer;
    } catch (e) {
      await Future.delayed(Duration(seconds: 3));
      return await checkIfOfficer(email);
    }
  }

  Future<bool> checkIfClient(String email) async {
    try {
      Database database = Database();
      bool isUser =
          await database.checkIfExists(path: "users/client/list/$email");
      print(isUser);
      return isUser;
    } catch (e) {
      print(e);
      await Future.delayed(const Duration(seconds: 3));
      return await checkIfClient(email);
    }
  }
}
