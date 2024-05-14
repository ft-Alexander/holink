import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:holink/constants/global.color.dart';
import 'package:holink/features/authentication/views/loginWidget/login.form.dart';
import 'package:holink/features/scheduling/view/scheduling.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Scheduling()),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(HexColor(tbrown)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          child: const Text(
            'Login',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: 'DM Sans', // Adjust the font family as needed
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        ElevatedButton(
          onPressed: () {
            // Add your login functionality here
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(HexColor(twhite)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(
                  color: HexColor(tbrown),
                  width: 1.0,
                ),
              ),
            ),
          ),
          child: Text(
            'Register',
            style: TextStyle(
              fontSize: 16.0,
              color: HexColor(tbrown),
              fontFamily: 'DM Sans', // Adjust the font family as needed
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        ElevatedButton(
          onPressed: () {
            // Add your login functionality here
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 16.0,
              color: HexColor(tbrown),
              fontFamily: 'DM Sans', // Adjust the font family as needed
            ),
          ),
        ),
      ],
    );
  }
}
