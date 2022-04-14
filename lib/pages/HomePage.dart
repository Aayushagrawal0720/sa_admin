import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/FadePageRoute.dart';
import 'package:admin/Services/api/quicktrades_notification_token.js.dart';
import 'package:admin/Services/home_screen_services.dart';
import 'package:admin/Services/landing_page_services.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/Services/wallet_balance_service.dart';
import 'package:admin/pages/LandingPage.dart';
import 'package:admin/pages/ProfilePage.dart';
import 'package:admin/pages/UserCheck.dart';
import 'package:admin/pages/WalletWithdraw.dart';
import 'package:admin/pages/packages/Packages.dart';
import 'package:admin/pages/trader_to_advisor_screen.dart';
import 'package:admin/sharedPrefrences/sharefPrefernces.dart';
import 'package:admin/widgets/FormText.dart';
import 'package:admin/widgets/NewCallButton.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'TransactionHistory/TransactionHistory.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String uid;
  String name;
  String email;
  String phoneNumber;
  String photoUrl;

  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  GlobalKey<ScaffoldState> _key = GlobalKey();

  Widget DrawerNavigation() {
    return Drawer(
        child: Column(
      children: <Widget>[
        Consumer<ProfileInfoServices>(
          builder: (BuildContext context, value, Widget child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, fadePageRoute(context, ProfilePage()));
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 12,
                        backgroundImage: NetworkImage(
                          value.geturl() == null || value.geturl() == ""
                              ? "https://firebasestorage.googleapis.com/v0/b/stockadvisory-f4983.appspot.com/o/profile_photo%2Fperson.png?alt=media&token=8633f6ac-c739-441e-a425-59311f2f8373"
                              : value.geturl(),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FormText(
                        text: value.getFName() == null
                            ? ""
                            : value.getFName() + " " + value.getLName(),
                      ),
                      FormText(
                        text: value.getemail() == null ? "" : value.getemail(),
                      ),
                      FormText(
                        text: value.getphone() == null ? "" : value.getphone(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Profile",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.grey,
                                decoration: TextDecoration.underline),
                          ),
                          Icon(
                            Icons.arrow_right,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        navigationList()
      ],
    ));
  }

  Widget navigationList() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            LineIcons.moneyBill,
            color: ColorsTheme.primaryDark,
          ),
          title: Text("Withdraw"),
          onTap: () {
            Navigator.push(context, fadePageRoute(context, WalletWithdraw()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.monetization_on,
            color: ColorsTheme.primaryDark,
          ),
          title: Text("Your Packages"),
          onTap: () {
            Navigator.push(context, fadePageRoute(context, Packages()));
          },
        ),
        ListTile(
          leading: Icon(
            LineIcons.listUl,
            color: ColorsTheme.primaryDark,
          ),
          title: Text("Transaction History"),
          onTap: () {
            Navigator.push(
                context, fadePageRoute(context, TransactionHistory()));
          },
        ),
        ListTile(
          leading: Icon(
            LineIcons.alternateSignOut,
            color: ColorsTheme.primaryDark,
          ),
          title: Text("Log Out"),
          onTap: () {
            // Provider.of<SigninWithPhoneNumber>(context, listen: false)
            //     .signOut();
            Navigator.push(context, fadePageRoute(context, UserCheck()));
          },
        ),
      ],
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
            SizedBox(width: 15),
            GestureDetector(
              onTap: () {
                _key.currentState.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: ColorsTheme.darkred,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                  child: Image.asset(
                "assets/logo/quicktrades.png",
                height: 45,
              )),
            ),
            NewCallButton()
          ],
        ),
      ),
    );
  }

  loadingbox() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: SpinKitDoubleBounce(
          color: ColorsTheme.primaryDark,
          size: 32,
        ),
      ),
    );
  }

  mainPage() {
    // String uuid =
    //     Provider.of<ProfileInfoServices>(context, listen: false).getuid();
    // Provider.of<HomeScreenServices>(context, listen: false)
    //     .checkUserUid(uuid)
    //     .then((value) {
    //   if (value == "uid exists") {}
    //   if (value == "user not found") {
    //     Provider.of<SigninWithPhoneNumber>(context, listen: false).signOut();
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => UserCheck()));
    //   }
    // });

    return Scaffold(
      key: _key,
      drawer: DrawerNavigation(),
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: refreshLangingPage,
        color: ColorsTheme.darkred,
        child: ListView(
          shrinkWrap: true,
          children: [
            _appBar(),
            LandingPage(),
          ],
        ),
      )),
    );
  }

  Future<void> refreshLangingPage() async {
    await Provider.of<LandingPageServices>(context, listen: false).refreshPage(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid());
    Provider.of<WalletBalanceService>(context, listen: false)
        .fetchBalance('wallet');
    return true;
  }

  Widget LoadingView() {
    return Scaffold(
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
  }

  getToken() async {
    String token = await _fcm.getToken();
    if (token != null) {
      Provider.of<QuicktradesNotificationTokenService>(context, listen: false)
          .setNotificationToken(token);
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    Provider.of<ProfileInfoServices>(context, listen: false).fetchInfo();
    Provider.of<HomeScreenServices>(context, listen: false)
        .checkUserUid()
        .then((value) async {
      if (value == 'usertype') {
        await Future.delayed(Duration(milliseconds: 200));
        Navigator.push(
            context, fadePageRoute(context, TraderToAdvisorScreen()));
      }
    });

    Provider.of<WalletBalanceService>(context, listen: false)
        .fetchBalance('wallet');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ProfileInfoServices>(context, listen: false)
            .fetchInfo(),
        builder: (context, snapshot) {
          if (ConnectionState.done == snapshot.connectionState) {
            return mainPage();
          }
          return Scaffold(
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
