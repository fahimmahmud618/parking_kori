import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:parking_kori/chache_handler.dart';
import 'package:parking_kori/view/styles.dart';
import 'package:parking_kori/view/widgets/back_button.dart';
import 'package:parking_kori/view/widgets/page_title.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentUser="";
  Future<void> fetchDataFromCache() async {
    try {
      currentUser = await ReadCache.getString(key: "cache") ;
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
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all( get_screenWidth(context) * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PageTitle(context, "Dashboard"),
                Text("Hi, $currentUser", style: nameTitleStyle(context, myred),)
              ],
            ),
          ),
        ],
      ),
    );
  }

}
