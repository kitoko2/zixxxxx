// ignore_for_file: file_names

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:xiz/utils/theme.dart';

class ReseauxSociauxContainer extends StatelessWidget {
  final String? path;
  const ReseauxSociauxContainer({Key? key, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Get.isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: ThemePerso.colorsSpecial,
            offset: const Offset(1, 2),
            spreadRadius: 2,
            blurRadius: 2,
          )
        ],
      ),
      width: 50,
      height: 50,
      child: Image.asset(
        path!,
        scale: 20,
      ),
    );
  }
}
