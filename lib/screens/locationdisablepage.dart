import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:xiz/screens/homepage.dart';

class LocationDisablePage extends StatefulWidget {
  const LocationDisablePage({Key? key}) : super(key: key);

  @override
  State<LocationDisablePage> createState() => _LocationDisablePageState();
}

class _LocationDisablePageState extends State<LocationDisablePage> {
  Timer? timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await Geolocator.isLocationServiceEnabled()) {
        Get.offAll(HomePage(
          user: FirebaseAuth.instance.currentUser,
        ));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Lottie.asset("assets/lotties/locationdisable.json", height: 200),
              Text(
                "titlelocationdisable".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on),
                      Text("btnlocationDisable".tr),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
