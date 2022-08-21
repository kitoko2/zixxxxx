// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:xiz/screens/auth/registerpage.dart';
import 'package:xiz/screens/auth/verifyemailpage.dart';
import 'package:xiz/screens/homepage.dart';
import 'package:xiz/services/authentification.dart';
import 'package:xiz/utils/colors.dart';
import 'package:xiz/widgets/customFormField.dart';
import 'package:xiz/widgets/reseausociauxContainer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final key = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return load
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          )
        : Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Text("Connexion"),
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
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: Form(
                  key: key,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 20),
                      CustomTextFormField(
                        hinText: "dogbo804@gmail.com",
                        controller: emailController,
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "le champ de l'email peut pas être vide";
                          }
                          if (!GetUtils.isEmail(e.trim())) {
                            return "Entrez un email valide";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hinText: "mot de passe",
                        controller: passwordController,
                        ispassword: true,
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "le champ du mot de passe peut pas être vide";
                          }
                          if (e.length < 6) {
                            return "mot de passe trop court";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "mot de passe oublié?",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          print(key.currentState!.validate());
                          if (key.currentState!.validate()) {
                            setState(() {
                              load = true;
                            });
                            final res = await Authentification()
                                .loginWithEmailAndPassword(
                                    emailController.text.trim(),
                                    passwordController.text);
                            if (res != null) {
                              Get.offAll(
                                res.emailVerified
                                    ? HomePage(user: res)
                                    : VerifyEmailPage(),
                                transition: Transition.cupertino,
                              );
                            } else {
                              setState(() {
                                load = false;
                              });
                            }
                          }
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
                              "Se connecter",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "ou se connecter avec",
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReseauxSociauxContainer(
                            path: "assets/appassets/google.png",
                          ),
                          SizedBox(width: 20),
                          ReseauxSociauxContainer(
                            path: "assets/appassets/facebook.png",
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Vous n'avez pas de compte ?",
                            children: [
                              TextSpan(
                                text: "  S'Inscrire",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.off(
                                      RegisterPage(),
                                      transition: Transition.downToUp,
                                    );
                                  },
                                style: TextStyle(
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
