import 'package:admin/Resources/Color.dart';
import 'package:admin/Resources/FadePageRoute.dart';
import 'package:admin/pages/packages/NewPackage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPackageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, fadePageRoute(context, NewPackage({})));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: ColorsTheme.primaryColor.withOpacity(0.3),
                    offset: Offset(0, 0),
                    blurRadius: 12),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Package",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(color: ColorsTheme.primaryDark),
                ),
                Icon(
                  Icons.arrow_right,
                  color: ColorsTheme.primaryDark,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
