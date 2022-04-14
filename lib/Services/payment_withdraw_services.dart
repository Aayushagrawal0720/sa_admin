import 'dart:convert';

import 'package:admin/Resources/keywords.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class PaymentWithdrawServices with ChangeNotifier {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  sendWithdrawRequestToServer(
    String amount,
    String uid,
    String upi,
    String accnumber,
    String accname,
    String accType,
    String ifsc,
  ) async {
    Uri url = Uri.parse(walletWithdraw);
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var jsond =
        '{"upi": "$upi","${Strings.acc_no}": "$accnumber","${Strings.accname}": "$accname","${Strings.type}": "$accType","${Strings.ifsc_code}": "$ifsc"}';
    var data = {"uid":"$uid", "amount":"$amount", "bankdetails":"$jsond"};
    Response response = await post(url, headers: headers, body: data);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      return message;
    }
  }
}
