import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

typedef void ResponseHandler(dynamic result, bool isSuccess);

class GetImageFile {
  static Future<void> pickImage(ImageSource imageSource, BuildContext context,
      ResponseHandler responseHandler) async {
    try {
      var picture = await ImagePicker().pickImage(source: imageSource);
      if (picture != null) {
        responseHandler(picture, true);
      } else {
        responseHandler(null, false);
      }
    } on PlatformException catch (e) {
      responseHandler(null, false);
    }
  }

  static Future<void> picMultiImages(
      BuildContext context, ResponseHandler responseHandler) async {
    try {
      var pickedFileList = await ImagePicker().pickMultiImage();
      if (pickedFileList != null) {
        responseHandler(pickedFileList, true);
      } else {
        responseHandler(null, false);
      }
    } on PlatformException catch (e) {
      responseHandler(null, false);
      print(e.toString());
    }
  }

  static Future<void> selectVideo(BuildContext context, ImageSource imageSource,
      ResponseHandler responseHandler) async {
    try {
      var videoFile = await ImagePicker()
          .pickVideo(source: imageSource, maxDuration: Duration(seconds: 30));
      if (videoFile != null) {
        responseHandler(videoFile, true);
      } else {
        responseHandler(null, false);
      }
    } on PlatformException catch (e) {
      responseHandler(e.toString(), false);
      print(e.toString());
    }
  }
}
