import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:parking_kori/chache_handler.dart';
import 'package:parking_kori/view/image_file.dart';
import 'package:parking_kori/view/pages/home_page.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/action_button.dart';
import 'package:parking_kori/view/widgets/alert_dialog.dart';
import 'package:parking_kori/view/widgets/input_with_icon_image.dart';
import 'package:parking_kori/view/widgets/parking_kori_nameplate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameORmobile = new TextEditingController();
  TextEditingController password = new TextEditingController();

  void saveCache() {
    WriteCache.setString(
        key: "cache",
        value: caesarCipherEncode(
            makeCache(usernameORmobile.text, password.text), 2));
  }

  void checkCredential() {
    //TODO Sadia: Check Credential
    if (usernameORmobile.text.isEmpty || password.text.isEmpty) {
      myAlertDialog("Error!", "Username or password cannot be empty", context);
    } else if (usernameORmobile.text == "iit" && password.text == "123") {
      saveCache();
      go_to_home_page();
    } else
      myAlertDialog("Error!", "Username or Password doesn't matched", context);
  }

  void go_to_home_page() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: get_screenWidth(context)*0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ParkingKoriNameplate(context),
              Image.asset(carLogo,

              ),
              InputWIthIconImage(context, userLogo, usernameORmobile, "Username", "Username or Mobile number", false),
              SizedBox(height: 30,),
              InputWIthIconImage(context, passLogo, password, "Password", "Password", true),
              SizedBox(height: 20,),
              ActionButton(context, "Login", checkCredential),
            ],
          ),
        ),
      ),
    ));
  }
}
