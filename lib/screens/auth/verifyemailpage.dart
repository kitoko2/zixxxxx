// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:xiz/screens/homepage.dart';
import 'package:xiz/utils/colors.dart';

class VerifyEmailPage extends StatefulWidget {
  final User? user;
  const VerifyEmailPage({Key? key, this.user}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool? emailIsVerified = false;
  bool canResend = false;
  Timer? timer;
  Future sendEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
      setState(() {
        canResend = false;
      });
      await Future.delayed(Duration(seconds: 7));
      setState(() {
        canResend = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future checkIfEmailISVerify() async {
    //appeler apres verification email
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.currentUser!.reload();
      setState(() {
        emailIsVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
      if (emailIsVerified!) {
        timer!.cancel();
      }
    }
  }

  @override
  void initState() {
    emailIsVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!emailIsVerified!) {
      sendEmail();
    }
    timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await checkIfEmailISVerify();
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
    return emailIsVerified!
        ? HomePage(
            user: widget.user,
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Verification email"),
              centerTitle: true,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.6),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent.withOpacity(0.1),
              elevation: 0,
            ),
            body: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "Veuillez verifier votre boîte mail et confirmer avant de continuer",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Une fois valider vous serez automatiquement dirigé sur la page d'acceuil",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (canResend)
                      GestureDetector(
                        onTap: () async {
                          sendEmail();
                        },
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
                              "Renvoyer le mail",
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
            ),
          );
  }
}
