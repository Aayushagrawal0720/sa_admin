import 'package:admin/Resources/keywords.dart';
import 'package:admin/Services/instrument_search_page_service.dart';
import 'package:admin/Services/new_call_page_services.dart';
import 'package:admin/dataClasses/Instruments.dart';
import 'package:admin/widgets/instrumentCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstrumentSearchPage extends StatefulWidget {
  @override
  InstrumentSearchPageState createState() => InstrumentSearchPageState();
}

class InstrumentSearchPageState extends State<InstrumentSearchPage> {
  List<Instruments> fullList = List();
  List<Instruments> searchList = List();

  header() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 0.5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            BackButton(
              color: Colors.black,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: Strings.instrumenthint,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (text) {
                  Provider.of<InstrumentSearchPageService>(context,
                      listen: false)
                      .searchInstrument(
                    text,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  searchResult() {
    fullList.clear();
    return Container(
      child: Consumer<InstrumentSearchPageService>(
        builder: (context, isps, child) {
          fullList = isps.getInstruments();
          if (fullList == null) {
            return Container(
              child: Text("Empty"),
            );
          }
          return ListView.builder(
            itemCount: fullList.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    switch (isps.getType()) {
                      case Strings.equity:
                        {
                          Provider.of<NewCallPageServices>(context,
                              listen: false)
                              .setEquityScript(fullList[index]);
                          break;
                        }
                      case Strings.fno:
                        {
                          Provider.of<NewCallPageServices>(context,
                              listen: false)
                              .setFnoScript(fullList[index]);
                          break;
                        }
                      case Strings.commodity:
                        {
                          Provider.of<NewCallPageServices>(context,
                              listen: false)
                              .setCommScript(fullList[index]);
                          break;
                        }
                      case Strings.currency:
                        {
                          Provider.of<NewCallPageServices>(context,
                              listen: false)
                              .setCurrScript(fullList[index]);
                          break;
                        }
                    }
                    Navigator.pop(context);
                  },
                  child: instrumentcard(fullList[index]));
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
            children: [header(), searchResult()],
          )),
    );
  }
}