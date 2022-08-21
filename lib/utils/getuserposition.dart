import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:xiz/screens/permissiondeniedPage.dart';

import '../screens/locationdisablepage.dart';

class GetUserPosition {
  Position? userposition;
  Future<Position?> _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // return Future.error('Location services are disabled.');

        Get.offAll(
          const LocationDisablePage(),
        );
        return null;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // return Future.error('Location permissions are denied');
          Get.offAll(
            const PermisionLocationDeniedPage(),
          );
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // return Future.error(
        //     'Location permissions are permanently denied, we cannot request permissions.');
        Get.offAll(
          const PermisionLocationDeniedPage(),
        );
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  Future<Position?> getUserPosition() async {
    userposition = await _determinePosition();
    print("***********");
    print(userposition);
    print("***********");
    return userposition;
  }
}
