import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xiz/utils/theme.dart';

class ChatPage extends StatefulWidget {
  final User? user;
  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
            ),
          ),
        ),
        backgroundColor: Colors.transparent.withOpacity(0.1),
        elevation: 0,
        centerTitle: false,
        title: const Text("Conversations"),
        systemOverlayStyle: Get.isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          controller: controller,
          children: [
            SizedBox(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mes Contacts",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 15,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: const EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(
                              color: ThemePerso.colorsSpecial,
                              shape: BoxShape.circle,
                            ),
                            width: 60,
                            height: 60,
                          );
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mes messages",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: 35,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                          color: ThemePerso.colorsSpecial,
                          shape: BoxShape.circle,
                        ),
                        width: 60,
                        height: 60,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
