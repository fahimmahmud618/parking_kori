import 'dart:convert';
import 'dart:io'; // Import 'dart:io' for HttpClient
import 'package:cache_manager/core/write_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  String? baseUrl = dotenv.env['BASE_URL'];

  void checkCredential() async {
    final username = usernameController.text;
    final password = passwordController.text;
    String token = '';
    int id = 0;
    int locationId = 0;
    String myAddress = "";

    if (username.isEmpty || password.isEmpty) {
      myAlertDialog("Error!", "Username or password cannot be empty", context);
      return;
    }

    try {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) =>
                true; // Temporarily bypass SSL verification

      final response = await client.postUrl(
        Uri.parse('$baseUrl/agent/login'),
      )
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }));

      final httpResponse = await response.close();

      if (httpResponse.statusCode == 200) {
        
        Map<String, dynamic> responseData =
            jsonDecode(await httpResponse.transform(utf8.decoder).join());
        token = responseData['token'];
        id = responseData['data'][0]['id'];
        locationId = responseData['data'][0]['location_id'];
        myAddress = responseData['data'][0]['location']['title'];

        saveCache(username, password, token, id, locationId, myAddress);
        // await DatabaseHelper().loadParkLogDataFromRemoteDB();

        // print("Logged in properly");

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
      int locationId, String myAddress) {
    final cacheValue = caesarCipherEncode(makeCache(username, password), 2);
    WriteCache.setString(key: "cache", value: cacheValue);
    WriteCache.setString(key: "token", value: token);
    WriteCache.setInt(key: "id", value: id);
    WriteCache.setInt(key: "locationId", value: locationId);
    WriteCache.setString(key: "address", value: myAddress);
    DateTime currentTime = DateTime.now();
    WriteCache.setInt(
        key: "loginTime", value: currentTime.millisecondsSinceEpoch);

    //print(ReadCache.getString(key: "id"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // Set to false to prevent overlapping with the keyboard
        body: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
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
                      InputWIthIconImage2(
                        context,
                        userLogo,
                        usernameController,
                        "Username",
                        "Enter username or number",
                        false,
                      ),
                      SizedBox(height: 30),
                      InputWithIconImage(
                          context: context,
                          icon: passLogo,
                          textEditingController: passwordController,
                          title: "Password",
                          hinttext: "Enter password",
                          isHide: true),
                      // InputWIthIconImage2(
                      //   context,
                      //   passLogo,
                      //   passwordController,
                      //   "Password",
                      //   "Password",
                      //   true,
                      // ),

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
