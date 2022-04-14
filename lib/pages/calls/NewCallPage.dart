import 'dart:collection';
import 'dart:io';
import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/FadePageRoute.dart';
import 'package:admin/Resources/SupportDialogs.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/Resources/title_text.dart';
import 'package:admin/SQliteServices/sqliteKeywords.dart';
import 'package:admin/Services/analysis_text_servuce.dart';
import 'package:admin/Services/analysis_upload_service.dart';
import 'package:admin/Services/calls_page_service.dart';
import 'package:admin/Services/certificate_page_service.dart';
import 'package:admin/Services/instrument_search_page_service.dart';
import 'package:admin/Services/new_call_page_services.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/Services/trimarketwatch_ltp_service.dart';
import 'package:admin/pages/HomePage.dart';
import 'package:admin/pages/calls/InstrumentSearchPage.dart';
import 'package:admin/sharedPrefrences/sharefPrefernces.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:toast/toast.dart';
import '../CallsPage.dart';

class NewCallPage extends StatefulWidget {
  @override
  NewCallPageState createState() => NewCallPageState();
}

class NewCallPageState extends State<NewCallPage>
    with SingleTickerProviderStateMixin {
  var myRef = FirebaseDatabase.instance.ref();

  List<String> _typelist = [
    Strings.equity,
    Strings.fno,
    Strings.commodity,
    Strings.currency
  ];
  TabController _tabController;

  int _buySellSelectedButton;
  int _fnoSelectedButton;
  int _cpSelectedButton;
  DateTime _currentDate;
  int _currentMonth;
  int _nextMonth;
  int _laterMonth;
  var newcps;

  String _selectedMonthValue;
  List<String> _monthList = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];

  //--------EQUITY CONTROLLERS------
  var _stocknamecontroller = TextEditingController();
  var _cmpController = TextEditingController();
  var _targetController0 = TextEditingController();
  var _targetController1 = TextEditingController();
  var _slController0 = TextEditingController();
  var _slController1 = TextEditingController();
  var _quantityController = TextEditingController();
  var _sellBuyPriceController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _fcpController = TextEditingController();
  var tradingSymbol = "";
  var exchange = "";
  var instrumentToken = "";

  //--------FNO CONTROLLERS------
  var _stocknamecontrollerFno = TextEditingController();
  var _cmpControllerFno = TextEditingController();
  var _targetController0Fno = TextEditingController();
  var _targetController1Fno = TextEditingController();
  var _slController0Fno = TextEditingController();
  var _slController1Fno = TextEditingController();
  var _quantityControllerFno = TextEditingController();
  var _sellBuyPriceControllerFno = TextEditingController();
  var _fcpControllerFno = TextEditingController();
  var _strikeControllerFnO = TextEditingController();
  var tradingSymbolFno = "";
  var exchangeFno = "";
  var instrumentTokenFno = "";

  //--------COMMODITY CONTROLLERS------
  var _stocknamecontrollerCom = TextEditingController();
  var _cmpControllerCom = TextEditingController();
  var _targetController0Com = TextEditingController();
  var _targetController1Com = TextEditingController();
  var _slController0Com = TextEditingController();
  var _slController1Com = TextEditingController();
  var _quantityControllerCom = TextEditingController();
  var _sellBuyPriceControllerCom = TextEditingController();
  var _fcpControllerCom = TextEditingController();
  var _strikeControllerCom = TextEditingController();
  var tradingSymbolComm = "";
  var exchangeComm = "";
  var instrumentTokenComm = "";

  //--------CURRENCY CONTROLLERS------
  var _stocknamecontrollerCur = TextEditingController();
  var _cmpControllerCur = TextEditingController();
  var _targetController0Cur = TextEditingController();
  var _targetController1Cur = TextEditingController();
  var _slController0Cur = TextEditingController();
  var _slController1Cur = TextEditingController();
  var _quantityControllerCur = TextEditingController();
  var _sellBuyPriceControllerCur = TextEditingController();
  var _fcpControllerCur = TextEditingController();
  var _strikeControllerCur = TextEditingController();
  var tradingSymbolCurr = "";
  var exchangeCurr = "";
  var instrumentTokenCurr = "";

  GlobalKey<FormState> _key = GlobalKey();
  GlobalKey<FormState> _fnoKey = GlobalKey<FormState>();
  GlobalKey<FormState> _commodityKey = GlobalKey<FormState>();
  GlobalKey<FormState> _currencyKey = GlobalKey<FormState>();

  //----------LOADING DATA FROM SERVER------------------------------------------

  //-----------UI BUILDING-----------------------------------------------------
  //------------UNSELECTED BUTTON WIDGET
  Widget _buttonUnSelected(String text) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Text(text,
            style: TextStyle(
              color: ColorsTheme.primaryDark,
              fontWeight: FontWeight.w300,
            )),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: ColorsTheme.secondryColor.withOpacity(0.3),
                  offset: Offset(0, 0),
                  blurRadius: 3)
            ]));
  }

