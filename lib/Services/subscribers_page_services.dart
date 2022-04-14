import 'dart:convert';

import 'package:admin/Resources/keywords.dart';
import 'package:admin/dataClasses/subscriber.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class SubscribersPageService with ChangeNotifier {
  List<SubscribersClass> _subscribers = List();

  refreshFunction(String uid) async {
    _subscribers.clear();
    notifyListeners();

    await fetchSubscriber2(uid);
  }

  fetchSubscriber2(String uid) async {
    var dUrl = Uri.parse(subs);
    Map<String, String> header = {
      "Content-type": "application/json",
      "${Strings.uid}": "$uid"
    };
    Response response = await post(
      dUrl,
      headers: header,
    );
    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);
        _subscribers.clear();

        for (var d in data) {
          _subscribers.add(SubscribersClass(
              name: d[Strings.name].toString(),
              url: d[Strings.url].toString() == "null"
                  ? personImage
                  : d[Strings.url].toString()));
        }

        return response.body.toString();
      } catch (e) {
        print("catch error===========$e");
        return "false";
      }
    } else {
      return "false";
    }
  }

  fetchSubscriber() {
    _subscribers.clear();
    _subscribers.add(SubscribersClass(
        name: "Nikhil",
        url:
            "https://microhealth.com/assets/images/illustrations/personal-user-illustration-@2x.png"));
    _subscribers.add(SubscribersClass(
        name: "Nikhil",
        url:
            "https://microhealth.com/assets/images/illustrations/personal-user-illustration-@2x.png"));
    _subscribers.add(SubscribersClass(
        name: "Nikhil",
        url:
            "https://microhealth.com/assets/images/illustrations/personal-user-illustration-@2x.png"));
    _subscribers.add(SubscribersClass(
        name: "Nikhil",
        url:
            "https://microhealth.com/assets/images/illustrations/personal-user-illustration-@2x.png"));
    _subscribers.add(SubscribersClass(
        name: "Nikhil",
        url:
            "https://microhealth.com/assets/images/illustrations/personal-user-illustration-@2x.png"));

    notifyListeners();
  }

  getSubscriber() => _subscribers;
}
