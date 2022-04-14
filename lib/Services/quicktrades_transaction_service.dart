import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:admin/DataClasses/TransactionHistoryClass.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/dataClasses/TransactionsClass.dart';
import 'package:admin/sharedPrefrences/sharefPrefernces.dart';

class QuicktradesTransactionService with ChangeNotifier {
  List<TransactionHistoryClass> _transactions = [];
  List<TransactionClass> _finalTransactions = [];
  bool _isFetching = true;
  bool error = false;
  String message;

  fetchTransactions() async {
    // try {
    await Future.delayed(Duration(milliseconds: 200));
    _isFetching = true;
    _transactions.clear();
    _finalTransactions.clear();
    error = false;
    notifyListeners();

    String uid = await SharedPreferenc().getUid();
    Uri url = Uri.parse(gettxn);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"uid":"$uid"}';
    Response response = await post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      bool status = data['status'];
      if (status) {
        var finalData = data['data'];
        message = data['message'];
        if (message == "No record found") {
          error = true;
          _isFetching = false;
          notifyListeners();
        } else {
          for (var d in finalData) {
            String rawdate = d['datetime'];
            DateTime datee = DateTime.parse(rawdate);
            datee = datee.toLocal();
            String date = DateFormat("dd-MM-yyy hh:mm").format(datee);
            TransactionHistoryClass _txn = TransactionHistoryClass(
                txnid: d['txnid'],
                dfrom: d['dfrom'],
                cto: d['cto'],
                gateway_result: d['gateway_result'].toString(),
                amount: d['amount'],
                uid: d['uid'],
                status: d['status'],
                datetime: date);
            _transactions.add(_txn);
            simplifyTransactions(_txn);
          }
          error = false;
          _isFetching = false;
          notifyListeners();
        }
      } else {
        error = true;
        _isFetching = false;
        notifyListeners();
      }
    }
    // } catch (err) {
    //   error = true;
    //   _isFetching = false;
    //   notifyListeners();
    //   print(err);
    // }
  }

  simplifyTransactions(TransactionHistoryClass element) {
    String title;
    String subtitle;
    String amount;
    String dfrom = element.dfrom;
    String cto = element.cto;

    switch (element.cto) {
      case 'wallet':
        {
          title = 'Money added to wallet';
          subtitle = 'From your bank account';
          amount = "+" + element.amount;
          break;
        }
      case 'Bank':
        {
          title = 'Money transferred to bank';
          subtitle = 'Money is transferred from your wallet to your bank account';
          amount = "-" + element.amount;
          break;
        }
      case 'package subscription':
        {
          title = 'Paid for a subscription';
          subtitle = 'debited from your wallet';
          amount = "-" + element.amount;
          break;
        }
      case 'package subscription':
        {
          title = 'Paid for a subscription';
          subtitle = 'debited from your wallet';
          amount = "-" + element.amount;
          break;
        }
    }
    _finalTransactions.add(TransactionClass(
        uid: element.uid,
        oid: element.txnid,
        txnid: element.txnid,
        title: title,
        subtitle: subtitle,
        date: element.datetime,
        amount: amount,
        status: element.status,
        dfrom: dfrom,
        cto: cto));
  }

  getTransaction() => _finalTransactions;

  isLoading() => _isFetching;

  ifError() => error;

  getMessage() => message;
}
