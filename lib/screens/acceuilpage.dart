// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:xiz/utils/theme.dart';
import 'package:xiz/widgets/containerperson.dart';

class AcceuilPage extends StatefulWidget {
  final User? user;
  const AcceuilPage({Key? key, this.user}) : super(key: key);

  @override
  State<AcceuilPage> createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
            ),
          ),
        ),
        backgroundColor: Colors.transparent.withOpacity(0.1),
        elevation: 0,
        centerTitle: false,
        title: const Text("Xizzzz"),
        actions: [
          InkWell(
            onTap: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/icones/pngicons/filter.png",
                color: Theme.of(context).textTheme.bodyText1!.color,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
        systemOverlayStyle: Get.isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.only(right: 10, left: 10, top: 100, bottom: 80),
          itemCount: 20,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            mainAxisExtent: 250,
          ),
          itemBuilder: (context, i) {
            return CupertinoContextMenu(
              actions: const [
                CupertinoContextMenuAction(
                  trailingIcon: Icons.send,
                  child: Text(
                    "Inviter",
                  ),
                ),
                CupertinoContextMenuAction(
                  isDestructiveAction: true,
                  trailingIcon: Icons.block,
                  child: Text("Ne plus voir"),
                ),
              ],
              child: Material(
                color: Colors.transparent,
                child: ContainerPerson(
                  isOnline: i.isOdd,
                  distance: "200 m",
                  nom: !i.isEven ? "Mariam la belle, 18" : "Ange le grand, 20",
                  urlProfil: i.isEven
                      ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Pierre-Person.jpg/1200px-Pierre-Person.jpg"
                      : "https://media.glamourmagazine.co.uk/photos/623b3612980be8aafb01a665/3:4/w_1440,h_1920,c_limit/The%20Worst%20Person%20In%20The%20World%20230322GettyImages-1385537039_SQ.jpg",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
