import 'dart:convert';

import 'package:admin/Resources/keywords.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class LandingPageServices with ChangeNotifier {
  refreshPage(String uid) async {
    await fetchHomeScreen(uid);
  }

  var _data;


  Future<String> fetchHomeScreen(String uid) async {
    var dUrl = Uri.parse(homeScree);
    Map<String, String> header = {
      "Content-type": "application/json",
      "${Strings.uid}": "$uid"
    };
    String body = '{"aid":"$uid"}';
    Response response = await post(
      dUrl,
      body: body,
      headers: header,
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      if(status) {
        var data = responseData['data'];
        _data = data;
      }else{
        return 'false';
      }
      notifyListeners();
    } else {
      return "false";
    }
  }

  getData()=>_data;
}
