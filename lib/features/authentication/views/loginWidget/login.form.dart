import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:holink/constants/global.color.dart';
import 'package:holink/constants/sizes.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String dropDown = 'Parishioners';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: HexColor(tbrown),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButton<String>(
                value: dropDown,
                style: GoogleFonts.dmSans(color: HexColor(darkerBrown)),
                icon: null,
                onChanged: (String? newValue) {
                  setState(() {
                    dropDown = newValue!;
                  });
                },
                underline: Container(),
                items: const [
                  'Parishioners',
                  'Parish Staff',
                  'Diocese Staff',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: h6,
                        color: HexColor(darkerBrown),
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: GoogleFonts.dmSans(
                color: HexColor(darkerBrown),
                fontSize: h6,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor(tbrown)),
                borderRadius: BorderRadius.circular(3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor(tbrown)),
                borderRadius: BorderRadius.circular(3.0),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: GoogleFonts.dmSans(
                color: HexColor(darkerBrown),
                fontSize: h6,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor(tbrown)),
                borderRadius: BorderRadius.circular(3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor(tbrown)),
                borderRadius: BorderRadius.circular(3.0),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
