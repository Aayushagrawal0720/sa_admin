import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FivePaisaLoginService with ChangeNotifier {
  // fivePaisaLogin() async {
  //
  //   var headers = {'Content-Type': 'application/json'};
  //
  //   var request = http.Request(
  //       'POST',
  //       Uri.parse(
  //           'https://Openapi.5paisa.com/VendorsAPI/Service1.svc/MarketFeed'));
  //
  //   request.body = json.encode({
  //     'head': {
  //       "appName": fiveAppName,
  //       "appVer": "1.0",
  //       "key": fiveAppUserKey,
  //       "osName": "Android",
  //       "requestCode": "5PMF",
  //       "userId": fiveAppUserId,
  //       "password": fiveAppUserPass
  //     },
  //     'body': {
  //       "Count": 3,
  //       "MarketFeedData": [
  //         {
  //           "Exch": "N",
  //           "ExchType": "C",
  //           "Symbol": "INFY",
  //           "Expiry": "",
  //           "StrikePrice": "0",
  //           "OptionType": ""
  //         },
  //         {
  //           "Exch": "N",
  //           "ExchType": "C",
  //           "Symbol": "SBIN",
  //           "Expiry": "",
  //           "StrikePrice": "0",
  //           "OptionType": ""
  //         }
  //       ],
  //       "ClientLoginType": 0,
  //       "LastRequestTime": '/Date(0)/',
  //       "RefreshRate": "M"
  //     }
  //   });
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print("---------------five paisa login--------------------");
  //     print(response.headers);
  //     print(response.statusCode);
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print("---------------five paisa login--------------------");
  //     print(response.headers);
  //     print(response.statusCode);
  //     print(response.reasonPhrase);
  //     debugPrint(await response.stream.bytesToString());
  //   }
  // }
}
