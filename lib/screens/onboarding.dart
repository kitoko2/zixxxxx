// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:xiz/screens/auth/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  double initialValue = 0;
  double max = 3;
  bool isdarkmode = Get.isDarkMode;
  PageController controller = PageController();
  changeTheme(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    if (v) {
      prefs.setString('theme', "dark");
    } else {
      prefs.setString('theme', "light");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: 120,
        child: Center(
          child: SleekCircularSlider(
            min: 0,
            max: max,
            // appearance: CircularSliderAppearance(
            //   customColors: CustomSliderColors(
            //     progressBarColors: [
            //       Colors.pink,
            //       Colors.purple,
            //       Colors.purpleAccent
            //     ],
            //   ),
            // ),
            initialValue: initialValue,
            innerWidget: (double value) {
              return Center(
                child: FloatingActionButton(
                  onPressed: () async {
                    if (initialValue < max) {
                      setState(() {
                        initialValue += 1;
                        controller.animateToPage(
                          initialValue.toInt(),
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        );
                      });
                    } else {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isFirst', false);
                      changeTheme(Get.isDarkMode);
                      Get.offAll(RegisterPage());
                    }
                  },
                  child: Center(
                    child: Icon(Icons.arrow_forward_rounded),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: PageView(
        controller: controller,
        physics: BouncingScrollPhysics(),
        onPageChanged: (i) {
          setState(() {
            initialValue = i.toDouble();
          });
        },
        children: [
          containerPage(
            "assets/lotties/1.json",
            "Xizzzzz avec vous toujours et partout",
            "Vous avez la possibilité de vendre, d'acheter partout en tous moment avec notre solution",
          ),
          containerPage(
            "assets/lotties/1.json",
            "Xizzzzz avec vous toujours et partout",
            "Vous avez la possibilité de vendre, d'acheter partout en tous moment avec notre solution",
          ),
          containerPage(
            "assets/lotties/1.json",
            "Xizzzzz avec vous toujours et partout",
            "Vous avez la possibilité de vendre, d'acheter partout en tous moment avec notre solution",
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Container(
                  //   height: MediaQuery.of(context).size.height / 2,
                  //   child: Lottie.asset(
                  //     "assets/lotties/70124-dark-mode-and-light-mode-button.json",
                  //     repeat: true,
                  //   ),
                  // ),
                  Text(
                    "Veuillez choisir le theme qui vous convient avant de continuer",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.dark_mode),
                              SizedBox(width: 10),
                              Text(
                                "mode sombre".tr,
                              ),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          activeColor: const Color(0xfff01a41),
                          value: isdarkmode,
                          onChanged: (v) {
                            setState(() {
                              isdarkmode = v;
                            });
                            Get.changeThemeMode(
                              Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget containerPage(String assetLottie, String titre, String description) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.height / 2,
            //   child: Lottie.asset(
            //     assetLottie,
            //     repeat: true,
            //   ),
            // ),
            Text(
              titre,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
