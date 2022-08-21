// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xiz/controllers/getdocumentcontroller.dart';
import 'package:xiz/model/userxiz.dart';
import 'package:xiz/screens/auth/registerpage.dart';
import 'package:xiz/screens/homepage.dart';
import 'package:xiz/services/authentification.dart';
import 'package:xiz/services/firestore.dart';
import 'package:xiz/utils/chooseImage.dart';
import 'package:xiz/utils/dialogGestion.dart';
import 'package:xiz/utils/putImage.dart';
import 'package:xiz/utils/theme.dart';
import 'package:xiz/widgets/customFormField.dart';

class CompleteAfterRegister extends StatefulWidget {
  final String? uid;
  const CompleteAfterRegister({Key? key, required this.uid}) : super(key: key);

  @override
  State<CompleteAfterRegister> createState() => _CompleteAfterRegisterState();
}

class _CompleteAfterRegisterState extends State<CompleteAfterRegister> {
  double initialValue = 0;
  double max = 3;
  PageController? controller;
  TextEditingController pseudoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController sexeRechercherController = TextEditingController();
  bool load = false;
  bool controllerIsload = false;
  DateTime? dateNaissance;
  Timer? timer;
  File? file1;
  File? file2;
  File? file3;
  File? file4;
  final GetDocumentController _getDocumentController =
      Get.put(GetDocumentController());

