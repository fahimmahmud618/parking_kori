import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:parking_kori/view/pages/flash_page.dart';
import 'package:parking_kori/view/styles.dart';

Widget AppBarWidget(BuildContext context, String title) {
  return Container(
    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
    color: myred,

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: nameTitleStyle(context, myWhite),
        ),
        TextButton.icon(
          onPressed: () async {
            
print("...................................");
String ghorardim = await ReadCache.getString(key: "token");
    print(ghorardim);
            DeleteCache.deleteKey("cache");
            DeleteCache.deleteKey("token");
            DeleteCache.deleteKey("id");
            DeleteCache.deleteKey("location_id");
            
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FlashPage()),
            );
          },
          icon: Icon(Icons.logout, color: myWhite,),
          label: Text("Logout", style: normalTextStyle(context, myWhite),), // Provide a proper label widget here
        ),
      ],
    ),
  );
}
