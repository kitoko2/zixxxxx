// ignore_for_file: file_names

import 'dart:io';
import "package:firebase_storage/firebase_storage.dart";

class PutImage {
  static Future<List<String>> uploadFiles(List<File> images) async {
    var imageUrls = await Future.wait(images.map((image) => uploadFile(image)));
    return imageUrls;
  }

  static Future<String> uploadFile(File image) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child(image.path);
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.then((value) async {
      // String? url = await value.ref.getDownloadURL();
    });

    return await storageReference.getDownloadURL();
  }
}
