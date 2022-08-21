// ignore_for_file: prefer_const_constructors, file_names

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:xiz/utils/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hinText;
  final bool? ispassword;
  final TextInputType? type;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? isManyLine;

  const CustomTextFormField(
      {Key? key,
      this.hinText,
      this.ispassword = false,
      this.controller,
      this.validator,
      this.type = TextInputType.text,
      this.isManyLine = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: isManyLine! ? null : 1,
        // controller: numbercontroller,
        obscureText: ispassword! ? true : false,
        keyboardType: type,
        style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
        decoration: InputDecoration(
          errorStyle:
              TextStyle(color: Get.isDarkMode ? Colors.white : Colors.red),
          hintText: hinText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 5,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
