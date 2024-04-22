// ignore_for_file: avoid_unnecessary_containers, non_constant_identifier_names, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_kori/view/styles.dart';

Widget InputWIthIconImage2(
    BuildContext context,
    String icon,
    TextEditingController textEditingController,
    String title,
    String hinttext,
    bool isHide) {
  return Container(
    child: Column(
      children: [
        Row(
          children: [
            Image.asset(
              icon,
              height: get_screenWidth(context) * 0.04,
              width: get_screenWidth(context) * 0.04,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: TextStyle(
                  color: myBlack,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Myfont',
                  fontSize: get_screenWidth(context) * 0.04),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            border: Border(
              bottom: BorderSide(
                color:
                    Colors.black.withOpacity(0.7), // Specify your desired color
                width: 1, // Specify your desired width
              ),
            ),
          ),
          child: TextField(
            obscureText: isHide,
            controller: textEditingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hinttext,
              hintStyle: TextStyle(
                color: myBlack.withOpacity(0.5),
                fontSize: get_screenWidth(context) * 0.03,
                fontFamily: 'Myfont',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget InputWIthIconImage3(
    BuildContext context,
    String icon,
    TextEditingController textEditingController,
    String title,
    String hinttext,
    bool isHide) {
  return Container(
    child: Column(
      children: [
        Row(
          children: [
            Image.asset(
              icon,
              height: get_screenWidth(context) * 0.04,
              width: get_screenWidth(context) * 0.04,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: TextStyle(
                  color: myBlack,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Myfont',
                  fontSize: get_screenWidth(context) * 0.04),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            border: Border(
              bottom: BorderSide(
                color:
                    Colors.black.withOpacity(0.7), // Specify your desired color
                width: 1, // Specify your desired width
              ),
            ),
          ),
          child: TextField(
            obscureText: isHide,
            controller: textEditingController,
            keyboardType: TextInputType.number, // Set keyboard type to numeric
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ], // Only allow digits (0 to 9)
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hinttext,
              hintStyle: TextStyle(
                color: myBlack.withOpacity(0.5),
                fontSize: get_screenWidth(context) * 0.03,
                fontFamily: 'Myfont',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}



Widget regnum(BuildContext context, TextEditingController textEditingController){
  return Container(
      decoration: BoxDecoration(
        border: Border(
              bottom: BorderSide(
                color:
                    Colors.black.withOpacity(0.7), // Specify your desired color
                width: 1, // Specify your desired width
              ),
            ),
      ),
      child: Container(
        
        width: get_screenWidth(context) * 0.8,
        child: TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter Registration number here",
            hintStyle: TextStyle(
                      color: myBlack.withOpacity(0.5),
                      fontSize: get_screenWidth(context) * 0.03,
                      fontFamily: 'Myfont',
                    ),
            border: InputBorder.none,
            labelStyle: nameTitleStyle(context, myred),
            
          ),
          
        ),
      ),
    );
}

class InputWithIconImage extends StatefulWidget {
  final BuildContext context;
  final String icon;
  final TextEditingController textEditingController;
  final String title;
  final String hinttext;
  final bool isHide;

  const InputWithIconImage(
      {required this.context,
      required this.icon,
      required this.textEditingController,
      required this.title,
      required this.hinttext,
      required this.isHide});

  @override
  _InputWithIconImageState createState() => _InputWithIconImageState();
}

class _InputWithIconImageState extends State<InputWithIconImage> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                widget.icon,
                height: get_screenWidth(widget.context) * 0.04,
                width: get_screenWidth(widget.context) * 0.04,
              ),
              const SizedBox(width: 5),
              Text(
                widget.title,
                style: TextStyle(
                  color: myBlack,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Myfont',
                  fontSize: get_screenWidth(widget.context) * 0.04,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.7),
                  width: 1,
                ),
              ),
            ),
            child: TextField(
              obscureText: _isObscure,
              controller: widget.textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hinttext,
                hintStyle: TextStyle(
                  color: myBlack.withOpacity(0.5),
                  fontSize: get_screenWidth(widget.context) * 0.03,
                  fontFamily: 'Myfont',
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      // Toggle password visibility
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
