import 'package:admin/SQliteServices/sqliteKeywords.dart';
import 'package:flutter/cupertino.dart';

class Instruments {
  String instrument_token;
  String tradingsymbol;
  String name;
  String exchange;

  Instruments({
    @required this.name,
    @required this.instrument_token,
    @required this.exchange,
    @required this.tradingsymbol,
  });

  Map<String, dynamic> toMap() => {
        SqliteKeywords.instrument_token: instrument_token,
        SqliteKeywords.name: name,
        SqliteKeywords.tradingsymbol: tradingsymbol,
        SqliteKeywords.exchange: exchange
      };
}
