import 'dart:convert';
import 'dart:io'; // Import 'dart:io' for HttpClient
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:cache_manager/core/write_cache_service.dart';
import 'package:flutter/material.dart';
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
    String token = '';
    int id = 0;
    int locationId = 0;

    if (username.isEmpty || password.isEmpty) {
      myAlertDialog("Error!", "Username or password cannot be empty", context);
      return;
    }

    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Temporarily bypass SSL verification

      final response = await client.postUrl(
        Uri.parse('https://parking-kori.rpu.solutions/api/v1/agent/login'),
      )
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }));

      final httpResponse = await response.close();

      if (httpResponse.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(await httpResponse.transform(utf8.decoder).join());
        token = responseData['token'];
        id = responseData['data'][0]['id'];
        locationId = responseData['data'][0]['location_id'];

        saveCache(username, password, token, id, locationId);

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
      // print(response.statusCode);
      myAlertDialog(
          "Error!", "An error occurred. Please try again later.", context);
    }
  }

  void saveCache(String username, String password, String token, int id,
      int locationId) {
    final cacheValue = caesarCipherEncode(makeCache(username, password), 2);
    WriteCache.setString(key: "cache", value: cacheValue);
    WriteCache.setString(key: "token", value: token);
    WriteCache.setInt(key: "id", value: id);
    WriteCache.setInt(key: "locationId", value: locationId);
    print(ReadCache.getString(key: "id"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: get_screenWidth(context) * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(pkLogo,
                          width: get_screenWidth(context) * 0.3),
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
            ),
          ],
        ),
      ),
    );
  }
}
