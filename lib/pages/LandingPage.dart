import 'dart:convert';

import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/FadePageRoute.dart';
import 'package:admin/Resources/SupportDialogs.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/Services/calls_page_service.dart';
import 'package:admin/Services/landing_page_services.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/Services/trimarketwatch_ltp_service.dart';
import 'package:admin/Services/wallet_balance_service.dart';
import 'package:admin/pages/CallsPage.dart';
import 'package:admin/pages/SubsCribers.dart';
import 'package:admin/widgets/TriMarketWatch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  SlidingCardController controller = SlidingCardController();

  final List<Feature> features = [
    Feature(
      title: "Drink Water",
      color: ColorsTheme.green,
      data: [0.2, 0.8, 0.4, 0.7, 0.6],
    ),
  ];

  Widget frontWalletCard(String amt) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(colors: [
            Colors.deepPurple,
            Colors.deepPurple[800],
            Colors.deepPurple[700],
          ], stops: [
            0.0,
            0.5,
            1.0
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Current Wallet Amt: ",
              style: GoogleFonts.aBeeZee(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: RichText(
                maxLines: 2,
                text: TextSpan(
                    style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                    children: [
                      TextSpan(text: "Rs."),
                      TextSpan(text: amt),
                    ])),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget backWalletcard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineGraph(
          features: features,
          size: Size(200, 130),
          labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
          labelY: [
            "1000",
            "2000",
            "3000",
            "4000",
            "5000",
          ],
          graphColor: Colors.white,
        ),
      ),
    );
  }

  Widget walletcard(String wallet) {
    return frontWalletCard(wallet);
  }

  centerCard(
      Color color, String title, String value, double width, String allCalls) {
    Color percentageColor;
    double percentage = (double.parse(value) / double.parse(allCalls)) * 100;
    if (percentage < 33) {
      percentageColor = Colors.red;
    } else if (percentage < 75) {
      percentageColor = Colors.orange;
    } else if (percentage <= 100) {
      percentageColor = Colors.green;
    }

    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height / 7,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: Colors.blue.withOpacity(
                0.3,
              ),
              width: 0.25),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                maxLines: 2,
                style: GoogleFonts.aBeeZee(color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    maxLines: 2,
                    style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  // Container(
                  //   height: 15,
                  //   child: VerticalDivider(
                  //     color: Colors.blue.withOpacity(0.9),
                  //   ),
                  // ),
                  // Text(
                  //   "${percentage.toStringAsFixed(2)}%",
                  //   maxLines: 2,
                  //   style: GoogleFonts.aBeeZee(
                  //       color: percentageColor, fontSize: 16),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      Positioned(
          right: 15,
          top: 15,
          child: Container(
            decoration: BoxDecoration(
                color: ColorsTheme.green.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.chevron_right,
              color: ColorsTheme.green,
            ),
          ))
    ]);
  }

  allCallsCard(Color color, String title, String value, Function task) {
    return GestureDetector(
      onTap: task,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: Colors.blue.withOpacity(
                0.3,
              ),
              width: 0.25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: GoogleFonts.aBeeZee(color: Colors.black),
                  ),
                  Text(
                    value,
                    maxLines: 2,
                    style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: ColorsTheme.green.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  Icons.chevron_right,
                  color: ColorsTheme.green,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  centercardsView1(String activeCalls, String pending, String allCalls) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<CallsPageService>(context, listen: false)
                    .setTitle(Strings.pending);
                Navigator.push(context, fadePageRoute(context, CallsPage()));
              },
              child: centerCard(Colors.white, "Pending calls", pending,
                  MediaQuery.of(context).size.width, allCalls),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<CallsPageService>(context, listen: false)
                    .setTitle(Strings.active);
                Navigator.push(context, fadePageRoute(context, CallsPage()));
              },
              child: centerCard(Colors.white, "Active calls", activeCalls,
                  MediaQuery.of(context).size.width, allCalls),
            ),
          ),
        ],
      ),
    );
  }

  centercardsView2(String profit, String loss, String allCalls) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<CallsPageService>(context, listen: false)
                    .setTitle(Strings.targethit);
                Navigator.push(context, fadePageRoute(context, CallsPage()));
              },
              child: centerCard(Colors.white, "Closed calls with profit",
                  profit, MediaQuery.of(context).size.width, allCalls),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<CallsPageService>(context, listen: false)
                    .setTitle(Strings.lossBooked);
                Navigator.push(context, fadePageRoute(context, CallsPage()));
              },
              child: centerCard(Colors.white, "Closed calls with loss", loss,
                  MediaQuery.of(context).size.width, allCalls),
            ),
          )
        ],
      ),
    );
  }

  subscribersCard(String subscribers) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, fadePageRoute(context, Subscribers()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.people,
                  color: ColorsTheme.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Subscribers",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      subscribers,
                      style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    )
                  ],
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.chevron_right,
                  color: ColorsTheme.green,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  walletSubscriberCard(String subscribers) {
    return Consumer<WalletBalanceService>(
      builder: (context, snapshot, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(-1, 1),
                      blurRadius: 4)
                ]),
            child: Column(
              children: [
                walletcard(snapshot.getWallet().toString()),
                Divider(
                  color: Colors.grey,
                ),
                subscribersCard(subscribers)
              ],
            ),
          ),
        );
      }
    );
  }

  callsSection(String activeCalls, String pendingCalls, String targetHit,
      String lossBooked, String allCalls) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(-1, 1),
                  blurRadius: 4)
            ]),
        child: Column(
          children: [
            allCallsCard(Colors.white, "All calls", allCalls, () {
              Provider.of<CallsPageService>(context, listen: false)
                  .setTitle(Strings.all);
              Navigator.push(context, fadePageRoute(context, CallsPage()));
            }),
            centercardsView1(activeCalls, pendingCalls, allCalls),
            centercardsView2(targetHit, lossBooked, allCalls),
          ],
        ),
      ),
    );
  }

  openDialog() async {
    await Future.delayed(Duration(milliseconds: 200));
    openNoPackageDialog(context);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LandingPageServices>(context, listen: false).fetchHomeScreen(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid());

    var triService =
        Provider.of<TriMarketWatchLtpService>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    // final pageService = Provider.of<LandingPageServices>(context, listen: true);

    return Consumer<LandingPageServices>(
      builder: (context, snapshot, child) {
        if (snapshot.getData() != null) {
          var data = snapshot.getData();
          if (data == "false") {
            return Column(
              children: [
                Container(
                  child: Image.asset("assets/other/error.png"),
                ),
              ],
            );
          } else {
            var jsonData = data;
            if (jsonData != null) {
              String amt = jsonData[Strings.wallet] == null
                  ? '0'
                  : jsonData[Strings.wallet];
              String subs = jsonData[Strings.subscribersCount].toString();
              String targetHit =
                  jsonData[Strings.closedCallsWithProfit].toString();
              String lossBooked =
                  jsonData[Strings.closedCallsWithloss].toString();
              String closedcalls =
                  (int.parse(targetHit) + int.parse(lossBooked)).toString();
              String pendingCalls = jsonData[Strings.pendingCalls].toString();
              String activeCalls = jsonData[Strings.activeCalls].toString();
              String allCalls = (int.parse(activeCalls) +
                      int.parse(closedcalls) +
                      int.parse(pendingCalls))
                  .toString();

              return Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TriMarketWatch(),
                      walletSubscriberCard(subs),
                      callsSection(activeCalls, pendingCalls, targetHit,
                          lossBooked, allCalls),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              );
            } else {
              Toast.show("No Record Found", context,
                  gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
            }
          }
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SpinKitDoubleBounce(
            color: ColorsTheme.primaryDark,
            size: 32,
          ),
        );
      },
    );
  }
}
