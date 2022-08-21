import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:xiz/services/firestore.dart';

class GetDocumentController extends GetxController {
  var documentExist = true.obs;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getIfDocumentExist();
    });
    super.onInit();
  }

  Future<bool> getIfDocumentExist() async {
    debugPrint("GET IF DOCUMENT EXIST");
    if (!await FirestoreServie()
        .getIfDocumentUserExist(FirebaseAuth.instance.currentUser!.uid)) {
      documentExist.value = false;
      return false;
    }
    debugPrint("END GET IF DOCUMENT EXIST");
    return true;
  }
}
