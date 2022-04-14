import 'dart:io';
import 'dart:typed_data';
import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/FadePageRoute.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/Services/AdvisorAccuracyService.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/Services/share_button_service.dart';
import 'package:admin/Services/trimarketwatch_ltp_service.dart';
import 'package:admin/dataClasses/CallsClas.dart';
import 'package:admin/pages/AnalysisDetailPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:share/share.dart';

class CallsCard extends StatefulWidget {
  CallsClass _call;
  int index;

  CallsCard(
    this._call,
    this.index,
  );

  @override
  CallsCardState createState() => CallsCardState(_call, index);
}

class CallsCardState extends State<CallsCard> {
  CallsClass _call;
  int index;
  GlobalKey _globalKey = new GlobalKey();

  CallsCardState(this._call, this.index) {
    // CallUpdateService().getLtp(_call.cid, index, widget.context);
  }

  _fetchLtp() async {
    DateTime _currentTime = DateTime.now();
    if (_currentTime.hour >= 16) {
      fetchLastLtp();
    } else {
      Provider.of<TriMarketWatchLtpService>(context, listen: false)
          .subscribe(_call.it);
    }
  }

  fetchLastLtp() {
    Provider.of<TriMarketWatchLtpService>(context, listen: false)
        .fetchBrokerLtp(_call.it, _call.exchange, _call.scriptName);
  }

  @override
  void initState() {
    super.initState();
    // Provider.of<CallsPageService>(context, listen: false)
    //     .getLtp(_call.cid, index);
    // Provider.of<TriMarketWatchLtpService>(context, listen: false)
    //     .setIts(_call.it, _call.cid);
    _fetchLtp();
  }

  final instance = FirebaseDatabase.instance.reference();

