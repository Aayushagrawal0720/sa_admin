import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/SupportDialogs.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/Services/package_services.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:toast/toast.dart';

class NewPackage extends StatefulWidget {
  Map<String, dynamic> _data;

  NewPackage(this._data);

  @override
  NewPackageState createState() => NewPackageState(_data);
}

class NewPackageState extends State<NewPackage> {
  List<String> _durationList = [
    Strings.singleCall,
    Strings.oneDay,
    Strings.oneWeek,
    Strings.threeMonths,
    Strings.sixMonths,
    Strings.oneYear,
  ];

  Map<String, dynamic> _data;
  String duration;
  int index;

  NewPackageState(this._data) {
    duration = _data["ddItem"].toString();
    _pAmtController.text = _data["amt"] == '0' ? '' : _data["amt"].toString();
    index = _data["index"];
  }

  TextEditingController _pAmtController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  savepackageToServer() async {
    openProcessingDialog(context);

    String t = await Provider.of<PackageServices>(context, listen: false)
        .savePackageDataToServer(
            Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
            _data['pid'],
            _pAmtController.text,
            index);
    if (t != "success") {
      Toast.show("Some Error Occurred, Please Try After Sometime", context,
          gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context);
    Navigator.pop(context);
  }

  titleWidget() {
    return Text(
      "Create your own custom package",
      maxLines: 2,
      textAlign: TextAlign.left,
      style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 24),
    );
  }

  sendpackageButton() {
    return GestureDetector(
      onTap: () {
        if (_key.currentState.validate()) {
          if (_pAmtController.text.isEmpty ||
              _pAmtController.text == "0" ||
              _pAmtController.text == "") {
            Toast.show("Please Enter Correct Amount", context,
                gravity: Toast.TOP, duration: Toast.LENGTH_LONG);
            return;
          }
          savepackageToServer();
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsTheme.primaryDark,
                border: Border.all(color: Colors.white, width: 0.5),
                boxShadow: [
                  BoxShadow(
                      color: ColorsTheme.primaryColor.withOpacity(0.3),
                      offset: Offset(0, 0),
                      blurRadius: 12),
                ]),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "Add Package",
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  newPackageCard() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  color: ColorsTheme.secondryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 0))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    duration,
                    style: GoogleFonts.aBeeZee(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                  // return DropdownButton<String>(
                  //   items: _durationList.map((String dropDownStringItem) {
                  //     return DropdownMenuItem<String>(
                  //       child: Text(dropDownStringItem),
                  //       value: dropDownStringItem,
                  //     );
                  //   }).toList(),
                  //   onChanged: (String value) {
                  //     ps.setPackageDuration(value);
                  //   },
                  //   value: ps.getPackageDuration(),
                  // );

                  ),
              Row(
                children: [
                  Icon(
                    LineIcons.indianRupeeSign,
                    color: Colors.black,
                    size: 18,
                  ),
                  Expanded(
                    child: Form(
                      key: _key,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _pAmtController,
                        decoration: InputDecoration(
                          hintText: "Enter Package Amount",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Package Amount";
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              sendpackageButton()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // List<String> g =
    //     Provider.of<PackageServices>(context, listen: false).getDurations();
    // for (var gi in g) {
    //   _durationList.remove(gi);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsTheme.primaryColor,
        title: Text(
          "Edit Package",
          style: GoogleFonts.aBeeZee(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [titleWidget(), newPackageCard()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
