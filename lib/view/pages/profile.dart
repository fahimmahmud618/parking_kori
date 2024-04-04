import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:parking_kori/cache_handler.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/appbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentUser="";
  String token='';
  Future<void> fetchDataFromCache() async {
    try {
      currentUser = await ReadCache.getString(key: "cache") ;
      token = await ReadCache.getString(key: "token");
      setState(() {
        currentUser = getUserNameFromChache(caesarCipherDecode(currentUser,2));
      });

    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    fetchDataFromCache();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBarWidget(context, "Profile"),
            Container(
              padding: EdgeInsets.all( get_screenWidth(context) * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hi, $currentUser", style: nameTitleStyle(context, myred),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
