import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:holink/constants/global.color.dart';
import 'package:holink/constants/img.path.dart';
import 'package:holink/constants/sizes.dart';
import 'package:holink/constants/text.dart';

class LoginWelcome extends StatelessWidget {
  const LoginWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(holinkWelcome),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                loginText,
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: h1,
                  color: HexColor(tbrown),
                  letterSpacing: 2.8,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                loginDirection,
                style: GoogleFonts.dmSans(
                  fontSize: h7,
                  color: HexColor(tbrown),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
