import 'dart:convert';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/dataClasses/Instruments.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class NewCallPageServices with ChangeNotifier {
  DatabaseReference ltpsRef =
      FirebaseDatabase.instance.reference().child('ltps');

  String _selectedOrderType = Strings.intraday;
  String _subOrderType = Strings.equity;
  String fno = Strings.future;
  String callPut = Strings.call;
  String buysell = 'buy';
  String selectedMonth;

  String equityLtp = "0.00";
  String fnoLtp = "0.00";
  String commLtp = "0.00";
  String currLtp = "0.00";

  Instruments equity = Instruments(
      name: "", instrument_token: "", exchange: "", tradingsymbol: "");
  Instruments fn_o = Instruments(
      name: "", instrument_token: "", exchange: "", tradingsymbol: "");
  Instruments comm = Instruments(
      name: "", instrument_token: "", exchange: "", tradingsymbol: "");
  Instruments curr = Instruments(
      name: "", instrument_token: "", exchange: "", tradingsymbol: "");

  setorderType(String _type) {
    _selectedOrderType = _type;
    notifyListeners();
  }

  getOrderType() => _selectedOrderType;

  setSubOrdertype(String _type) {
    _subOrderType = _type;
    notifyListeners();
  }

  getSubOrderType() => _subOrderType;

  setFno(String fn) {
    fno = fn;
    notifyListeners();
  }

  getFno() => fno;

  setcallPut(String cp) {
    callPut = cp;
    notifyListeners();
  }

  getcp() => callPut;

  setBuySell(String bs) {
    buysell = bs;
    notifyListeners();
  }

  getBuySell() => buysell;

  setSelectedMonth(String sm) {
    selectedMonth = sm;
    notifyListeners();
  }

  getSelectedMonth() => selectedMonth;

  Future<bool> sendCallToServer(String uid, Map data) async {
    var dUrl = Uri.parse(make_call);
    Map<String, String> header = {
      "Content-type": "application/json",
      "${Strings.uid}": "$uid"
    };
    // String data =
    //     '{"${Strings.duration}" : "$packageDuration", "${Strings.amount}": "$amtt"}';
    var jtemp = jsonEncode(data);
    final response = await post(dUrl, headers: header, body: '$jtemp');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      bool status = data['status'];
      if (status) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<Instruments> setEquityScript(Instruments text) async {
    await Future.delayed(Duration(milliseconds: 300));
    equity = text;
    // updateLtp(Strings.equity);
    notifyListeners();
  }

  Instruments setFnoScript(Instruments text) {
    fn_o = text;
    // updateLtp(Strings.fno);
    notifyListeners();
  }

  Instruments setCommScript(Instruments text) {
    comm = text;
    // updateLtp(Strings.commodity);
    notifyListeners();
  }

  Instruments setCurrScript(Instruments text) {
    curr = text;
    // updateLtp(Strings.currency);
    notifyListeners();
  }

  getEquity() => equity;

  getFn_o() => fn_o;

  getComm() => comm;

  getCurr() => curr;

  updateLtp(String form) async {
    String it;
    switch (form) {
      case Strings.equity:
        {
          it = equity.instrument_token;
          break;
        }
      case Strings.fno:
        {
          it = fn_o.instrument_token;
          break;
        }
      case Strings.commodity:
        {
          it = comm.instrument_token;
          break;
        }
      case Strings.currency:
        {
          it = curr.instrument_token;
          break;
        }
    }

    if (it.isNotEmpty) {
      ltpsRef.orderByChild('it').equalTo(it).once().then((snap) async {
        if (snap.snapshot.value != null) {
          var data = snap.snapshot.value as Map<dynamic, dynamic>;

          listenFunction(data.keys.first, form);
        } else {
          var dUrl = Uri.parse('dfsdf');
          Map<String, String> header = {
            "Content-type": "application/json",
          };
          var jtemp = '{"instrument_token" : "$it"}';
          final response = await post(dUrl, headers: header, body: '$jtemp');
          if (response.statusCode == 200) {
            updateLtp(form);
            return true;
          } else {
            return false;
          }
        }
      });
    }
  }

  String eqliveLtp = '0';
  String fnoliveLtp = '0';
  String comLiveLtp = '0';
  String currLiveLtp = '0';

  listenFunction(String key, String form) {
    ltpsRef.child(key).onValue.listen((snap) {
      try {
        var data = snap.snapshot.value as Map<dynamic, dynamic>;
        switch (form) {
          case Strings.equity:
            {
              if (equity.instrument_token == data['it']) {
                eqliveLtp = data['ltp'].toString();
                notifyListeners();
              }
              break;
            }
          case Strings.fno:
            {
              if (fn_o.instrument_token == data['it']) {
                fnoliveLtp = data['ltp'].toString();
                notifyListeners();
              }
              break;
            }
          case Strings.commodity:
            {
              if (comm.instrument_token == data['it']) {
                comLiveLtp = data['ltp'].toString();
                notifyListeners();
              }
              break;
            }
          case Strings.currency:
            {
              if (curr.instrument_token == data['it']) {
                currLiveLtp = data['ltp'].toString();
                notifyListeners();
              }
              break;
            }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  getEqLtp() => eqliveLtp;

  getFnoLtp() => fnoliveLtp;

  getComLtp() => comLiveLtp;

  getCurrLtp() => currLiveLtp;

  checkTime() {
    DateTime currentTime = DateTime.now();

    double currentTimeDouble =
        currentTime.hour.toDouble() + (currentTime.minute.toDouble() / 60);

    if (currentTimeDouble >= closingTime || currentTimeDouble < openingTime) {
      return false;
    } else {
      return true;
    }
  }
}
