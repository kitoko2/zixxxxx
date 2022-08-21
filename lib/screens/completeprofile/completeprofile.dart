// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:xiz/model/userxiz.dart';
import 'package:xiz/screens/homepage.dart';
import 'package:xiz/services/firestore.dart';
import 'package:xiz/utils/chooseImage.dart';
import 'package:xiz/utils/colors.dart';
import 'package:xiz/utils/dialogGestion.dart';
import 'package:xiz/utils/putImage.dart';
import 'package:xiz/utils/theme.dart';
import 'package:xiz/widgets/customFormField.dart';

class CompleteProfile extends StatefulWidget {
  final Userzix? userzix;
  const CompleteProfile({Key? key, required this.userzix}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  TextEditingController? pseudoController;
  TextEditingController? descriptionController;
  TextEditingController? ageController;
  TextEditingController? sexeRechercherController;
  ScrollController? controller;
  List<String> items = [
    "football",
    "Netflix",
    "Geek",
    "handball",
    "mangas",
    "films",
    "series",
    "danse",
  ];
  final key = GlobalKey<FormState>();
  File? file1;
  File? file2;
  File? file3;
  File? file4;
  bool load = false;
  List<String> itemsSelected = [];
  double top = 0;
  DateTime? dateNaissance;
  @override
  void initState() {
    controller = ScrollController();
    pseudoController = TextEditingController(text: widget.userzix!.pseudo);
    descriptionController =
        TextEditingController(text: widget.userzix!.description);
    ageController = TextEditingController(text: widget.userzix!.age);
    sexeRechercherController =
        TextEditingController(text: widget.userzix!.typeRechercher);
    controller!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? Center(child: CircularProgressIndicator())
        : Scaffold(body: pageOne(key));
  }

  Widget pageOne(GlobalKey<FormState> key) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Form(
        key: key,
        child: ListView(
          padding: EdgeInsets.only(bottom: 80),
          primary: false,
          shrinkWrap: true,
          children: [
            SizedBox(height: 20),
            CustomTextFormField(
              hinText: "Votre Pseudo",
              controller: pseudoController,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Veuillez entrer un pseudo";
                }
                return null;
              },
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
                        height: 210,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text("Selectionnez votre date de naissance"),
                            ),
                            Expanded(
                              child: CupertinoDatePicker(
                                maximumYear: DateTime.now().year -
                                    18, //pour filtrer les majeurs
                                minimumYear: DateTime.now().year - 200,
                                initialDateTime: DateTime(2000),
                                onDateTimeChanged: (d) {
                                  setState(() {
                                    dateNaissance = d;
                                    ageController!.text =
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
                              child: Text("Selectionnez ce que vous cherchez"),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 40,
                                onSelectedItemChanged: (i) {
                                  setState(() {
                                    if (i == 0) {
                                      sexeRechercherController!.text = "Homme";
                                    } else if (i == 1) {
                                      sexeRechercherController!.text = "Femme";
                                    } else {
                                      sexeRechercherController!.text =
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
            SizedBox(height: 15),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                photoWidget1(),
                photoWidget2(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                photoWidget3(),
                photoWidget4(),
              ],
            ),
            SizedBox(height: 15),
            Divider(),
            Text(
              "Choississez ce qui vous definis le plus",
              textAlign: TextAlign.center,
            ),
            Wrap(
              children: List.generate(items.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(items[index]),
                    selected: itemsSelected.contains(items[index]),
                    selectedColor: primaryColor,
                    onSelected: (b) {
                      if (itemsSelected.contains(items[index])) {
                        setState(() {
                          itemsSelected.remove(items[index]);
                        });
                      } else {
                        setState(() {
                          itemsSelected.add(items[index]);
                        });
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  debugPrint(
                      '+++++++++${widget.userzix!.photoUrl!.length}+++++++');

                  if (widget.userzix!.photoUrl!.isNotEmpty) {
                    setState(() {
                      load = true;
                    });
                    List<dynamic> photosUrl = [];
                    if (allFileIsNull()) {
                      photosUrl = widget.userzix!.photoUrl!;
                      debugPrint("********************");
                      debugPrint(photosUrl.toString());
                      debugPrint("********************");
                    } else {
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
                      var urls = await PutImage.uploadFiles(mesimages);
                      photosUrl = urls.cast<dynamic>()
                        ..addAll(widget.userzix!.photoUrl!.cast<dynamic>());
                      debugPrint("********************");
                      debugPrint(photosUrl.toString());
                      debugPrint("********************");
                    }
                    final newUserZix = Userzix(
                      uid: widget.userzix!.uid!,
                      email: widget.userzix!.email!,
                      age: ageController!.text.trim(),
                      description: descriptionController!.text.trim(),
                      items: [],
                      latlong: widget.userzix!.latlong,
                      pseudo: pseudoController!.text.trim(),
                      typeRechercher: sexeRechercherController!.text.trim(),
                      photoUrl: photosUrl,
                    );
                    FirestoreServie().updateProfile(
                      widget.userzix!.uid!,
                      newUserZix,
                    );
                    if (mounted) {
                      setState(() {
                        load = false;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("profil modifié avec succes"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    Get.offAll(
                        HomePage(user: FirebaseAuth.instance.currentUser));
                  } else {
                    if (allFileIsNull()) {
                      //tous les fichiers sont null et aucune photo url
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Veuillez choisir au moins une image"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      // tous les photos recuperer en ligne ont été supprimé (les supprimer en storage)
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

                      var urls = await PutImage.uploadFiles(mesimages);

                      Userzix userzix = Userzix(
                        uid: widget.userzix!.uid!,
                        email: widget.userzix!.email!,
                        age: ageController!.text.trim(),
                        description: descriptionController!.text.trim(),
                        items: [],
                        latlong: widget.userzix!.latlong,
                        pseudo: pseudoController!.text.trim(),
                        typeRechercher: sexeRechercherController!.text.trim(),
                        photoUrl: urls,
                      );
                      FirestoreServie().updateProfile(
                        widget.userzix!.uid!,
                        userzix,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("profil modifié avec succes"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      if (mounted) {
                        setState(() {
                          load = false;
                        });
                      }

                      Get.offAll(
                        HomePage(user: FirebaseAuth.instance.currentUser),
                      );
                    }
                  }
                },
                child: const Text("Enregistrer"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool allFileIsNull() {
    if (file1 == null && file2 == null && file3 == null && file4 == null) {
      return true;
    }
    return false;
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
                  if (widget.userzix!.photoUrl!.isNotEmpty) {
                    widget.userzix!.photoUrl!.removeAt(0);
                  }
                  Navigator.pop(context);
                }
                setState(() {});
              },
              () async {
                File? res = await ChooseImage().getImage(ImageSource.gallery);
                if (res != null) {
                  file1 = res;
                  if (widget.userzix!.photoUrl!.isNotEmpty) {
                    widget.userzix!.photoUrl!.removeAt(0);
                  }

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
                  : widget.userzix!.photoUrl!.isNotEmpty
                      ? widget.userzix!.photoUrl![0] != null
                          ? DecorationImage(
                              image: NetworkImage(
                                widget.userzix!.photoUrl![0],
                              ),
                              fit: BoxFit.cover,
                            )
                          : null
                      : null,
            ),
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
                  if (widget.userzix!.photoUrl!.length >= 2) {
                    widget.userzix!.photoUrl!.removeAt(1);
                  }

                  Navigator.pop(context);
                }
                setState(() {});
              },
              () async {
                File? res = await ChooseImage().getImage(ImageSource.gallery);
                if (res != null) {
                  file2 = res;
                  if (widget.userzix!.photoUrl!.length >= 2) {
                    widget.userzix!.photoUrl!.removeAt(1);
                  }

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
                  : widget.userzix!.photoUrl!.length >= 2
                      ? widget.userzix!.photoUrl![1] != null
                          ? DecorationImage(
                              image: NetworkImage(
                                widget.userzix!.photoUrl![1],
                              ),
                              fit: BoxFit.cover,
                            )
                          : null
                      : null,
            ),
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
                  if (widget.userzix!.photoUrl!.length >= 3) {
                    widget.userzix!.photoUrl!.removeAt(2);
                  }

                  Navigator.pop(context);
                }
                setState(() {});
              },
              () async {
                File? res = await ChooseImage().getImage(ImageSource.gallery);
                if (res != null) {
                  file3 = res;
                  if (widget.userzix!.photoUrl!.length >= 3) {
                    widget.userzix!.photoUrl!.removeAt(2);
                  }

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
                  : widget.userzix!.photoUrl!.length >= 3
                      ? widget.userzix!.photoUrl![2] != null
                          ? DecorationImage(
                              image: NetworkImage(
                                widget.userzix!.photoUrl![2],
                              ),
                              fit: BoxFit.cover,
                            )
                          : null
                      : null,
            ),
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
                  if (widget.userzix!.photoUrl!.length >= 4) {
                    widget.userzix!.photoUrl!.removeAt(3);
                  }
                  Navigator.pop(context);
                }
                setState(() {});
              },
              () async {
                File? res = await ChooseImage().getImage(ImageSource.gallery);
                if (res != null) {
                  file4 = res;
                  if (widget.userzix!.photoUrl!.length >= 4) {
                    widget.userzix!.photoUrl!.removeAt(3);
                  }
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
                  : widget.userzix!.photoUrl!.length >= 4
                      ? widget.userzix!.photoUrl![3] != null
                          ? DecorationImage(
                              image: NetworkImage(
                                widget.userzix!.photoUrl![3],
                              ),
                              fit: BoxFit.cover,
                            )
                          : null
                      : null,
            ),
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

  void mydialog() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        FocusScope.of(context).unfocus();
        return Material(
          color: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Comment voulez-vous effectuer cette action?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ThemePerso.colorsSpecial,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.photo,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ThemePerso.colorsSpecial,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
