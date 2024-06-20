import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:holink/constants/global.color.dart';
import 'package:holink/constants/sizes.dart';
import 'package:holink/features/parish/dashboard/view/dashboard.dart';
import 'package:holink/features/parish/scheduling/view/scheduling.dart';
import 'package:holink/features/parishioners/service_availment/view/service.dart';
import 'package:http/http.dart' as http;
import 'package:holink/dbConnection/localhost.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _msg = "";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  localhost localhostInstance = localhost();

  String dropDown = 'Parish Staff';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
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
            controller: _usernameController,
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
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          TextField(
            controller: _passwordController,
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
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 10.0),
          if (_msg.isNotEmpty)
            Center(
              child: Text(
                _msg,
                style: GoogleFonts.dmSans(
                  color: HexColor(tbrown),
                  fontSize: h6,
                ),
              ),
            ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              if (_usernameController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                setState(() {
                  _msg = "Username and Password are required";
                });
                return;
              }
              switch (dropDown) {
                case "Parish Staff":
                  loginParish();
                  break;
                case "Diocese Staff":
                  loginDiocese();
                  break;
                default:
                  break;
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(HexColor(tbrown)),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Service()),
              );
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(HexColor(twhite)),
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
              'Login as Guest',
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
      ),
    );
  }

  void loginParish() async {
    String url =
        "http://${localhostInstance.ipServer}/dashboard/myfolder/loginParish.php";

    String username = _usernameController.text;
    String password = _passwordController.text;

    final Map<String, dynamic> queryParams = {
      "username": username, // Pass username as string
      "password": password, // Pass password as string
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      if (response.statusCode == 200) {
        var user = jsonDecode(response.body); // return type listmap
        if (user.isNotEmpty) {
          await _storeParId(username, password);
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          }
        } else {
          if (mounted) {
            setState(() {
              _msg = "Invalid Username Or Password";
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _msg = "Error: ${response.statusCode}";
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _msg = "$error";
        });
      }
    }
  }

  void loginDiocese() async {
    String url =
        "http://${localhostInstance.ipServer}/dashboard/myfolder/loginDiocese.php";

    String username = _usernameController.text;
    String password = _passwordController.text;

    final Map<String, dynamic> queryParams = {
      "username": username, // Pass username as string
      "password": password, // Pass password as string
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      if (response.statusCode == 200) {
        var user = jsonDecode(response.body); // return type listmap
        if (user.isNotEmpty) {
          await _storeParId(username, password);
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Scheduling()),
            );
          }
        } else {
          if (mounted) {
            setState(() {
              _msg = "Invalid Username Or Password";
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _msg = "Error: ${response.statusCode}";
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _msg = "$error";
        });
      }
    }
  }

  void loginParishioners() async {
    String url =
        "http://${localhostInstance.ipServer}/dashboard/myfolder/loginParishioners.php";

    String username = _usernameController.text;
    String password = _passwordController.text;

    final Map<String, dynamic> queryParams = {
      "username": username, // Pass username as string
      "password": password, // Pass password as string
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      if (response.statusCode == 200) {
        var user = jsonDecode(response.body); // return type listmap
        if (user.isNotEmpty) {
          await _storeParId(username, password);
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Service()),
            );
          }
        } else {
          if (mounted) {
            setState(() {
              _msg = "Invalid Username Or Password";
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _msg = "Error: ${response.statusCode}";
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _msg = "$error";
        });
      }
    }
  }

  Future<void> _storeParId(String username, String password) async {
    String url =
        "http://${localhostInstance.ipServer}/dashboard/myfolder/getAccountId.php";

    final Map<String, dynamic> queryParams = {
      "username": username,
      "password": password,
    };

    try {
      http.Response response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success']) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('employeeId', data['par_id']);
        } else {
          print("Failed to fetch par_id: ${data['message']}");
        }
      } else {
        print("Server error: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching par_id: $error");
    }
  }
}
