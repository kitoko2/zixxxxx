// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';

class DialogGestion {
  dialogpicture(BuildContext context, void Function()? firstfunction,
      void Function()? secondfunction) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Veuillez choisir svp",
                  ),
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: firstfunction,
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Icon(Icons.camera),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: secondfunction,
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Icon(Icons.image),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  dialogProfilNoComplete(BuildContext context, void Function()? retour) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Profil non complet",
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Vous devez remplir tous les champs pour continuer . (un profil bien remplis augmente votre chance de vendre un article de plus de 40%)",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xfff5696a),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          "Retour",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
