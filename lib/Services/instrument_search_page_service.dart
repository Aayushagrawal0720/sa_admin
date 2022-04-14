import 'package:admin/Resources/keywords.dart';
import 'package:admin/dataClasses/Instruments.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart';

class InstrumentSearchPageService extends ChangeNotifier {
  String type;
  List<Instruments> fullList = List();
  List<Instruments> searchList = [];

  List<Instruments> equity = []; //NSE/BSE
  List<Instruments> commodity = []; //MCX
  List<Instruments> currency = []; //BCD
  List<Instruments> fno = []; //NFO/BFO

  setType(String t) {
    type = t;
    notifyListeners();
  }

  clearList() {
    searchList.clear();
    notifyListeners();
  }

  getType() => type;

  getInstruments() => searchList;

  searchInstrument(String text) async {
    if (text.length > 2) {
      searchList.clear();
      Uri uri = Uri.parse(finstruments);
      Map<String, String> header = {"Content-type": "application/json"};
      String bodyData = '{"search":"$text"}';

      var response = await post(uri, body: bodyData, headers: header);
      // var result = json.decode(response.body);
      // bool status = result['status'];
      // String message = result['message'];
      var data = json.decode(response.body);
      ;
      for (var r in data) {
        if (searchList.length < 15) {
          searchList.add(Instruments(
            name: r['name'],
            instrument_token: r['instrument_token'],
            exchange: r['exchange'],
            tradingsymbol: r['tradingsymbol'],
          ));
        } else {
          break;
        }
      }
      notifyListeners();
    }
  }
}
