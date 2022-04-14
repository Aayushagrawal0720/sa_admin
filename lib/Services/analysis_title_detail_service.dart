import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:http/http.dart' as http;

class AnalysisTitleDetailService with ChangeNotifier {
  String _details;
  String _imgUrl;
  bool _isLoading = true;

  fetchDetails(String title) async {
    await Future.delayed(Duration(milliseconds: 200));
    _isLoading = true;
    notifyListeners();

    Uri url = Uri.parse(gettitledeatils);
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', url);
    request.body = json.encode({"title": "$title"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = json.decode(await response.stream.bytesToString());
      _details = responseData['desc'];
      _imgUrl = responseData['img'];
      _isLoading = false;
      notifyListeners();
    } else {
      print(response.reasonPhrase);
    }
  }

  String getDetails() => _details;
  String getImg()=>_imgUrl;

  bool isLoading() => _isLoading;
}
