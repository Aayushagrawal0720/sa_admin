import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class AccuracyService with ChangeNotifier{

  String acc="0";

  fetchAccuracy(String uid){
    final ref= FirebaseDatabase.instance.reference().child("/admin/Users/$uid/Accuracy");
    ref.onValue.listen((event) {
      updateAccuracy(event.snapshot.value.toString());
    });
  }

  updateAccuracy(String accuracy){
    if(accuracy!="null"){
      acc=accuracy;
      notifyListeners();
    }
  }

  getAccuracy()=>acc;
}