  Widget reco() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorsTheme.mazarineblue),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Text(
              _call.intra_cnc,
              style: GoogleFonts.aBeeZee(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  Widget status() {
    Color _color;
    switch (_call.status) {
      case Strings.active:
        {
          _color = Colors.orange;
          break;
        }
      case Strings.pending:
        {
          _color = Colors.yellow;
          break;
        }
      case Strings.targethit:
        {
          _color = Colors.green;
          break;
        }
      case Strings.lossBooked:
        {
          _color = Colors.red;
          break;
        }
    }
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _color,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
            child: Text(
              _call.status,
              style: GoogleFonts.aBeeZee(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
        Expanded(child: Container()),
        Text(
          DateFormat('hh:mm | dd-MM-yyyy').format(_call.time),
          maxLines: 2,
          style: GoogleFonts.aBeeZee(fontSize: 12, color: Colors.black),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            _shareCall();
          },
          child: IconShadowWidget(
            Icon(
              Icons.share,
              color: ColorsTheme.darkred,
            ),
            shadowColor: Colors.grey,
          ),
        )
      ],
    );
  }

  _shareCall() async {
    try {
      Provider.of<ShareButtonService>(context, listen: false)
          .setSharingMode(true, index);
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      File imgFile = new File('${instrument_location}/screenshot.png');
      imgFile.writeAsBytes(pngBytes);

      var urls = ['${instrument_location}/screenshot.png'];

      Share.shareFiles(
        urls,
        subject: 'Share Call',
        text: callSharingText,
        // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
      );
      Provider.of<ShareButtonService>(context, listen: false)
          .setSharingMode(false, 0);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  Widget aProfile() {
    String name =
        Provider.of<ProfileInfoServices>(context, listen: false).getFName() +
            " " +
            Provider.of<ProfileInfoServices>(context, listen: false).getLName();
    String url =
        Provider.of<ProfileInfoServices>(context, listen: false).geturl();
    //
    // Color _color;
    // String temp1 = _call.aacuracy.replaceAll("%", "");
    // int a = int.parse(temp1);
    // if (a <= 30) {
    //   _color = Colors.red;
    // } else if (a > 31 && a <= 50) {
    //   _color = Colors.orange;
    // } else if (a > 50) {
    //   _color = Colors.green;
    // }
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: url == null
                    ? Image.network(personImage)
                    : Image.network(url),
              ),
              title: Text(
                name,
                maxLines: 2,
                style: GoogleFonts.aBeeZee(),
              ),
            ),
          ),
          Consumer<AccuracyService>(builder: (context, snapshot, child) {
            snapshot.fetchAccuracy(_call.uid);

            Color _color;
            String temp1 =
                double.parse(snapshot.getAccuracy()).toStringAsFixed(3);
            double a = double.parse(temp1);
            if (a <= 30) {
              _color = Colors.red;
            } else if (a > 31 && a <= 50) {
              _color = Colors.orange;
            } else if (a > 50) {
              _color = Colors.green;
            }
            return RichText(
              text: TextSpan(
                  style: GoogleFonts.aBeeZee(fontSize: 12, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "${Strings.accuracy}: ",
                    ),
                    TextSpan(
                      text: temp1,
                      style: GoogleFonts.aBeeZee(fontSize: 12, color: _color),
                    )
                  ]),
            );
          })
        ],
      ),
    );
  }

  Widget ScriptName() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Container(
            child: Text(
              _call.scriptName,
              maxLines: 2,
              textAlign: TextAlign.left,
              style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Consumer<TriMarketWatchLtpService>(builder: (context, cps, child) {
            return RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Ltp: ",
                      ),
                      TextSpan(
                        text: cps.getNormalLtp(_call.it) == "null" ||
                                cps.getNormalLtp(_call.it) == null
                            ? "0.0"
                            : cps.getNormalLtp(_call.it),
                      )
                    ]));
          })
        ],
      ),
    );
  }

  Widget maxProLos_rrRatio() {
    double entrry = double.parse(_call.entryPrice);
    double sl = double.parse(_call.sl);
    double target = double.parse(_call.target);
    String rrString='';

    if (_call.buySell == 'buy') {
      double n = double.parse((entrry - sl).toString());
      double d = double.parse((target - entrry).toString());
      if (n > d) {
        n = n / d; //n:d
        d = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      } else {
        d = d / n; //d:n
        n = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      }
    }

    if (_call.buySell == 'sell') {
      double n = double.parse((sl - entrry).toString());
      double d = double.parse((entrry - target).toString());
      if (n > d) {
        n = n / d; //n:d
        d = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      } else {
        d = d / n; //d:n
        n = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      }
    }

    String maxLoss = (double.parse(_call.entryPrice) - double.parse(_call.sl))
        .toStringAsPrecision(3)
        .replaceAll("-", "");
    String maxProf =
        (double.parse(_call.entryPrice) - double.parse(_call.target))
            .toStringAsPrecision(3)
            .replaceAll("-", "");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: GoogleFonts.aBeeZee(color: Colors.red),
                          children: [
                            TextSpan(text: "${Strings.maxLoss}: "),
                            TextSpan(text: maxLoss)
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: GoogleFonts.aBeeZee(color: Colors.green),
                          children: [
                            TextSpan(text: "${Strings.maxProf}: "),
                            TextSpan(text: maxProf)
                          ])),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                      style: GoogleFonts.aBeeZee(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: "${Strings.rrration}: ",
                        ),
                        TextSpan(text: rrString, style: TextStyle(color: Colors.black))
                      ])),
            )
          ],
        ),
      ),
    );
  }

  Widget closedWith() {
    String title = "";
    String value = "";
    Color _color = Colors.white;

    if (_call.status == Strings.targethit) {
      title = "Closed with profit: ";
      value = (double.parse(_call.entryPrice) - double.parse(_call.target))
          .toString()
          .replaceAll("-", "");
      _color = Colors.green;
    }
    if (_call.status == Strings.lossBooked) {
      title = "Closed with loss: ";
      value = (double.parse(_call.entryPrice) - double.parse(_call.sl))
          .toString()
          .replaceAll("-", "");
      _color = Colors.red;
    }

    return Container(
      child: RichText(
          text: TextSpan(style: GoogleFonts.aBeeZee(color: _color), children: [
        TextSpan(text: title),
        TextSpan(text: value),
        TextSpan(text: "/Unit"),
      ])),
    );
  }

  Widget pricingDetails() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: _call.buySell == Strings.sell
                      ? Colors.red
                      : Colors.green),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _call.buySell,
                  style: GoogleFonts.aBeeZee(color: Colors.white),
                ),
              ),
            ),
          ),
          RichText(
              textAlign: TextAlign.center,
              maxLines: 2,
              text: TextSpan(
                  style: GoogleFonts.aBeeZee(color: Colors.black),
                  children: [
                    TextSpan(text: "${Strings.entryPriceo}: "),
                    TextSpan(text: _call.entryPrice),
                  ])),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: GoogleFonts.aBeeZee(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.t1}: \n"),
                            TextSpan(text: _call.target),
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: GoogleFonts.aBeeZee(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.t2}: \n"),
                            TextSpan(text: _call.target1),
                          ])),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: GoogleFonts.aBeeZee(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.s1}: \n"),
                            TextSpan(text: _call.sl),
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: GoogleFonts.aBeeZee(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.s2}: \n"),
                            TextSpan(text: _call.sl1),
                          ])),
                ),
              ],
            ),
          ),
          // _call.equityDerivative == Strings.equity
          //     ? Container()
          //     : Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: RichText(
          //             maxLines: 2,
          //             textAlign: TextAlign.center,
          //             text: TextSpan(
          //                 style: GoogleFonts.aBeeZee(color: Colors.black),
          //                 children: [
          //                   TextSpan(
          //                     text: "Expiry Date: ",
          //                   ),
          //                   TextSpan(
          //                     text: _call.expiryDate,
          //                   ),
          //                 ])),
          //       ),
          _call.status == Strings.targethit ||
                  _call.status == Strings.lossBooked
              ? closedWith()
              : Container()
        ],
      ),
    );
  }

  Widget qtLogoWidget() {
    return Container(
      height: 30,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/logo/quicktrades.png"),
          ),
          // SizedBox(width: 10,),
          Text(
            "Quicktrades",
            style: GoogleFonts.aBeeZee(color: Colors.black),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            fadePageRoute(
                context, AnalysisDetailPage(_call, index)));
      },
      child: RepaintBoundary(
        key: _globalKey,
        child: Container(
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
                qtLogoWidget(),
                status(),
                aProfile(),
                Divider(
                  color: Colors.grey,
                ),
                reco(),
                ScriptName(),
                maxProLos_rrRatio(),
                pricingDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