  @override
  void initState() {
    super.initState();
    controller = PageController();
    controller!.addListener(() {
      setState(() {});
    });
    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          controllerIsload = true;
        });
      }
      timer.cancel();
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return load
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: controllerIsload
                ? AppBar(
                    leading: InkWell(
                      onTap: () async {
                        if (controller!.page!.toInt() == 0) {
                          await Authentification().signOut();
                          Get.offAll(RegisterPage());
                        } else {
                          controller!.previousPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: ThemePerso.colorsSpecial,
                        ),
                        child: Center(
                          child: controller!.page!.toInt() == 0
                              ? Image.asset(
                                  "assets/appassets/logout.png",
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  width: 20,
                                  height: 20,
                                )
                              : Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                ),
                        ),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    title: Text("Completez votre profil"),
                    systemOverlayStyle: Get.isDarkMode
                        ? SystemUiOverlayStyle.light
                        : SystemUiOverlayStyle.dark,
                  )
                : AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text("Completez votre profil"),
                    centerTitle: true,
                    systemOverlayStyle: Get.isDarkMode
                        ? SystemUiOverlayStyle.light
                        : SystemUiOverlayStyle.dark,
                  ),
            bottomSheet: isKeyboard
                ? null
                : Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmoothPageIndicator(
                          controller: controller!, // PageController
                          count: 3,
                          effect: ExpandingDotsEffect(
                            expansionFactor: 2.2,
                            dotColor: Colors.grey.shade300,
                            activeDotColor:
                                Theme.of(context).colorScheme.primary,
                            dotWidth: 5,
                            dotHeight: 10,
                            spacing: 3,
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            if (controller!.page!.toInt() == 2) {
                              //next page
                              //publication;
                              if (file1 == null &&
                                  file2 == null &&
                                  file3 == null &&
                                  file4 == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Veuillez choisir au moins une image"),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                setState(() {
                                  load = true;
                                });

                                List<File> mesimages = [];
                                if (file1 != null) {
                                  mesimages.add(file1!);
                                }
                                if (file2 != null) {
                                  mesimages.add(file2!);
                                }
                                if (file3 != null) {
                                  mesimages.add(file3!);
                                }
                                if (file4 != null) {
                                  mesimages.add(file4!);
                                }

                                var urls =
                                    await PutImage.uploadFiles(mesimages);

                                Userzix userzix = Userzix(
                                    uid: FirebaseAuth.instance.currentUser!.uid,
                                    email: FirebaseAuth
                                        .instance.currentUser!.email,
                                    age: ageController.text.trim(),
                                    description:
                                        descriptionController.text.trim(),
                                    items: [],
                                    latlong: null,
                                    pseudo: pseudoController.text.trim(),
                                    typeRechercher:
                                        sexeRechercherController.text.trim(),
                                    photoUrl: urls);

                                FirestoreServie()
                                    .addPositionData(widget.uid!, userzix);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Posts effectué avec succes"),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                setState(() {
                                  load = false;
                                });

                                _getDocumentController.documentExist.value =
                                    true;
                              }
                            } else {
                              if (controller!.page!.toInt() == 0) {
                                if (pseudoController.text.trim().isNotEmpty) {
                                  controller!.nextPage(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeIn,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Entrer votre pseudo pour continuer"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              } else if (controller!.page!.toInt() == 1) {
                                if (ageController.text.trim().isNotEmpty &&
                                    sexeRechercherController.text
                                        .trim()
                                        .isNotEmpty &&
                                    descriptionController.text
                                        .trim()
                                        .isNotEmpty) {
                                  controller!.nextPage(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeIn,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Ces champs sont requis"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: const Icon(Icons.arrow_forward_rounded),
                        )
                      ],
                    ),
                  ),
            body: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) {
                setState(() {
                  initialValue = i.toDouble();
                });
              },
              children: [
                containerPage(
                  "assetLottie",
                  "Veuillez entrer votre pseudo",
                  "ce pseudo sera visible par tous les autres utilisateur",
                  widget: CustomTextFormField(
                    hinText: "Votre Pseudo",
                    controller: pseudoController,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Veuillez entrer un pseudo";
                      }
                      return null;
                    },
                  ),
                ),
                containerPage(
                  "assets/lotties/1.json",
                  "Votre age et votre description",
                  "donner plus d'information sur vous",
                  widget: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  color: Colors.white,
                                  height: 210,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "Selectionnez votre date de naissance"),
                                      ),
                                      Expanded(
                                        child: CupertinoDatePicker(
                                          maximumYear: DateTime.now().year -
                                              18, //pour filtrer les majeurs
                                          minimumYear:
                                              DateTime.now().year - 200,
                                          initialDateTime: DateTime(2000),
                                          onDateTimeChanged: (d) {
                                            setState(() {
                                              dateNaissance = d;
                                              ageController.text =
                                                  "${DateTime.now().year - dateNaissance!.year} ans";
                                            });
                                            FocusScope.of(context).unfocus();
                                          },
                                          mode: CupertinoDatePickerMode.date,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: IgnorePointer(
                          child: CustomTextFormField(
                            controller: ageController,
                            hinText: "Votre Age",
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Veuillez choisir votre age";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  color: Colors.white,
                                  height: 160,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "Selectionnez ce que vous cherchez"),
                                      ),
                                      Expanded(
                                        child: CupertinoPicker(
                                          itemExtent: 40,
                                          onSelectedItemChanged: (i) {
                                            print(i);
                                            setState(() {
                                              if (i == 0) {
                                                sexeRechercherController.text =
                                                    "Homme";
                                              } else if (i == 1) {
                                                sexeRechercherController.text =
                                                    "Femme";
                                              } else {
                                                sexeRechercherController.text =
                                                    "Les deux";
                                              }
                                            });
                                          },
                                          children: [
                                            Center(child: Text("Homme")),
                                            Center(child: Text("Femme")),
                                            Center(child: Text("Les deux")),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: IgnorePointer(
                          child: CustomTextFormField(
                            controller: sexeRechercherController,
                            hinText: "Ce que vous rechercher",
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Veuillez choisir ce que vous rechercher";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        hinText: "Decrivez-vous...",
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "Veuillez vous décrire";
                          }
                          return null;
                        },
                        isManyLine: true,
                        controller: descriptionController,
                      ),
                    ],
                  ),
                ),
                containerPage(
                  "assets/lotties/1.json",
                  "Chossissez vos photos",
                  "Ces photos seront visibles sur votre profil par tous les utilisateurs (choisissez au moins une photo)",
                  widget: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      photoWidget1(),
                      photoWidget2(),
                      photoWidget3(),
                      photoWidget4(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget containerPage(String assetLottie, String titre, String description,
      {required Widget? widget}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            const SizedBox(height: 15),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 15),

            widget!,
          ],
        ),
      ),
    );
  }

  photoWidget1() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            DialogGestion().dialogpicture(
              context,
              () async {
                File? res = await ChooseImage().getImage(ImageSource.camera);
                if (res != null) {
                  file1 = res;
                  Navigator.pop(context);
                }
                setState(() {});
              },
              () async {
                File? res = await ChooseImage().getImage(ImageSource.gallery);
                if (res != null) {
                  file1 = res;
                  Navigator.pop(context);
                }
                setState(() {});
              },
            );
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 150,
            width: MediaQuery.of(context).size.width / 2 - 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.withOpacity(0.3),
                image: file1 != null
                    ? DecorationImage(
                        image: FileImage(file1!),
                        fit: BoxFit.cover,
                      )
                    : null),
            child: file1 == null
                ? Center(
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                : SizedBox(),
          ),
        ),
        if (file1 != null)
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  file1 = null;
                });
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.clear,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }

  photoWidget2() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            DialogGestion().dialogpicture(
              context,
              () async {
                File? res = await ChooseImage().getImage(ImageSource.camera);
                if (res != null) {
                  file2 = res;
                  Navigator.pop(context);
                }
                setState(() {});
              },
              () async {
                File? res = await ChooseImage().getImage(ImageSource.gallery);
                if (res != null) {
                  file2 = res;
                  Navigator.pop(context);
                }
                setState(() {});
              },
            );
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 150,
            width: MediaQuery.of(context).size.width / 2 - 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.withOpacity(0.3),
                image: file2 != null
                    ? DecorationImage(
                        image: FileImage(file2!),
                        fit: BoxFit.cover,
                      )
                    : null),
            child: file2 == null
                ? Center(
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                : SizedBox(),
          ),
        ),
        if (file2 != null)
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  file2 = null;
                });
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.clear,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }

  photoWidget3() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            DialogGestion().dialogpicture(
              context,
              () async {
                File? res = await ChooseImage().getImage(ImageSource.camera);
                if (res != null) {
                  file3 = res;
                  Navigator.pop(context);
                }
                setState(() {});
              },
              () async {
                File? res = await ChooseImage().getImage(ImageSource.gallery);
                if (res != null) {
                  file3 = res;
                  Navigator.pop(context);
                }
                setState(() {});
              },
            );
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 150,
            width: MediaQuery.of(context).size.width / 2 - 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.withOpacity(0.3),
                image: file3 != null
                    ? DecorationImage(
                        image: FileImage(file3!),
                        fit: BoxFit.cover,
                      )
                    : null),
            child: file3 == null
                ? Center(
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                : SizedBox(),
          ),
        ),
        if (file3 != null)
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  file3 = null;
                });
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.clear,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }

  photoWidget4() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            DialogGestion().dialogpicture(
              context,
              () async {
                File? res = await ChooseImage().getImage(ImageSource.camera);
                if (res != null) {
                  file4 = res;
                  Navigator.pop(context);
                }
                setState(() {});
              },
              () async {
                File? res = await ChooseImage().getImage(ImageSource.gallery);
                if (res != null) {
                  file4 = res;
                  Navigator.pop(context);
                }
                setState(() {});
              },
            );
          },
          child: Container(
            margin: EdgeInsets.all(5),
            height: 150,
            width: MediaQuery.of(context).size.width / 2 - 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.withOpacity(0.3),
                image: file4 != null
                    ? DecorationImage(
                        image: FileImage(file4!),
                        fit: BoxFit.cover,
                      )
                    : null),
            child: file4 == null
                ? Center(
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                : SizedBox(),
          ),
        ),
        if (file4 != null)
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  file4 = null;
                });
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.clear,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }
}
