import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/FadePageRoute.dart';
import 'package:admin/pages/calls/NewCallPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewCallButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, fadePageRoute(context, NewCallPage()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: ColorsTheme.green,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: Offset(-1, 1),
                    blurRadius: 2),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New Call",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(color: Colors.white),
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
