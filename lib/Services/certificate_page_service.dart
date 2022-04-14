import 'package:admin/Resources/keywords.dart';
import 'package:admin/sharedPrefrences/sharefPrefernces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class CertificatePageService with ChangeNotifier {
  int certi = 0; //0= null, 1= true, 2=false
  String cstatus = "Fetching...";

  Future<bool> checkCertificate() async {
    String value = await SharedPreferenc().getCertificateNumber();
    if (value == null) {
      setFalse();
      return false;
    }
    setTrue();
    return true;
  }

  int getC() => certi;

  setTrue() {
    certi = 1;
    notifyListeners();
  }

  setFalse() {
    certi = 2;
    notifyListeners();
  }

  Future<bool> sendCertificateToServer(String uid, String certificate) async {
    // String url = DBUrls.update_certificate;
    //
    // Map<String, String> header = {
    //   'uid': '$uid',
    //   'Content-Type': 'application/x-www-form-urlencoded'
    // };
    // var body = {
    //   '${Strings.certificate_db}': '$certificate',
    //   '${Strings.certificate_status}': 'Pending'
    // };
    //
    // var response = await post(url, headers: header, body: body);
    //
    // print(url);
    //
    // if (response.statusCode == 200) {
    //   if (response.body.toLowerCase() == 'done') {
    //
    //     return true;
    //   }
    //   return false;
    // }
    return true;
  }

  Future<bool> getCertificateStatus(
    String uid,
  ) async {
    Uri url = Uri.parse(get_certificat_status);

    Map<String, String> header = {'uid': '$uid'};

    var response = await get(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      if (response.body.toLowerCase() == 'empty') {
        cstatus = "";
        notifyListeners();
      } else {
        cstatus = response.body.toString();
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  getCStatus() => cstatus;
}
