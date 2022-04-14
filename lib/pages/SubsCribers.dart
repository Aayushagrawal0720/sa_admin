import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/title_text.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/Services/subscribers_page_services.dart';
import 'package:admin/dataClasses/subscriber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Subscribers extends StatefulWidget {
  @override
  SubscribersState createState() => SubscribersState();
}

class SubscribersState extends State<Subscribers> {
  List<SubscribersClass> _subscribers = List();

  Widget subscriberListView() {
    return Consumer<SubscribersPageService>(
      builder: (context, sps, child) {
        _subscribers = sps.getSubscriber();
        return _subscribers == null
            ? Center(
                child: SpinKitDoubleBounce(
                  color: ColorsTheme.primaryDark,
                  size: 32,
                ),
              )
            : ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _subscribers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    ColorsTheme.secondryColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: Offset(0, 0))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            _subscribers[index].name,
                            style: GoogleFonts.aBeeZee(),
                          ),
                          leading: CircleAvatar(
                            child: Image(
                              image: NetworkImage(
                                _subscribers[index].url,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
      },
    );
  }

  Widget _appbar() {
    return Row(
      children: <Widget>[
        BackButton(
          color: ColorsTheme.primaryColor,
        ),
        SizedBox(width: 20),
        TitleText(
          text: "Your Subscribers",
          color: ColorsTheme.primaryColor,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshPage() async {
    Provider.of<SubscribersPageService>(context, listen: false).refreshFunction(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<SubscribersPageService>(context, listen: true);

    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: refreshPage,
        color: ColorsTheme.darkred,
        child: ListView(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            _appbar(),
            FutureBuilder(
                future: prov.fetchSubscriber2(
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
                      return subscriberListView();
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
      )),
    );
  }
}