//-----------------SELECTED BUTTON WIDGET
  Widget _buttonSelected(String text) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            )),
        decoration: BoxDecoration(
            color: ColorsTheme.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xff797878), offset: Offset(0, 0), blurRadius: 1)
            ]));
  }

  openAnaTitleSelection() {
    Dialog _dialog = Dialog(
      child: Consumer<AnalysisTextService>(builder: (context, snapshot, child) {
        List<String> _titles = snapshot.texts();

        return !snapshot.isLoading()
            ? Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Search...",
                            suffixIcon: Icon(Icons.search)),
                        onChanged: (val) {
                          Provider.of<AnalysisTextService>(context,
                                  listen: false)
                              .searchTitle(val);
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: _titles.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  snapshot.setSelected(_titles[index]);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    color: index % 2 == 0
                                        ? Colors.grey[300]
                                        : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${_titles[index]}"),
                                    )),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              )
            : Container(child: Text("Loading..."));
      }),
    );
    showDialog(context: context, builder: (context) => _dialog);
  }

  Widget _analysisUpload() {
    return Consumer<AnalysisUploadService>(builder: (context, snapshot, child) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: fieldDecoration(),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  ImagePicker()
                      .pickImage(source: ImageSource.gallery)
                      .then((value) {
                    if (value != null) {
                      snapshot.setImage(value.path);
                    }
                  }).catchError((err) {
                    print(err);
                  });
                },
                child: Container(
                  child: snapshot.getImage() == null
                      ? Center(
                          child: Image.asset(
                          "assets/other/ph.jpg",
                          height: 200,
                        ))
                      : Center(
                          child: Stack(
                            children: [
                              Image.file(
                                File(snapshot.getImage()),
                                height: 200,
                              ),
                              snapshot.isUploading()
                                  ? Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      child: Center(
                                        child: SpinKitCircle(
                                          color: ColorsTheme.darkred,
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                ),
              ),
              Consumer<AnalysisTextService>(
                  builder: (context, snapshot, child) {
                return snapshot.isLoading() &&
                        snapshot.getSelectedText() == null
                    ? SpinKitChasingDots(
                        color: ColorsTheme.darkred,
                        size: 16,
                      )
                    : ListTile(
                        onTap: () {
                          openAnaTitleSelection();
                        },
                        title: Text(
                          snapshot.getSelectedText().toString(),
                          style:
                              GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(Icons.arrow_right),
                      );
              })
            ],
          ));
    });
  }

  //-----------ORDER TYPE PARENT--------
  Widget _orderTypeParent() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: fieldDecoration(),
      child: _orderTypeContent(),
    );
  }

  //------------ORDER TYPE CONTENT----------
  Widget _orderTypeContent() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: 15.0),
          child: Text(
            Strings.recordType,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Consumer<NewCallPageServices>(
          builder: (context, ncps, child) {
            if (ncps.getOrderType() == Strings.intraday) {
              checkForTimePermission();
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    ncps.setorderType(Strings.intraday);
                  },
                  child: ncps.getOrderType() == Strings.intraday
                      ? _buttonSelected(Strings.intraday)
                      : _buttonUnSelected(Strings.intraday),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      ncps.setorderType(Strings.cnc);
                    });
                  },
                  child: ncps.getOrderType() == Strings.cnc
                      ? _buttonSelected(Strings.cnc)
                      : _buttonUnSelected(Strings.cnc),
                )
              ],
            );
          },
        ),
      ],
    );
  }

  //-----------SUB ORDER TYPE (WITHOUT ANY PARENT)------------
  Widget _subOrderTypeContent() {
    return Container(child: Consumer<NewCallPageServices>(
      builder: (context, ncps, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  ncps.setSubOrdertype(Strings.equity);
                });
              },
              child: ncps.getSubOrderType() == Strings.equity
                  ? _buttonSelected(Strings.equity)
                  : _buttonUnSelected(Strings.equity),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  ncps.setSubOrdertype(Strings.fno);
                });
              },
              child: ncps.getSubOrderType() == Strings.fno
                  ? _buttonSelected(Strings.fno)
                  : _buttonUnSelected(Strings.fno),
            )
          ],
        );
      },
    ));
  }

  //---------GETTING SYSTEM DATE-----------------------
  void dateSelector() {
    _currentDate = DateTime.now();
    _currentMonth = _currentDate.month - 1;

    if (_currentDate.month + 1 >= 12) {
      _nextMonth = 12 - (_currentDate.month);
    } else {
      _nextMonth = _currentDate.month;
    }

    if (_currentDate.month + 1 >= 12) {
      _laterMonth = (_currentDate.month + 1) - 12;
    } else {
      _laterMonth = _currentDate.month + 1;
    }

    _selectedMonthValue = _monthList[_currentMonth];
  }

  //---------SELECT THREE MONTHS------------------------
  Widget _selectMonth() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedMonthValue = _monthList[_currentMonth];
              });
            },
            child: _selectedMonthValue == _monthList[_currentMonth]
                ? _buttonSelected(_monthList[_currentMonth])
                : _buttonUnSelected(_monthList[_currentMonth]),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedMonthValue = _monthList[_nextMonth];
              });
            },
            child: _selectedMonthValue == _monthList[_nextMonth]
                ? _buttonSelected(_monthList[_nextMonth])
                : _buttonUnSelected(_monthList[_nextMonth]),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedMonthValue = _monthList[_laterMonth];
              });
            },
            child: _selectedMonthValue == _monthList[_laterMonth]
                ? _buttonSelected(_monthList[_laterMonth])
                : _buttonUnSelected(_monthList[_laterMonth]),
          )
        ],
      ),
    );
  }

  //--------BUY SELL RADIO----------
  Widget buySellRadio() {
    return Consumer<NewCallPageServices>(
      builder: (context, ncps, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: RadioListTile(
                title: Text(Strings.buy),
                value: 0,
                groupValue: ncps.getBuySell() == 'buy' ? 0 : 1,
                activeColor: ColorsTheme.primaryColor,
                onChanged: (val) {
                  ncps.setBuySell('buy');
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text(Strings.sell),
                value: 1,
                groupValue: ncps.getBuySell() == 'buy' ? 0 : 1,
                activeColor: ColorsTheme.primaryColor,
                onChanged: (val) {
                  ncps.setBuySell('sell');
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //--------EQUITY FORM---------
  Widget equityForm() {
    // Provider.of<NewCallPageServices>(context, listen: false)
    //     .updateLtp(Strings.equity);
    return Form(
      key: _key,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _analysisUpload(),
              SizedBox(
                height: 20,
              ),
              _orderTypeParent(),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<InstrumentSearchPageService>(context,
                              listen: false)
                          .setType(Strings.equity);
                      Provider.of<InstrumentSearchPageService>(context,
                              listen: false)
                          .clearList();
                      Navigator.push(context,
                          fadePageRoute(context, InstrumentSearchPage()));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                Strings.stockName,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Consumer<NewCallPageServices>(
                                  builder: (context, ncps, chil) {
                                _stocknamecontroller.text =
                                    ncps.getEquity().tradingsymbol;
                                tradingSymbol = ncps.getEquity().tradingsymbol;
                                exchange = ncps.getEquity().exchange;
                                instrumentToken =
                                    ncps.getEquity().instrument_token;
                                Provider.of<TriMarketWatchLtpService>(context,
                                        listen: false)
                                    .subscribe(instrumentToken);
                                return TextFormField(
                                  enabled: false,
                                  controller: _stocknamecontroller,
                                  decoration: InputDecoration(
                                    hintText: Strings.stockName,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  // ignore: missing_return
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Enter Script Name";
                                    }
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                        Consumer<TriMarketWatchLtpService>(
                          builder: (context, ncps, child) {
                            return RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "Ltp: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            ncps.getNormalLtp(instrumentToken),
                                        style:
                                            TextStyle(color: Colors.deepPurple))
                                  ]),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.cmp,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         TextFormField(
              //           keyboardType: TextInputType.number,
              //           controller: _cmpController,
              //           decoration: InputDecoration(
              //             hintText: Strings.cmp,
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.type,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      buySellRadio(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.entryPriceo,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _sellBuyPriceController,
                        decoration: InputDecoration(
                          hintText: Strings.entryPriceo,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Buying Selling Price";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.target0o,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _targetController0,
                        decoration: InputDecoration(
                          hintText: Strings.target0o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Target Price";
                          }

                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceController.text)) {
                              return "Target price should be greater than entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceController.text)) {
                              return "Target price should be less than entry price";
                            }
                          }
                        },
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _targetController1,
                        decoration: InputDecoration(
                          hintText: Strings.target1o,
                          labelText: Strings.target1o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Second Target Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceController.text)) {
                              return "Target price should be greater than entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceController.text)) {
                              return "Target price should be less than entry price";
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.sl0o,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _slController0,
                        decoration: InputDecoration(
                          hintText: Strings.sl0o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter SL Price";
                          }

                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceController.text)) {
                              return "SL price should be greater then entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceController.text)) {
                              return "SL price should be less then entry price";
                            }
                          }
                        },
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _slController1,
                        decoration: InputDecoration(
                          hintText: Strings.sl1o,
                          labelText: Strings.sl1o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Second SL Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceController.text)) {
                              return "SL price should be greater then entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceController.text)) {
                              return "SL price should be less then entry price";
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.desc,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: Strings.desc,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onChanged: (val) {
                          if (val.length > 500) {
                            Toast.show(
                                "Description can't exceed 500 characters",
                                context,
                                gravity: Toast.TOP);
                          }
                        },
                        validator: (val) {
                          if (val.length > 500) {
                            return "Description can't exceed 500 characters";
                          }
                          if (val.isEmpty) {
                            return "Description can't be empty";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.quantity,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         TextFormField(
              //           keyboardType: TextInputType.number,
              //           controller: _quantityController,
              //           decoration: InputDecoration(
              //             hintText: Strings.quantity,
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.fcp,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         TextFormField(
              //           keyboardType: TextInputType.number,
              //           controller: _fcpController,
              //           decoration: InputDecoration(
              //             hintText: Strings.fcp,
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              _sendButton()
            ],
          ),
        ),
      ),
    );
  }

  //--------FUTURE/OPTION RADIO BUTTON
  Widget fnoRadio() {
    return Consumer<NewCallPageServices>(
      builder: (context, ncps, child) {
        return Row(
          children: <Widget>[
            Expanded(
              child: RadioListTile(
                title: Text(Strings.future),
                value: Strings.future,
                groupValue: ncps.getFno(),
                activeColor: ColorsTheme.primaryColor,
                onChanged: (val) {
                  ncps.setFno(val);
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text(Strings.option),
                value: Strings.option,
                groupValue: ncps.getFno(),
                activeColor: ColorsTheme.primaryColor,
                onChanged: (val) {
                  ncps.setFno(val);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //--------CALL PUT RADIO---------
  Widget callPutRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(Strings.callorput, style: TextStyle(fontWeight: FontWeight.w600)),
        Consumer<NewCallPageServices>(
          builder: (context, ncps, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: RadioListTile(
                    title: Text(Strings.call),
                    value: Strings.call,
                    groupValue: ncps.getcp(),
                    activeColor: ColorsTheme.primaryColor,
                    onChanged: (val) {
                      ncps.setcallPut(val);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text(Strings.put),
                    value: Strings.put,
                    groupValue: ncps.getcp(),
                    activeColor: ColorsTheme.primaryColor,
                    onChanged: (val) {
                      ncps.setcallPut(val);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  //--------FNO  FORM-----------
  Widget fnoForm() {
    // Provider.of<NewCallPageServices>(context, listen: false)
    //     .updateLtp(Strings.fno);
    return Form(
      key: _fnoKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _analysisUpload(),
              SizedBox(
                height: 20,
              ),
              _orderTypeParent(),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<InstrumentSearchPageService>(context,
                              listen: false)
                          .setType(Strings.fno);
                      Provider.of<InstrumentSearchPageService>(context,
                              listen: false)
                          .clearList();
                      Navigator.push(context,
                          fadePageRoute(context, InstrumentSearchPage()));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                Strings.stockName,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Consumer<NewCallPageServices>(
                                builder: (context, ncps, chil) {
                                  _stocknamecontrollerFno.text =
                                      ncps.getFn_o().tradingsymbol;

                                  tradingSymbolFno =
                                      ncps.getFn_o().tradingsymbol;
                                  exchangeFno = ncps.getFn_o().exchange;
                                  instrumentTokenFno =
                                      ncps.getFn_o().instrument_token;

                                  return TextFormField(
                                    enabled: false,
                                    controller: _stocknamecontrollerFno,
                                    decoration: InputDecoration(
                                      hintText: Strings.stockName,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    // ignore: missing_return
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Enter Stock Name";
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Consumer<NewCallPageServices>(
                          builder: (context, ncps, child) {
                            // ncps.updateLtp(ncps.getEquity().instrument_token,Strings.equity);
                            return RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "Ltp: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: ncps.getFnoLtp(),
                                        style:
                                            TextStyle(color: Colors.deepPurple))
                                  ]),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.cmp,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         TextFormField(
              //           keyboardType: TextInputType.number,
              //           controller: _cmpControllerFno,
              //           decoration: InputDecoration(
              //             hintText: Strings.cmp,
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.futureoroption,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         fnoRadio(),
              //       ],
              //     ),
              //   ),
              // ),
              // Consumer<NewCallPageServices>(
              //   builder: (context, ncps, child) {
              //     return ncps.getFno() == 1
              //         ? Column(
              //             children: [
              //               SizedBox(
              //                 height: 20,
              //               ),
              //               Container(
              //                 decoration: fieldDecoration(),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: callPutRadio(),
              //                 ),
              //               ),
              //             ],
              //           )
              //         : Container();
              //   },
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.month,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         _selectMonth(),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.type,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      buySellRadio(),
                    ],
                  ),
                ),
              ),
              // Consumer<NewCallPageServices>(
              //   builder: (context, ncps, child) {
              //     return ncps.getFno() == 1
              //         ? Column(
              //             children: [
              //               SizedBox(
              //                 height: 20,
              //               ),
              //               Container(
              //                 decoration: fieldDecoration(),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Column(
              //                     crossAxisAlignment:
              //                         CrossAxisAlignment.stretch,
              //                     children: [
              //                       Text(Strings.strikePrice,
              //                           style: TextStyle(
              //                               fontWeight: FontWeight.w600)),
              //                       TextFormField(
              //                         keyboardType: TextInputType.number,
              //                         controller: _strikeControllerFnO,
              //                         decoration: InputDecoration(
              //                           hintText: Strings.strikePrice,
              //                           border: InputBorder.none,
              //                           focusedBorder: InputBorder.none,
              //                           enabledBorder: InputBorder.none,
              //                           disabledBorder: InputBorder.none,
              //                         ),
              //                         // ignore: missing_return
              //                         validator: (String value) {
              //                           if (value.isEmpty) {
              //                             return "Enter Strike Price";
              //                           }
              //                         },
              //                       )
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           )
              //         : Container();
              //   },
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.entryPriceo,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _sellBuyPriceControllerFno,
                        decoration: InputDecoration(
                          hintText: Strings.entryPriceo,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Buying Selling Price";
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.target0o,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _targetController0Fno,
                        decoration: InputDecoration(
                          hintText: Strings.target0o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Target Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceControllerFno.text)) {
                              return "Target price should be greater than entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceControllerFno.text)) {
                              return "Target price should be less than entry price";
                            }
                          }
                        },
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _targetController1Fno,
                        decoration: InputDecoration(
                          hintText: Strings.target1o,
                          labelText: Strings.target1o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Second Target Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) <=
                                double.parse(
                                    _sellBuyPriceControllerFno.text)) {
                              return "Target price should be greater than entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) >=
                                double.parse(
                                    _sellBuyPriceControllerFno.text)) {
                              return "Target price should be less than entry price";
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.sl0o,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _slController0Fno,
                        decoration: InputDecoration(
                          hintText: Strings.sl0o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter SL Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceControllerFno.text)) {
                              return "SL price should be greater then entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceControllerFno.text)) {
                              return "SL price should be less then entry price";
                            }
                          }
                        },
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _slController1Fno,
                        decoration: InputDecoration(
                          hintText: Strings.sl1o,
                          labelText: Strings.sl1o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Second SL Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceControllerFno.text)) {
                              return "SL price should be greater then entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceControllerFno.text)) {
                              return "SL price should be less then entry price";
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.desc,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: Strings.desc + "(Optional)",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.fcp,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         TextFormField(
              //           keyboardType: TextInputType.number,
              //           controller: _fcpController,
              //           decoration: InputDecoration(
              //             hintText: Strings.fcp,
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              _sendButton()
            ],
          ),
        ),
      ),
    );
  }

  //--------COMMODITY  FORM-----------
  Widget commodityForm() {
    // Provider.of<NewCallPageServices>(context, listen: false)
    //     .updateLtp(Strings.commodity);

    return Form(
      key: _commodityKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _analysisUpload(),
              SizedBox(
                height: 20,
              ),
              _orderTypeParent(),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<InstrumentSearchPageService>(context,
                              listen: false)
                          .setType(Strings.commodity);
                      Provider.of<InstrumentSearchPageService>(context,
                              listen: false)
                          .clearList();
                      Navigator.push(context,
                          fadePageRoute(context, InstrumentSearchPage()));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                Strings.stockName,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Consumer<NewCallPageServices>(
                                builder: (context, ncps, chil) {
                                  _stocknamecontrollerCom.text =
                                      ncps.getComm().tradingsymbol;
                                  tradingSymbolComm =
                                      ncps.getComm().tradingsymbol;
                                  exchangeComm = ncps.getComm().exchange;
                                  instrumentTokenComm =
                                      ncps.getComm().instrument_token;

                                  return TextFormField(
                                    enabled: false,
                                    controller: _stocknamecontrollerCom,
                                    decoration: InputDecoration(
                                      hintText: Strings.stockName,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    // ignore: missing_return
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Enter Stock Name";
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Consumer<NewCallPageServices>(
                          builder: (context, ncps, child) {
                            // ncps.updateLtp(ncps.getEquity().instrument_token,Strings.equity);
                            return RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "Ltp: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: ncps.getComLtp(),
                                        style:
                                            TextStyle(color: Colors.deepPurple))
                                  ]),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.cmp,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         TextFormField(
              //           keyboardType: TextInputType.number,
              //           controller: _cmpControllerCom,
              //           decoration: InputDecoration(
              //             hintText: Strings.cmp,
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.futureoroption,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         fnoRadio(),
              //       ],
              //     ),
              //   ),
              // ),
              // Consumer<NewCallPageServices>(
              //   builder: (context, ncps, child) {
              //     return ncps.getFno() == 1
              //         ? Column(
              //             children: [
              //               SizedBox(
              //                 height: 20,
              //               ),
              //               Container(
              //                 decoration: fieldDecoration(),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: callPutRadio(),
              //                 ),
              //               ),
              //             ],
              //           )
              //         : Container();
              //   },
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.month,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         _selectMonth(),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.type,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      buySellRadio(),
                    ],
                  ),
                ),
              ),
              // Consumer<NewCallPageServices>(
              //   builder: (context, ncps, child) {
              //     return ncps.getFno() == 1
              //         ? Column(
              //             children: [
              //               SizedBox(
              //                 height: 20,
              //               ),
              //               Container(
              //                 decoration: fieldDecoration(),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Column(
              //                     crossAxisAlignment:
              //                         CrossAxisAlignment.stretch,
              //                     children: [
              //                       Text(Strings.strikePrice,
              //                           style: TextStyle(
              //                               fontWeight: FontWeight.w600)),
              //                       TextFormField(
              //                         keyboardType: TextInputType.number,
              //                         controller: _strikeControllerCom,
              //                         decoration: InputDecoration(
              //                           hintText: Strings.strikePrice,
              //                           border: InputBorder.none,
              //                           focusedBorder: InputBorder.none,
              //                           enabledBorder: InputBorder.none,
              //                           disabledBorder: InputBorder.none,
              //                         ),
              //                         // ignore: missing_return
              //                         validator: (String value) {
              //                           if (value.isEmpty) {
              //                             return "Enter Stike Price";
              //                           }
              //                         },
              //                       )
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           )
              //         : Container();
              //   },
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.entryPriceo,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _sellBuyPriceControllerCom,
                        decoration: InputDecoration(
                          hintText: Strings.entryPriceo,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Buying Selling Price";
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.target0o,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _targetController0Com,
                        decoration: InputDecoration(
                          hintText: Strings.target0o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Target Price";
                          }

                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceControllerCom.text)) {
                              return "Target price should be greater than entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceControllerCom.text)) {
                              return "Target price should be less than entry price";
                            }
                          }
                        },
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _targetController1Com,
                        decoration: InputDecoration(
                          hintText: Strings.target1o,
                          labelText: Strings.target1o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Second Target Price";
                          }

                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) <=
                                double.parse(
                                    _sellBuyPriceControllerCom.text)) {
                              return "Target price should be greater than entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) >=
                                double.parse(
                                    _sellBuyPriceControllerCom.text)) {
                              return "Target price should be less than entry price";
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.sl0o,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _slController0Com,
                        decoration: InputDecoration(
                          hintText: Strings.sl0o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter SL Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceControllerCom.text)) {
                              return "SL price should be greater then entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceControllerCom.text)) {
                              return "SL price should be less then entry price";
                            }
                          }
                        },
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _slController1Com,
                        decoration: InputDecoration(
                          hintText: Strings.sl1o,
                          labelText: Strings.sl1o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Second SL Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceControllerCom.text)) {
                              return "SL price should be greater then entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceControllerCom.text)) {
                              return "SL price should be less then entry price";
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.desc,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: Strings.desc + "(Optional)",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.fcp,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         TextFormField(
              //           keyboardType: TextInputType.number,
              //           controller: _fcpControllerCom,
              //           decoration: InputDecoration(
              //             hintText: Strings.fcp,
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              _sendButton()
            ],
          ),
        ),
      ),
    );
  }

  //--------COMMODITY  FORM-----------
  Widget currencyForm() {
    // Provider.of<NewCallPageServices>(context, listen: false)
    //     .updateLtp(Strings.currency);
    return Form(
      key: _currencyKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _analysisUpload(),
              SizedBox(
                height: 20,
              ),
              _orderTypeParent(),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<InstrumentSearchPageService>(context,
                              listen: false)
                          .setType(Strings.currency);
                      Provider.of<InstrumentSearchPageService>(context,
                              listen: false)
                          .clearList();
                      Navigator.push(context,
                          fadePageRoute(context, InstrumentSearchPage()));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                Strings.stockName,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Consumer<NewCallPageServices>(
                                builder: (context, ncps, chil) {
                                  _stocknamecontrollerCur.text =
                                      ncps.getCurr().tradingsymbol;
                                  tradingSymbolCurr =
                                      ncps.getCurr().tradingsymbol;
                                  exchangeCurr = ncps.getCurr().exchange;
                                  instrumentTokenCurr =
                                      ncps.getCurr().instrument_token;

                                  return TextFormField(
                                    enabled: false,
                                    controller: _stocknamecontrollerCur,
                                    decoration: InputDecoration(
                                      hintText: Strings.stockName,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    // ignore: missing_return
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Enter Stock Name";
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Consumer<NewCallPageServices>(
                          builder: (context, ncps, child) {
                            // ncps.updateLtp(ncps.getEquity().instrument_token,Strings.equity);
                            return RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "Ltp: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: ncps.getCurrLtp(),
                                        style:
                                            TextStyle(color: Colors.deepPurple))
                                  ]),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.cmp,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         TextFormField(
              //           keyboardType: TextInputType.number,
              //           controller: _cmpControllerCur,
              //           decoration: InputDecoration(
              //             hintText: Strings.cmp,
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.futureoroption,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         fnoRadio(),
              //       ],
              //     ),
              //   ),
              // ),
              // Consumer<NewCallPageServices>(
              //   builder: (context, ncps, child) {
              //     return ncps.getFno() == 1
              //         ? Column(
              //             children: [
              //               SizedBox(
              //                 height: 20,
              //               ),
              //               Container(
              //                 decoration: fieldDecoration(),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: callPutRadio(),
              //                 ),
              //               ),
              //             ],
              //           )
              //         : Container();
              //   },
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.month,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         _selectMonth(),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.type,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      buySellRadio(),
                    ],
                  ),
                ),
              ),
              // Consumer<NewCallPageServices>(
              //   builder: (context, ncps, child) {
              //     return ncps.getFno() == 1
              //         ? Column(
              //             children: [
              //               SizedBox(
              //                 height: 20,
              //               ),
              //               Container(
              //                 decoration: fieldDecoration(),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Column(
              //                     crossAxisAlignment:
              //                         CrossAxisAlignment.stretch,
              //                     children: [
              //                       Text(Strings.strikePrice,
              //                           style: TextStyle(
              //                               fontWeight: FontWeight.w600)),
              //                       TextFormField(
              //                         keyboardType: TextInputType.number,
              //                         controller: _strikeControllerCur,
              //                         decoration: InputDecoration(
              //                           hintText: Strings.strikePrice,
              //                           border: InputBorder.none,
              //                           focusedBorder: InputBorder.none,
              //                           enabledBorder: InputBorder.none,
              //                           disabledBorder: InputBorder.none,
              //                         ),
              //                         // ignore: missing_return
              //                         validator: (String value) {
              //                           if (value.isEmpty) {
              //                             return "Enter Stike Price";
              //                           }
              //                         },
              //                       )
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           )
              //         : Container();
              //   },
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.entryPriceo,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _sellBuyPriceControllerCur,
                        decoration: InputDecoration(
                          hintText: Strings.entryPriceo,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Buying Selling Price";
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.target0o,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _targetController0Cur,
                        decoration: InputDecoration(
                          hintText: Strings.target0o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Target Price";
                          }

                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceControllerCur.text)) {
                              return "Target price should be greater than entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceControllerCur.text)) {
                              return "Target price should be less than entry price";
                            }
                          }
                        },
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _targetController1Cur,
                        decoration: InputDecoration(
                          hintText: Strings.target1o,
                          labelText: Strings.target1o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Second Target Price";
                          }

                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) <=
                                double.parse(
                                    _sellBuyPriceControllerCur.text)) {
                              return "Target price should be greater than entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) >=
                                double.parse(
                                    _sellBuyPriceControllerCur.text)) {
                              return "Target price should be less than entry price";
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.sl0o,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _slController0Cur,
                        decoration: InputDecoration(
                          hintText: Strings.sl0o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter SL Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceControllerCur.text)) {
                              return "SL price should be greater then entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceControllerCur.text)) {
                              return "SL price should be less then entry price";
                            }
                          }
                        },
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _slController1Cur,
                        decoration: InputDecoration(
                          hintText: Strings.sl1o,
                          labelText: Strings.sl1o,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Second SL Price";
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              1) {
                            if (double.parse(value.toString()) <=
                                double.parse(_sellBuyPriceControllerCur.text)) {
                              return "SL price should be greater then entry price";
                            }
                          }
                          if (Provider.of<NewCallPageServices>(context,
                                      listen: false)
                                  .getBuySell() ==
                              0) {
                            if (double.parse(value.toString()) >=
                                double.parse(_sellBuyPriceControllerCur.text)) {
                              return "SL price should be less then entry price";
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: fieldDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(Strings.desc,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: Strings.desc + "(Optional)",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   decoration: fieldDecoration(),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(Strings.fcp,
              //             style: TextStyle(fontWeight: FontWeight.w600)),
              //         TextFormField(
              //           keyboardType: TextInputType.number,
              //           controller: _fcpControllerCur,
              //           decoration: InputDecoration(
              //             hintText: Strings.fcp,
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              _sendButton()
            ],
          ),
        ),
      ),
    );
  }

  //---------SEND BUTTON-------
  Widget _sendButton() {
    return InkWell(
      splashColor: Colors.lightBlueAccent,
      onTap: () {
        _onSendButtonPressed();
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: ColorsTheme.primaryDark,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              Transform.rotate(
                angle: 270,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              TitleText(
                text: Strings.generate,
                color: Colors.white,
              ),
            ],
          )),
    );
  }

  //------------SHOW SUCCESS SNACKBAR------------
  void showSnackBar() {
    Navigator.pop(context);
    final snackBar = SnackBar(
      content: Text("Record Uploaded Successfully"),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  sendFunction(Map map) {
    final ncps = Provider.of<NewCallPageServices>(context, listen: false);
    ncps
        .sendCallToServer(
            Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
            map)
        .then((value) {
      if (value) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "Pick Uploaded Successfully",
            title: "Uploaded Successfully",
            barrierDismissible: false,
            onConfirmBtnTap: () {
              Provider.of<CallsPageService>(context, listen: false)
                  .setTitle(Strings.pending);
              Navigator.pushAndRemoveUntil(
                  context,
                  fadePageRoute(context, CallsPage()),
                  (Route<dynamic> route) => route.isFirst);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => MyHomePage()));
            });
      } else {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "Failed To Upload Pick",
            title: "Upload Failed",
            barrierDismissible: false,
            onConfirmBtnTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  fadePageRoute(context, HomePage()),
                  (Route<dynamic> route) => route.isFirst);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => MyHomePage()));
            });
      }
    });
  }

  //---------ON SEND BUTTON PRESSED-----------
  void _onSendButtonPressed() async {
    openProcessingDialog(context);
    final ncps = Provider.of<NewCallPageServices>(context, listen: false);
    final _analysisImageUrl =
        Provider.of<AnalysisUploadService>(context, listen: false)
            .getDownloadUrl();
    final _analysisTitle =
        Provider.of<AnalysisTextService>(context, listen: false)
            .getSelectedText();
    var map = HashMap<dynamic, dynamic>();
    map["${Strings.recordType}"] = ncps.getOrderType();
    map["${Strings.subRecordType}"] = _typelist[_tabController.index];
    map["${Strings.buySell}"] = ncps.getBuySell();
    map["${Strings.status}"] = Strings.pending;
    map["${Strings.uid}"] = await SharedPreferenc().getUid();
    // if (_analysisImageUrl == null) {
    //   Toast.show("Please select an image first ", context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    //   Navigator.pop(context);
    //   return;
    // }

    map["${Strings.analysisImageUrl}"] = _analysisImageUrl;
    map["${Strings.analysisTitle}"] = _analysisTitle;
    map["${Strings.description}"] = _descriptionController.text;
    map["${Strings.entry_ltp}"] =
        Provider.of<TriMarketWatchLtpService>(context, listen: false)
            .getNormalLtp(instrumentToken);
    setState(() {
      switch (_typelist[_tabController.index]) {
        case Strings.equity:
          {
            if (_key.currentState.validate()) {
              if (_stocknamecontroller.text.isNotEmpty) {
                map["${Strings.scriptname}"] =
                    _stocknamecontroller.text.toString();
                // map["${Strings.scriptname}"] = "SBIN";
                map["${Strings.entryPrice}"] =
                    _sellBuyPriceController.text.toString();
                map["${Strings.target0}"] = _targetController0.text.toString();
                map["${Strings.target1}"] = _targetController1.text.toString();
                map["${Strings.sl0}"] = _slController0.text.toString();
                map["${Strings.sl1}"] = _slController1.text.toString();
                map["${SqliteKeywords.tradingsymbol}"] = tradingSymbol;
                map["${SqliteKeywords.exchange}"] = exchange;
                map["${SqliteKeywords.instrument_token}"] = instrumentToken;

                sendFunction(map);
                // } else {
                //   Toast.show("Enter Script Name ", context,
                //       duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
              }
            }

            break;
          }
        case Strings.fno:
          {
            if (_fnoKey.currentState.validate()) {
              if (_stocknamecontrollerFno.text.isNotEmpty) {
                map["${Strings.scriptname}"] =
                    _stocknamecontrollerFno.text.toString();
                map["${Strings.entryPrice}"] =
                    _sellBuyPriceControllerFno.text.toString();
                map["${Strings.target0}"] =
                    _targetController0Fno.text.toString();
                map["${Strings.target1}"] =
                    _targetController1Fno.text.toString();
                map["${Strings.sl0}"] = _slController0Fno.text.toString();
                map["${Strings.sl1}"] = _slController1Fno.text.toString();

                map["${Strings.futureoroption}"] = ncps.getFno();
                map["${Strings.callorput}"] = ncps.getcp();
                map["${Strings.month}"] = _selectedMonthValue;
                map["${SqliteKeywords.tradingsymbol}"] = tradingSymbolFno;
                map["${SqliteKeywords.exchange}"] = exchangeFno;
                map["${SqliteKeywords.instrument_token}"] = instrumentTokenFno;

                sendFunction(map);
              } else {
                Toast.show("Enter Script Name ", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
              }
            }

            break;
          }
        case Strings.commodity:
          {
            if (_commodityKey.currentState.validate()) {
              if (_stocknamecontrollerCom.text.isNotEmpty) {
                map["${Strings.scriptname}"] =
                    _stocknamecontrollerCom.text.toString();
                map["${Strings.entryPrice}"] =
                    _sellBuyPriceControllerCom.text.toString();
                map["${Strings.target0}"] =
                    _targetController0Com.text.toString();
                map["${Strings.target1}"] =
                    _targetController1Com.text.toString();
                map["${Strings.sl0}"] = _slController0Com.text.toString();
                map["${Strings.sl1}"] = _slController1Com.text.toString();

                map["${Strings.futureoroption}"] = ncps.getFno();
                map["${Strings.callorput}"] = ncps.getcp();
                map["${Strings.month}"] = _selectedMonthValue;
                map["${SqliteKeywords.tradingsymbol}"] = tradingSymbolComm;
                map["${SqliteKeywords.exchange}"] = exchangeComm;
                map["${SqliteKeywords.instrument_token}"] = instrumentTokenComm;

                sendFunction(map);
              } else {
                Toast.show("Enter Script Name ", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
              }
            }

            break;
          }
        case Strings.currency:
          {
            if (_currencyKey.currentState.validate()) {
              if (_stocknamecontrollerCur.text.isNotEmpty) {
                map["${Strings.scriptname}"] =
                    _stocknamecontrollerCur.text.toString();
                map["${Strings.entryPrice}"] =
                    _sellBuyPriceControllerCur.text.toString();
                map["${Strings.target0}"] =
                    _targetController0Cur.text.toString();
                map["${Strings.target1}"] =
                    _targetController1Cur.text.toString();
                map["${Strings.sl0}"] = _slController0Cur.text.toString();
                map["${Strings.sl1}"] = _slController1Cur.text.toString();

                map["${Strings.futureoroption}"] = ncps.getFno();
                map["${Strings.callorput}"] = ncps.getcp();
                map["${Strings.month}"] = _selectedMonthValue;
                map["${SqliteKeywords.tradingsymbol}"] = tradingSymbolCurr;
                map["${SqliteKeywords.exchange}"] = exchangeCurr;
                map["${SqliteKeywords.instrument_token}"] = instrumentTokenCurr;

                sendFunction(map);
              } else {
                Toast.show("Enter Script Name ", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
              }
            }

            break;
          }
      }
    });
    Navigator.pop(context);
  }

  checkForCertificate() async {
    await Future.delayed(Duration(milliseconds: 100));
    int ccheck =
        Provider.of<CertificatePageService>(context, listen: false).getC();
    if (ccheck != 1) {
      // FillCertificateDialog(context);
    }
  }

  checkForTimePermission() async {
    await Future.delayed(Duration(microseconds: 100));
    bool isNewCallPermission = NewCallPageServices().checkTime();
    if (!isNewCallPermission) {
      NoTimePermissionDialog(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _buySellSelectedButton = 0;
    _fnoSelectedButton = 0;
    _cpSelectedButton = 0;
    dateSelector();
    _tabController = new TabController(length: _typelist.length, vsync: this);

    checkForCertificate();
    Provider.of<AnalysisTextService>(context, listen: false).fetchData();
  }

  fieldDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: ColorsTheme.secondryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 0))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _typelist.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsTheme.primaryColor,
          title: Text(
            "New Call",
            style: GoogleFonts.aBeeZee(color: Colors.white),
          ),
          bottom: TabBar(
            unselectedLabelColor: ColorsTheme.secondryColor,
            labelColor: Colors.white,
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  Strings.equity,
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                child: Text(
                  Strings.fno,
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                child: Text(
                  Strings.commodity,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                child: Text(
                  Strings.currency,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: SafeArea(
          child: TabBarView(controller: _tabController, children: [
            equityForm(),
            fnoForm(),
            commodityForm(),
            currencyForm()
          ]),
        ),
      ),
    );
  }
}
