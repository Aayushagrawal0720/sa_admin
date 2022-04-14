import 'package:admin/Resources/keywords.dart';
import 'package:admin/sharedPrefrences/sharefPrefernces.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class QuicktradesNotificationTokenService with ChangeNotifier {

  setNotificationToken(String token) async {
    String uid = await SharedPreferenc().getUid();

    Uri url = Uri.parse(settoken);
    String body = '{"uid":"$uid", "token":"$token"}';
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    Response _response = await post(url, body: body, headers: header);
    if (_response.statusCode == 200) {
      return true;
    }
  }
}
