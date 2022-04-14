import 'package:admin/Resources/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InstrumentLoadingPage extends StatefulWidget {
  @override
  InstrumentLoadingPageState createState() => InstrumentLoadingPageState();
}

class InstrumentLoadingPageState extends State<InstrumentLoadingPage> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Provider.of<InstrumentFetchService>(context, listen: false).fetchCalls2();
    return Scaffold(
      key: _key,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo/quicktrades.png",
              scale: 6,
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(ColorsTheme.darkred),
              ),
            ),
            Text(
              "Fetching instruments\nIt may take less then a minute",
              textAlign: TextAlign.center,
              style: GoogleFonts.abel(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
