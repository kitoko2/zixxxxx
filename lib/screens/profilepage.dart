// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:xiz/model/userxiz.dart';
import 'package:xiz/screens/appercuprofilpage.dart';
import 'package:xiz/screens/auth/registerpage.dart';
import 'package:xiz/screens/completeprofile/completeprofile.dart';
import 'package:xiz/utils/colors.dart';

class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  bool load = true;
  Userzix? _userzix;
  getCurrentUserzix() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(widget.user!.uid)
        .get();
    _userzix = Userzix(
      uid: doc.data()!["uid"],
      email: doc.data()!["email"],
      age: doc.data()!["age"],
      description: doc.data()!["description"],
      items: doc.data()!["item"],
      latlong: doc.data()!["latlng"],
      pseudo: doc.data()!["pseudo"],
      typeRechercher: doc.data()!["type rechercher"],
      photoUrl: doc.data()!["photoUrl"],
    );
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    getCurrentUserzix();
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? Container()
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 10,
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: TabBar(
                    indicatorColor: primaryColor,
                    indicatorWeight: 4,
                    tabs: [
                      Tab(
                        child: Text(
                          "appercu",
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "modifier",
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                    controller: controller,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    controller: controller,
                    children: [
                      AppercuProfilPage(),
                      CompleteProfile(
                        userzix: _userzix,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
