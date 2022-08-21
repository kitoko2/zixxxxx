// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:xiz/controllers/getdocumentcontroller.dart';
import 'package:xiz/screens/acceuilpage.dart';
import 'package:xiz/screens/chatpage.dart';
import 'package:xiz/screens/completeprofile/completeAfterRegister.dart';
import 'package:xiz/screens/completeprofile/completeprofile.dart';
import 'package:xiz/screens/profilepage.dart';
import 'package:xiz/services/firestore.dart';
import 'package:xiz/utils/colors.dart';
import 'package:xiz/utils/getuserposition.dart';

class HomePage extends StatefulWidget {
  final User? user;
  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  var svgSelectcolor = const Color(0xfff01a41);
  final PageController pageController = PageController();
  final GetDocumentController _getDocumentController =
      Get.put(GetDocumentController());
  List<Widget> mybody = [];
  Position? userposition;
  Timer? timer;
  getPos() async {
    userposition = await GetUserPosition().getUserPosition();
    print(userposition);
  }

  @override
  void initState() {
    // _getDocumentController.getIfDocumentExist();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPos();
      if (await _getDocumentController.getIfDocumentExist() == true) {
        FirestoreServie().updatePosition(
          widget.user!.uid,
          "${userposition!.latitude},${userposition!.longitude}",
        );
      }
    });

    mybody = [
      AcceuilPage(user: widget.user),
      Container(),
      ChatPage(user: widget.user),
      ProfilePage(user: widget.user)
      // Container(),
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _getDocumentController.documentExist.value
          ? Scaffold(
              extendBody: true,
              bottomNavigationBar: buildBottomNavigationBar(),
              body: mybody[_selectedIndex],
            )
          : CompleteAfterRegister(
              uid: widget.user!.uid,
            );
    });
  }

  Widget buildBottomNavigationBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: BottomNavigationBar(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          unselectedItemColor: Color.fromARGB(255, 98, 98, 98),
          selectedItemColor: Colors.blue,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
            print(value);
          },
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icones/home.svg',
                  color: _selectedIndex == 0
                      ? svgSelectcolor
                      : Get.isDarkMode
                          ? Colors.white
                          : Colors.black,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icones/search.svg',
                  color: _selectedIndex == 1
                      ? svgSelectcolor
                      : Get.isDarkMode
                          ? Colors.white
                          : Colors.black,
                ),
                label: ""),
            // BottomNavigationBarItem(
            //     icon: SvgPicture.asset(
            //       'assets/icones/plus.svg',
            //       height: 40,
            //       color: _selectedIndex == 2
            //           ? svgSelectcolor
            //           : Get.isDarkMode
            //               ? Colors.white
            //               : Colors.black,
            //     ),
            //     label: ""),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icones/message.svg',
                color: _selectedIndex == 2
                    ? svgSelectcolor
                    : Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icones/user.svg',
                color: _selectedIndex == 3
                    ? svgSelectcolor
                    : Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }

  showMyDialog() {
    showCupertinoModalBottomSheet(
      // backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Text(
                  "Votre profil est incomplet, Pour avoir plus d'interaction veuillez svp le completer",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                Text(
                  "un profil plus complet est successible de vous assurer plus de discussion.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  // onTap: () {
                  //   Get.to(CompleteProfile());
                  // },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor.withAlpha(22),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Completer le profil",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
