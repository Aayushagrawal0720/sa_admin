import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/SupportDialogs.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/Resources/title_text.dart';
import 'package:admin/Services/payment_withdraw_services.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WalletWithdraw extends StatefulWidget {
  @override
  WalletWithdrawState createState() => WalletWithdrawState();
}

class WalletWithdrawState extends State<WalletWithdraw> {
  TextEditingController contoller_amt = TextEditingController();
  TextEditingController contoller_upi = TextEditingController();
  TextEditingController contoller_accNo = TextEditingController();
  TextEditingController contoller_ifsc = TextEditingController();
  TextEditingController contoller_accHolderName = TextEditingController();

  Dialog dialog;
  bool paymentDetailsFetched = false;

  WalletWithdrawState();

  GlobalKey<FormState> _formKey = GlobalKey();

  List<String> aaList = [Strings.saving, Strings.current];
  String selectedDropDownitem = Strings.saving;
  GlobalKey<ScaffoldState> _scafffold = GlobalKey();

  sendWithDrawRequestToServer() async {
    openProcessingDialog(context);

    var result = await Provider.of<PaymentWithdrawServices>(context,
            listen: false)
        .sendWithdrawRequestToServer(
            contoller_amt.text,
            Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
            contoller_upi.text,
            contoller_accNo.text,
            contoller_accHolderName.text,
            selectedDropDownitem,
            contoller_ifsc.text);
    Navigator.pop(context);
    switch (result) {
      case 'insufficient balance':
        {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              text: "Withdraw Failed",
              title: "Insufficient Balance!",
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => MyHomePage()));
              });
          break;
        }
      case 'success':
        {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text:
                  "Amount will be credited to your bank within 2-3 working days",
              title: "Withdraw request sent successfully",
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => MyHomePage()));
              });
          break;
        }
      default:
        {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "Please try after sometime",
              title: "Failed to withdraw balance",
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => MyHomePage()));
              });
          break;
        }
    }
  }

  Future showSuccessDialog() async {
    Navigator.pop(context);
    dialog = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: 150,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(Icons.done),
                    ),
                    Text(
                      "Details Saved Successfully",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Amount Will Be Credited To Your Bank Within 24 hrs",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ));
        }));

    showDialog(context: context, builder: (BuildContext context) => dialog);
    await new Future.delayed(new Duration(seconds: 2));
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  //-------------REQUEST BUTTON--------------
  Widget _requestButton() {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Wrap(
            children: <Widget>[
              TitleText(
                text: Strings.submit,
                color: Colors.white,
              ),
            ],
          )),
      onTap: () {
        if (_formKey.currentState.validate()) {
          sendWithDrawRequestToServer();
        }
      },
    );
  }

//----------WITHDRAW DETAILS FORM-------------
  Widget paymentDetailForm() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: <Widget>[
              Text('Amount', style: TextStyle(fontWeight: FontWeight.w600)),
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: contoller_amt,
                  decoration: InputDecoration(
                    hintText: '50000',
                  ),
                  // ignore: missing_return
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Please Enter Amount";
                    } else {
                      if (double.parse(text) == 0) {
                        return "Please Enter Amount";
                      }
                    }
                  },
                  onChanged: (text) {
                    if (text.endsWith(".")) {
                      if (text.substring(0, text.length - 1).contains(".")) {
                        contoller_amt.text = text.substring(0, text.length - 1);
                      }
                    }
                  }),
              SizedBox(
                height: 20,
              ),
              Text(Strings.upiid,
                  style: TextStyle(fontWeight: FontWeight.w600)),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: contoller_upi,
                decoration: InputDecoration(
                  hintText: Strings.upiid,
                ),
                // ignore: missing_return
                validator: (text) {
                  if (text.isNotEmpty) {
                    if (!text.contains("@")) {
                      return "Please Enter Complete UPI ID";
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(Strings.accNumber,
                  style: TextStyle(fontWeight: FontWeight.w600)),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: contoller_accNo,
                decoration: InputDecoration(
                  hintText: Strings.accNumber,
                ),
                // ignore: missing_return
                validator: (text) {
                  if (text.isNotEmpty) {
                    if (double.parse(text) == 0) {
                      return "Please Enter Complete Account Number";
                    }
                  }
                  if (contoller_accHolderName.text.isNotEmpty ||
                      contoller_ifsc.text.isNotEmpty) {
                    if (text.isEmpty) {
                      return "Please Enter Account Number";
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(Strings.ifscCode,
                  style: TextStyle(fontWeight: FontWeight.w600)),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: contoller_ifsc,
                decoration: InputDecoration(
                  hintText: Strings.ifscCode,
                ),
                // ignore: missing_return
                validator: (text) {
                  if (contoller_accHolderName.text.isNotEmpty ||
                      contoller_accNo.text.isNotEmpty) {
                    if (text.isEmpty) {
                      return "Please Enter IFSC Code";
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(Strings.accHolderName,
                  style: TextStyle(fontWeight: FontWeight.w600)),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: contoller_accHolderName,
                decoration: InputDecoration(
                  hintText: Strings.accHolderName,
                ),
                // ignore: missing_return
                validator: (text) {
                  if (contoller_ifsc.text.isNotEmpty ||
                      contoller_accNo.text.isNotEmpty) {
                    if (text.isEmpty) {
                      return "Please Enter Account Holder Name";
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              accuntDropDown(),
            ],
          ),
        ));
  }

  //---------ACCOUNT TYPE DROPDOWN------------
  Widget accuntDropDown() {
    return Row(
      children: <Widget>[
        Text(
          "Account Type: ",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        DropdownButton<String>(
          items: aaList.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              child: Text(dropDownStringItem),
              value: dropDownStringItem,
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              selectedDropDownitem = value;
            });
          },
          value: selectedDropDownitem,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafffold,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  BackButton(),
                  SizedBox(width: 20),
                  TitleText(
                    text: Strings.withdraw,
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              paymentDetailForm(),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: _requestButton(),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
