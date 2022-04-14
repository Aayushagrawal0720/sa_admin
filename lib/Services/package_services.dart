import 'dart:convert';

import 'package:admin/Resources/keywords.dart';
import 'package:admin/dataClasses/PackageDataClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class PackageServices with ChangeNotifier {
  // String packageDuration;
  String amt = "0";
  List<PackageDataClass> _pdc = [];
  bool error = false;
  List<String> _duartions = [];
  bool loading = true;

  List<String> _durationList = [
    'One Call',
    Strings.singleCall,
    Strings.oneDay,
    Strings.oneWeek,
    Strings.oneMonth,
    Strings.threeMonths,
    Strings.sixMonths,
    Strings.oneYear,
  ];

  refreshFunction(String uid) async {
    loading = true;
    notifyListeners();
    await getPackageDataFromServer(uid);
  }

  // getPackageDuration() => packageDuration;
  //
  // getPackageAmt() => amt;
  //
  // setPackageDuration(String pd, {String amt}) {
  //   print(pd);
  //   packageDuration = pd;
  //   print(packageDuration);
  //   notifyListeners();
  //
  //   if (amt != null) {
  //     this.amt = amt;
  //     notifyListeners();
  //   }
  // }
  //
  // setPackageData(Map data) {
  //   if (data.isNotEmpty) {
  //     setPackageDuration(data["ddItem"].toString(),
  //         amt: data["amt"].toString());
  //   }
  // }

  Future<String> savePackageDataToServer(
      String uid, String pid, String amtt, int index) async {
    var dUrl = Uri.parse(add_package);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String data = '{"pid" : "$pid", "${Strings.amount}": "$amtt"}';
    final response = await post(dUrl, headers: header, body: data);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      if (status) {
        refreshFunction(uid);
      }
      return message;
    } else {
      return "error";
    }
  }

  getPackageDataFromServer(String uid) async {
    await Future.delayed(Duration(milliseconds: 200));
    loading = false;
    _pdc.clear();
    notifyListeners();

    var dUrl = Uri.parse(get_package);
    Map<String, String> header = {
      "Content-type": "application/json",
      "${Strings.uid}": "$uid"
    };
    String body = '{"aid":"$uid", "analyst":true}';
    final response = await post(dUrl, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      var data = responseData['data'];
      var packages= data['packages'];
      if (status) {
        if (message == "no package found") {
          error = false;
        } else {
          for (var d in packages) {
            _pdc.add(PackageDataClass(
                title: d['duration'],
                pamt: d['amount'],
                pid: d['pid'],
                duration: d['duration']));
          }
          _pdc = sortPackages(_pdc);
          error = false;
          // for (var dur in _pdc) {
          //   for (var d in data.values) {
          //     if (dur.duration == d[Strings.duration]) {
          //       dur.pid = d[Strings.uid];
          //       dur.pamt = d[Strings.amount];
          //       // _pdc.add(PackageDataClass(
          //       //     pid: d[Strings.uid],
          //       //     pamt: d[Strings.amount],
          //       //     title: "fdfdhbfjdf",
          //       //     startDate: "121212",
          //       //     endDate: "232323",
          //       //     duration: d[Strings.duration]));
          //
          //       _duartions.add(d[Strings.duration]);
          //     }
          //   }
          // }
        }
        loading = false;
      }
      notifyListeners();
    } else {
      error = true;
      notifyListeners();
    }
  }

  dynamic getList() => error ? "error" : _pdc;

  List<PackageDataClass> sortPackages(List<PackageDataClass> packages) {
    List<PackageDataClass> _temp = List<PackageDataClass>.generate(
        packages.length, (index) => PackageDataClass());
    packages.forEach((element) {
      _temp.removeAt(_durationList.indexOf(element.duration) - 1);
      _temp.insert(_durationList.indexOf(element.duration) - 1, element);
    });
    return _temp;
  }

  getDurations() =>
      _duartions.length != 0 ? _duartions.toSet().toList() : _duartions;
}
