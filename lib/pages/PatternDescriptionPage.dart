import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:admin/Resources/Color.dart';
import 'package:admin/Services/analysis_title_detail_service.dart';

class PatternDescription extends StatefulWidget {
  String _title;

  PatternDescription(this._title);

  @override
  _PatternDescriptionState createState() => _PatternDescriptionState(_title);
}

class _PatternDescriptionState extends State<PatternDescription> {
  String _title;

  _PatternDescriptionState(this._title);

  @override
  void initState() {
    super.initState();
    Provider.of<AnalysisTitleDetailService>(context, listen: false)
        .fetchDetails(_title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Consumer<AnalysisTitleDetailService>(
                    builder: (context, snapshot, child) {
                  return snapshot.isLoading()
                      ? SpinKitChasingDots(
                          color: ColorsTheme.darkred,
                        )
                      : Column(
                          children: [
                            snapshot.getImg() == null
                                ? Container()
                                : snapshot.getImg() == "img"
                                ? Container()
                                : Image.network(
                                    snapshot.getImg(),
                                    width: MediaQuery.of(context).size.width,
                                  ),
                            snapshot.getImg() == null
                                ? Container()
                                : snapshot.getImg() == "img"
                                    ? Container()
                                    : SizedBox(
                                        height: 10,
                                      ),
                            Text(
                              snapshot.getDetails(),
                              style: GoogleFonts.roboto(fontSize: 18),
                            ),
                          ],
                        );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
