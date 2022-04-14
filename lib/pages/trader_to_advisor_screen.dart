import 'package:admin/Resources/SupportDialogs.dart';
import 'package:admin/Services/api/quicktrades_tradertoadvisor.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TraderToAdvisorScreen extends StatefulWidget {
  @override
  _TraderToAdvisorScreenState createState() => _TraderToAdvisorScreenState();
}

class _TraderToAdvisorScreenState extends State<TraderToAdvisorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                      TextSpan(text: 'Hey! '),
                      TextSpan(text: 'Your are not registered as analyst.'),
                    ])),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "if you want to register as analyst then proceed otherwise you can visit viewer's application",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await LaunchApp.openApp(
                            androidPackageName: 'com.createwealth.trader',
                            // appStoreLink:
                            //     'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                            openStore: false);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  color: Colors.grey,
                                  blurRadius: 3)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: Text("Open viewer's app"),
                        ),
                      ),
                    ),
                    Consumer<QuicktradesTraderToAdvisor>(
                        builder: (context, snapshot, child) {
                          if(!snapshot.isLoading()){
                            if(snapshot.response()=='success'){
                              Navigator.pop(context);
                              Future.delayed(Duration(milliseconds: 200)).then((value) {
                                Navigator.pop(context);
                              });
                              // Navigator.pop(context);
                            }
                          }
                      return GestureDetector(
                        onTap: () {
                          openProcessingDialog(context);
                          snapshot.updateToAdvisor();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.deepPurple[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 0),
                                    color: Colors.grey,
                                    blurRadius: 3)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: Text(
                              "Proceed",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                )
              ],
            ),
          )),
        ),
      )),
    );
  }
}
