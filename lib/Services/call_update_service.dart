import 'package:admin/Services/calls_page_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CallUpdateService {
  final instance = FirebaseDatabase.instance.reference();

  getLtp(String cid, int index, BuildContext context) {
    instance.child("Calls").child(cid).child("ltp").onValue.listen((event) {
      Provider.of<CallsPageService>(context, listen: false)
          .updateList(index, event.snapshot.value, cid);
    });
  }
}
