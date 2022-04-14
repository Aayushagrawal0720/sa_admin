import 'package:flutter/cupertino.dart';

class PackageEditService with ChangeNotifier {
  String packageDuration;
  String amt = "0";

  getPackageDuration() => packageDuration;

  getPackageAmt() => amt;

  setPackageDuration(String pd, String at) {
    packageDuration = pd;
    amt = at;
    notifyListeners();
  }

  setPackageData(Map data) {
    if (data.isNotEmpty) {
      setPackageDuration(data["ddItem"].toString(), data["amt"].toString());
    }
  }
}
