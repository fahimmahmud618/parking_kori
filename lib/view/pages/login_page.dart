import 'dart:convert';
import 'package:cache_manager/core/write_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking_kori/cache_handler.dart';
import 'package:parking_kori/view/pages/main_page.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/alert_dialog.dart';
import 'package:parking_kori/view/widgets/input_with_icon_image.dart';
import 'package:parking_kori/view/widgets/page_title.dart';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkCredential() async {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      myAlertDialog("Error!", "Username or password cannot be empty", context);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://parking-kori.rpu.solutions/api/v1/agent/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String token = responseData['token'];

        // Save token to shared preferences
        saveCache(username, password, token);
        // await saveToken(token);

        // Navigate to the home page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        // Login failed, show error message
        myAlertDialog("Error!", "Username or Password doesn't match", context);
      }
    } catch (e) {
      // Error occurred during HTTP request
      print('Error: $e');
      myAlertDialog("Error!", "An error occurred. Please try again later.", context);
    }
  }


  void saveCache(String username, String password, String token) {
    final cacheValue = caesarCipherEncode(makeCache(username, password), 2);
    WriteCache.setString(key: "cache", value: cacheValue);
    WriteCache.setString(key: "token", value: token);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Set to false to prevent overlapping with the keyboard
        body: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: get_screenWidth(context) * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(pkLogo, width: get_screenWidth(context) * 0.3),
                      PageTitle(context, "Log in"),
                      InputWIthIconImage(
                        context,
                        userLogo,
                        usernameController,
                        "Username",
                        "Username or Mobile number",
                        false,
                      ),
                      SizedBox(height: 30),
                      InputWIthIconImage(
                        context,
                        passLogo,
                        passwordController,
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
            ],
          ),
        ),
      ),
    );
  }
}
