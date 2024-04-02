import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/pages/home_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/input_with_icon_image.dart';
import 'package:parking_kori/view/widgets/page_title.dart'; // Import HomePage if not already imported
// Import other necessary files if not already imported

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameORmobile = TextEditingController();
  TextEditingController password = TextEditingController();

  void checkCredential() async {
    try {
      final response = await http.post(
        Uri.parse('https://parking-kori.rpu.solutions/api/v1/agent/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': usernameORmobile.text,
          'password': password.text,
        }),
      );

      if (response.statusCode == 200) {
        // Login successful, navigate to home page or perform other actions
        print('Login successful');
        // Navigate to the home page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Login failed, show an error message
        print('Login failed');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error!'),
              content: Text('Username or Password does not match. Please try again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Error occurred during the HTTP request
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error!'),
            content: Text('An error occurred. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: get_screenWidth(context) * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ParkingKoriNameplate(context),
                Image.asset(carLogo),
                PageTitle(context, "Log in"),
                InputWIthIconImage(
                  context,
                  userLogo,
                  usernameORmobile,
                  "Username",
                  "Username or Mobile number",
                  false,
                ),
                SizedBox(height: 30),
                InputWIthIconImage(
                  context,
                  passLogo,
                  password,
                  "Password",
                  "Password",
                  true,
                ),
                SizedBox(height: 20),
                ActionButton(context, "Login", checkCredential),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
