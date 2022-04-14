import 'package:flutter/foundation.dart';

class BottomNavigationService with ChangeNotifier{
  int _pageNumber=0;

  int getPage()=>_pageNumber;

  setPageNumber(int _page){
    _pageNumber=_page;
    notifyListeners();
  }

  gotoHomePage(){
    _pageNumber=0;
    notifyListeners();
  }
}