// ignore_for_file: invalid_use_of_visible_for_testing_member, file_names

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import "package:image_picker/image_picker.dart";

class ChooseImage {
  Future getImage(ImageSource imageSource) async {
    XFile? xfile = await ImagePicker.platform.getImage(source: imageSource);
    if (xfile != null) {
      var file = File(xfile.path);

      if (getSizeOfFile(file) > 1) {
        File compressedFile =
            await FlutterNativeImage.compressImage(file.path, quality: 50);
        return compressedFile;
      }

      return file;
    } else {
      return null;
    }
  }

  double getSizeOfFile(File file) {
    debugPrint("*************get size of file***************");
    final bytes = file.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    debugPrint("Nombre de megabyte : $mb");

    return mb;
  }
}
