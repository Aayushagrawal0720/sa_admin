import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/title_text.dart';
import 'package:admin/Services/calls_page_service.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/dataClasses/CallsClas.dart';
import 'package:admin/widgets/CallsCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CallsPage extends StatefulWidget {
  @override
  CallsPageState createState() => CallsPageState();
}

class CallsPageState extends State<CallsPage> {
  List<CallsClass> _calls = [];

  Widget _appbar() {
    return Consumer<CallsPageService>(
      builder: (context, cps, child) {
        return Row(
          children: <Widget>[
            BackButton(
              color: ColorsTheme.primaryColor,
            ),
            SizedBox(width: 20),
            TitleText(
              text: cps.getTitle(),
              color: ColorsTheme.primaryColor,
            )
          ],
        );
      },
    );
  }

  callsListView() {
    return Consumer<CallsPageService>(
      builder: (context, cps, child) {
        _calls = cps.getCalls();
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _calls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CallsCard(_calls[index], index),
                );
              }),
        );
      },
    );
  }

  Future<void> refreshPage() async {
    await Provider.of<CallsPageService>(context, listen: false).refreshFunction(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid());
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CallsPageService>(context, listen: false);
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: refreshPage,
        color: ColorsTheme.darkred,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _appbar(),
              FutureBuilder(
                  future: prov.fetchCalls2(
                      Provider.of<ProfileInfoServices>(context, listen: false)
                          .getuid()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var data = snapshot.data.toString();
                      if (data == "false") {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/other/error.png"),
                          ],
                        );
                      } else {
                        return callsListView();
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
                  })
            ],
          ),
        ),
      )),
    );
  }
}
