// ignore_for_file: file_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xiz/screens/homepage.dart';

class PermisionLocationDeniedPage extends StatefulWidget {
  const PermisionLocationDeniedPage({Key? key}) : super(key: key);

  @override
  State<PermisionLocationDeniedPage> createState() =>
      _PermisionLocationDeniedPageState();
}

class _PermisionLocationDeniedPageState
    extends State<PermisionLocationDeniedPage> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await Permission.location.status == PermissionStatus.granted) {
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
              Lottie.asset(
                "assets/lotties/permissiondisable.json",
                height: 200,
                repeat: false,
              ),
              Text(
                "titlepermissiondeniedPage".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  openAppSettings();
                },
                child: Text("btnpermissiondeniedPage".tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
