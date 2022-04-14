import 'dart:convert';

import 'package:admin/Resources/keywords.dart';
import 'package:admin/sharedPrefrences/sharefPrefernces.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class QuicktradesTraderToAdvisor with ChangeNotifier {
  bool _loading = true;
  String _response;

  updateToAdvisor() async {
    await Future.delayed(Duration(milliseconds: 200));
    _loading = true;
    _response = null;
    notifyListeners();

    String uid = await SharedPreferenc().getUid();
    Uri url = Uri.parse(tradertoadvisor);
    String body = '{"uid":"$uid"}';
    Map<String, String> header = {
      "Content-type": "application/json",
    };

    Response response = await post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var message = responseData['message'];
        _loading = false;
        _response = message;
        notifyListeners();
    }
  }

  isLoading() => _loading;

  response() => _response;
}
