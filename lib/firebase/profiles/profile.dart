import 'package:firebase_auth/firebase_auth.dart';

import '../auth.dart';

abstract class Profile {
  User? get user => Auth().currentUser;
  abstract String name;
}
