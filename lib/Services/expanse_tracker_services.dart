import 'package:flutter/foundation.dart';

class ExpanseTrackerServices with ChangeNotifier{
  int _pageNumber=0;
  double _anPercentage=0.0;

  int getPageNumber()=>_pageNumber;
  double getPercentage()=>_anPercentage;



  updatePercentage(double page){
    _anPercentage=page;
    notifyListeners();
  }
  updatePageNumber(int page){
    _pageNumber=page;
    notifyListeners();
  }
}
