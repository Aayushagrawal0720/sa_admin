import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/SupportDialogs.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/Services/certificate_page_service.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/sharedPrefrences/sharefPrefernces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';

class CertificatePage extends StatefulWidget {
  bool initialPage;

  CertificatePage(this.initialPage);

  @override
  CertificatePageState createState() => CertificatePageState();
}

class CertificatePageState extends State<CertificatePage> {
  TextEditingController licenceNo = TextEditingController();

  saveLicenceToStorage() {
    SharedPreferenc().setCertificateNumber(licenceNo.text);
    Provider.of<CertificatePageService>(context, listen: false).setTrue();
  }

  saveCertificateToServer() async {
    openProcessingDialog(context);
    String uid =
        Provider.of<ProfileInfoServices>(context, listen: false).getuid();

    bool done =
        await Provider.of<CertificatePageService>(context, listen: false)
            .sendCertificateToServer(uid, licenceNo.text);

    Navigator.pop(context);
    if (done) {
      saveLicenceToStorage();
      Provider.of<CertificatePageService>(context, listen: false)
          .getCertificateStatus(
              Provider.of<ProfileInfoServices>(context, listen: false)
                  .getuid());
      Provider.of<CertificatePageService>(context, listen: false).setTrue();
    } else {
      Toast.show("Some Error Occurred, Please Try After Sometime", context,
          duration: Toast.LENGTH_LONG);
    }
  }

  validateLicence() {
    if (licenceNo.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill your licence details")));
      Toast.show("Please Enter Your Licence Number", context,
          duration: Toast.LENGTH_LONG);
      return;
    }
    saveCertificateToServer();
  }

  Widget licenceWidget() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              enabled: widget.initialPage,
              controller: licenceNo,
              style: GoogleFonts.aBeeZee(color: Colors.black),
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintStyle: GoogleFonts.aBeeZee(),
                fillColor: Colors.blue,
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                hintText: 'Enter Your Licence Number',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              // ignore: missing_return
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    Provider.of<CertificatePageService>(context, listen: false)
        .getCertificateStatus(
            Provider.of<ProfileInfoServices>(context, listen: false).getuid());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferenc().getCertificateNumber(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              licenceNo.text = snapshot.data;
            }
            return Scaffold(
                    backgroundColor: Colors.deepPurple,
                    body: SafeArea(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                  child: Container()),
                              Text(
                                "CERTIFICATION LICENCE NUMBER",
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "For adviser verification we need your certification number.",
                                maxLines: 2,
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          offset: Offset(0, 0),
                                          blurRadius: 12)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        backgroundColor:
                                            Colors.deepPurple[400],
                                        radius: 22,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.card_membership,
                                            color: Colors.white,
                                          ),
                                        )),
                                    title: licenceWidget(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              GestureDetector(
                                onTap: () {
                                  validateLicence();
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple[600],
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "CONTINUE",
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          }

          return Scaffold(
            backgroundColor: Colors.deepPurple,
            body: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FractionallySizedBox(
                      heightFactor: 0.1,
                      child: Image.asset("assets/logo/quicktrades.png")),
                ),
                CircularProgressIndicator(),
              ],
            )),
          );
        });
  }
}
