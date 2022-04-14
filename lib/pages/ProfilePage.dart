import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/keywords.dart';
import 'package:admin/Services/profile_page_service.dart';
import 'package:admin/pages/CertificatePage.dart';
import 'package:admin/pages/EditProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  profileSegment() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: ColorsTheme.secondryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 0))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Consumer<ProfilePageService>(
            builder: (context, pps, child) {
              Map<String, String> _map = pps.getProfile();
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          pps.url == null || pps.url == ""
                              ? "https://firebasestorage.googleapis.com/v0/b/stockadvisory-f4983.appspot.com/o/profile_photo%2Fperson.png?alt=media&token=8633f6ac-c739-441e-a425-59311f2f8373"
                              : pps.url,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _map[Strings.fname] + ' ' + _map[Strings.lname],
                            style: GoogleFonts.aBeeZee(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _map[Strings.email],
                            style: GoogleFonts.aBeeZee(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _map[Strings.phone],
                            style: GoogleFonts.aBeeZee(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => EditProfile()));
                  //     },
                  //     child: Icon(Icons.edit))
                ],
              );
            },
          ),
        ),
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
      appBar: AppBar(
        backgroundColor: ColorsTheme.green,
        title: Text(
          "Personal Details",
          style: GoogleFonts.aBeeZee(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
              future: Provider.of<ProfilePageService>(context, listen: false)
                  .fetchProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: <Widget>[
                      profileSegment(),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25),
                      //   child: Container(
                      //     decoration: BoxDecoration(color: Colors.white,
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.grey.withOpacity(0.5),
                      //           )
                      //         ]),
                      //     child: ListTile(
                      //       title: Text(
                      //         Strings.certificate,
                      //         style: GoogleFonts.aBeeZee(color: Colors.black),
                      //       ),
                      //       onTap: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     CertificatePage(false)));
                      //       },
                      //       trailing: Icon(Icons.arrow_right),
                      //     ),
                      //   ),
                      // ),
                    ],
                  );
                }
                return Text("Fetching profile...");
              }),
        ),
      ),
    );
  }
}
