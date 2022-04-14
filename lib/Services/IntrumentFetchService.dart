import 'dart:io';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/SQliteServices/sqliteKeywords.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:admin/sharedPrefrences/sharefPrefernces.dart';

class InstrumentFetchService with ChangeNotifier {
  bool done = false;

  setDone() {
    done = true;
    notifyListeners();
  }

  getDone() => done;

  loadData() async {
    var dUrl = Uri.parse(instruments);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    Response response = await get(
      dUrl,
      headers: header,
    );
    if (response.statusCode == 200) {
      _write(
        response.body.toString(),
      );
    } else {
      return "false";
    }
  }

  _write(
    String text,
  ) async {
    final File file =
        File('${instrument_location}/${SqliteKeywords.file_name}');

    await file.writeAsString(text);
    done = true;

    SharedPreferenc().setInstrumentdate(DateTime.now().toString());

    // await SharedPref().setInstrumentdate(DateTime.now().toString());
    notifyListeners();
  }
}
