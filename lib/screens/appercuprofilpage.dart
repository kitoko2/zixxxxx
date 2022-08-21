import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xiz/screens/auth/registerpage.dart';
import 'package:xiz/services/authentification.dart';
import 'package:xiz/utils/colors.dart';

class AppercuProfilPage extends StatefulWidget {
  const AppercuProfilPage({Key? key}) : super(key: key);

  @override
  State<AppercuProfilPage> createState() => _AppercuProfilPageState();
}

class _AppercuProfilPageState extends State<AppercuProfilPage> {
  final carouselController = CarouselController();
  int pageSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.7,
                child: Center(
                  child: CarouselSlider(
                    carouselController: carouselController,
                    items: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://media.glamourmagazine.co.uk/photos/623b3612980be8aafb01a665/3:4/w_1440,h_1920,c_limit/The%20Worst%20Person%20In%20The%20World%20230322GettyImages-1385537039_SQ.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      onPageChanged: (i, c) {
                        setState(() {
                          pageSelected = i;
                        });
                      },
                      height: MediaQuery.of(context).size.height / 1.7,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 3,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: pageSelected == index
                              ? primaryColor
                              : Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: pageSelected == index ? 20 : 10,
                        height: 10,
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Marima, 20",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                rowTips(Icons.work, "emplois"),
                const SizedBox(height: 5),
                rowTips(Icons.location_on_rounded, "Abidjan"),
                const SizedBox(height: 5),
                rowTips(Icons.navigation, "10 km"),
                const SizedBox(height: 10),
                const Divider(),
                Text(
                  "A propos",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                const Text("La desription de l'utilisateur"),
                const SizedBox(height: 10),
                const Divider(),
                Text(
                  "Ce que je cherche",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                const Text("Ce que l'utilisateur cherche"),
                const SizedBox(height: 10),
                const Divider(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Authentification().signOut();
                      Get.offAll(RegisterPage());
                    },
                    child: const Text("Deconnexion"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  rowTips(IconData iconData, String description) {
    return Row(
      children: [
        Icon(
          iconData,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(
          description,
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
