import 'dart:ui';

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:xiz/utils/theme.dart';

class ContainerPerson extends StatelessWidget {
  final String? nom;
  final String? distance;
  final String? urlProfil;
  final bool? isOnline;
  const ContainerPerson(
      {Key? key,
      required this.distance,
      required this.nom,
      required this.urlProfil,
      required this.isOnline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ThemePerso.colorsSpecial,
                image: DecorationImage(
                  image: NetworkImage(urlProfil!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        color: ThemePerso.colorsSpecial.withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  nom!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/icones/pngicons/flame.png",
                                      height: 15,
                                      width: 15,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      distance!,
                                      style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.grey
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline! ? Colors.green : Colors.red,
            ),
          ),
        )
      ],
    );
  }
}
