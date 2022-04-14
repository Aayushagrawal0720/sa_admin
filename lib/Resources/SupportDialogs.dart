import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/FadePageRoute.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/Services/landing_page_services.dart';
import 'package:admin/Services/new_call_page_services.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/pages/CertificatePage.dart';
import 'package:admin/pages/packages/Packages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

openProcessingDialog(BuildContext cont) {
  Dialog dialog;

  dialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 150,
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: SpinKitDoubleBounce(
              color: ColorsTheme.primaryDark,
              size: 32,
            ),
          ),
        );
      },
    ),
  );

  showDialog(
      context: cont,
      builder: (BuildContext context) => dialog,
      barrierDismissible: false,
      useRootNavigator: false);
}

NoInternetDialog(BuildContext cont) {
  Dialog dialog;

  dialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 150,
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Text(
              "No Internet Connection\n Please Connect To Internet To Continue",
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    ),
  );

  showDialog(
      context: cont,
      builder: (BuildContext context) => dialog,
      barrierDismissible: false);
}

FillCertificateDialog(BuildContext cont) {
  Dialog dialog;

  dialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: WillPopScope(
      onWillPop: () async => false,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 200,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Update Your Certificate first",
                    style:
                        GoogleFonts.aBeeZee(color: Colors.black, fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          fadePageRoute(
                              context, CertificatePage(false)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorsTheme.darkred,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        child: Text(
                          'Go to certificate page',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aBeeZee(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );

  showDialog(
      context: cont,
      builder: (BuildContext context) => dialog,
      barrierDismissible: false);
}

NoTimePermissionDialog(BuildContext cont) {
  Dialog dialog;

  String message = "You cannot make a new call during off market";
  dialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 150,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<NewCallPageServices>(context, listen: false)
                            .setorderType(Strings.cnc);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: ColorsTheme.darkred,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: Offset(0, 0))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Text(
                              "Ok",
                              style: GoogleFonts.aBeeZee(color: Colors.white),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    ),
  );

  showDialog(
      context: cont,
      builder: (BuildContext context) => dialog,
      barrierDismissible: false);
}

openNoPackageDialog(BuildContext context) {
  Dialog dialog = Dialog(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            "You have not create any package yet.",
            textAlign: TextAlign.center,
            style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 22),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: 200));
                  Navigator.push(context,
                      fadePageRoute(
                          context, Packages()))
                      .then((value) {
                    final pageService = Provider.of<LandingPageServices>(
                        context,
                        listen: false);
                    pageService.fetchHomeScreen(
                        Provider.of<ProfileInfoServices>(context, listen: false)
                            .getuid());
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsTheme.darkred,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Text(
                      "Create package",
                      style: GoogleFonts.aBeeZee(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    ),
  );

  showDialog(
      context: context,
      builder: (conrtext) => dialog,
      barrierDismissible: false,
      useRootNavigator: false);
}
