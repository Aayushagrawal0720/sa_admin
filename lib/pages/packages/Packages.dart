import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/FadePageRoute.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/Services/package_services.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/Services/signin_register_services.dart';
import 'package:admin/dataClasses/PackageDataClass.dart';
import 'package:admin/pages/packages/NewPackage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';

class Packages extends StatefulWidget {
  @override
  PackagesState createState() => PackagesState();
}

class PackagesState extends State<Packages> {
  List<PackageDataClass> _pdc = List();
  List<String> _durationList = [
    Strings.singleCall,
    Strings.oneDay,
    Strings.oneWeek,
    Strings.threeMonths,
    Strings.sixMonths,
    Strings.oneYear,
  ];

  Widget PackageListTile(
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  color: ColorsTheme.secondryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 0))
            ],
          ),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Rs. ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                  text: _pdc[index].pamt,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text: "/ ${_pdc[index].duration}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ])),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Get access to calls at just Rs. ${_pdc[index].pamt}",
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                Map<String, dynamic> _data = {
                  "ddItem": _pdc[index].duration,
                  "amt": _pdc[index].pamt,
                  "index": index,
                  "pid": _pdc[index].pid,
                };
                Navigator.push(context,
                    fadePageRoute(
                        context, NewPackage(_data)));
              },
              child: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          )),
    );
  }

  //-------------APP BAR-------------
  Widget _appBar() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            BackButton(),
            Expanded(
              flex: 1,
              child: Center(
                  child: Image.asset(
                "assets/logo/quicktrades.png",
                height: 45,
              )),
            ),
            // NewPackageButton()
          ],
        ),
      ),
    );
  }

  doneButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: GestureDetector(
          onTap: () {
            // Provider.of<SigninRegisterServices>(context, listen: false)
            //     .setPackageDone();
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorsTheme.primaryDark,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Done",
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<PackageServices>(context, listen: false)
        .getPackageDataFromServer(
            Provider.of<ProfileInfoServices>(context, listen: false).getuid());
  }

  Future<void> refreshPage() async {
    await Provider.of<PackageServices>(context, listen: false).refreshFunction(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid());
    return true;
  }

  showErrorMessage() async {
    await Future.delayed(Duration(milliseconds: 200));
    Toast.show("Some Error Occur, Please Try After Sometime", context,
        duration: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
            onRefresh: refreshPage,
            child: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  _appBar(),
                  Consumer<PackageServices>(
                    builder: (context, snapshot, child) {
                      if (!snapshot.loading) {
                        {
                          try {
                            if (snapshot.getList().toString() == "error") {
                              showErrorMessage();
                            } else {
                              // _pdc.clear();
                              _pdc = snapshot.getList();
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Container(
                                  child: RefreshIndicator(
                                    onRefresh: refreshPage,
                                    color: ColorsTheme.darkred,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            ScrollPhysics(),
                                        itemCount: _pdc.length,
                                        itemBuilder: (context, index) {
                                          return PackageListTile(index);
                                        }),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            Toast.show(
                              "Some Error Occur, Please Try After Sometime",
                              context,
                              duration: Toast.LENGTH_LONG,
                            );
                            Navigator.pop(context);
                          }
                        }
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child: SpinKitDoubleBounce(
                              color: ColorsTheme.primaryDark, size: 24),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
