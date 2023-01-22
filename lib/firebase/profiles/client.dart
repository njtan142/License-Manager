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
}
