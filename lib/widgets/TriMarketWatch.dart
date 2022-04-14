import 'package:admin/Services/trimarketwatch_ltp_service.dart';
import 'package:admin/Services/trimartketwatch_ui_services.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TriMarketWatch extends StatefulWidget {
  @override
  TriMarketWatchState createState() => TriMarketWatchState();
}

class TriMarketWatchState extends State<TriMarketWatch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SocketIO socketIO;

  @override
  void initState() {
    super.initState();

    var triService =
        Provider.of<TriMarketWatchLtpService>(context, listen: false);

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    // triService.init();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        Provider.of<TriMarketWatchUiServices>(context, listen: false)
            .ExpandWidget();
      }
    });

    // //Creating the socket
    // socketIO = SocketIOManager().createSocketIO(
    //     'http://15.207.48.223:3300', '/',
    //     socketStatusCallback: (status) {});
    // //Call init before doing anything with socket
    // socketIO.init();
    //
    // socketIO.subscribe("tri_ltp", (data) {
    //   print(data);
    //   triService.setTicker(data);
    // });
    //
    // socketIO.connect();
  }

  Widget ColumnList() {
    GlobalKey _key = GlobalKey();
    return Consumer<TriMarketWatchLtpService>(
        key: _key,
        builder: (context, snapshot, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "NIFTY 50",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${snapshot.getNifty50()}",
                          style: GoogleFonts.aBeeZee(
                              color: Colors.black, fontSize: 18),
                        ),
                        Row(
                          children: [
                            Text(
                              snapshot.getNifty50Diff(),
                              style: GoogleFonts.aBeeZee(
                                  color: snapshot.getSensexPro()
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RichText(
                                text: TextSpan(
                                    style: GoogleFonts.aBeeZee(
                                        color: snapshot.getNifty50Pro()
                                            ? Colors.green
                                            : Colors.red),
                                    children: [
                                  TextSpan(text: snapshot.getNifty50Per()),
                                  TextSpan(text: "%")
                                ])),
                          ],
                        )
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     Text(
                    //       "NIFTY BANK",
                    //       style: GoogleFonts.aBeeZee(
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //     Text(
                    //       "${snapshot.getBankNiftyLtp()}",
                    //       style: GoogleFonts.aBeeZee(
                    //           color: Colors.black, fontSize: 18),
                    //     ),
                    //     Row(
                    //       children: [
                    //         Text(
                    //           snapshot.getBankNiftyDiff(),
                    //           style: GoogleFonts.aBeeZee(
                    //               color: snapshot.getSensexPro()
                    //                   ? Colors.green
                    //                   : Colors.red),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         RichText(
                    //             text: TextSpan(
                    //                 style: GoogleFonts.aBeeZee(
                    //                     color: snapshot.getBankNiftyPro()
                    //                         ? Colors.green
                    //                         : Colors.red),
                    //                 children: [
                    //               TextSpan(
                    //                 text: snapshot.getBankNiftyPer(),
                    //               ),
                    //               TextSpan(text: "%")
                    //             ])),
                    //       ],
                    //     )
                    //   ],
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SENSEX",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${snapshot.getSensexLtp()}",
                          style: GoogleFonts.aBeeZee(
                              color: Colors.black, fontSize: 18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.getSensexDiff(),
                              style: GoogleFonts.aBeeZee(
                                  color: snapshot.getSensexPro()
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RichText(
                                text: TextSpan(
                                    style: GoogleFonts.aBeeZee(
                                        color: snapshot.getSensexPro()
                                            ? Colors.green
                                            : Colors.red),
                                    children: [
                                      TextSpan(text: snapshot.getSensexPer()),
                                      TextSpan(text: "%")
                                    ])),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TriMarketWatchUiServices>(
        builder: (context, snapshot, child) {
      return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(0, 0),
                blurRadius: 12)
          ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Market Overview",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        snapshot.getExpanded()
                            ? _controller.reverse()
                            : _controller.forward();
                      },
                    )
                  ],
                ),
                snapshot.getExpanded() ? ColumnList() : Container(),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
