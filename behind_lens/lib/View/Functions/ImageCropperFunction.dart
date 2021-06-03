import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File> imageCropperFunction(dynamic image, {int width = 800, int height = 800, int quality = 80}) async{
  return await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: quality,
      // 100 means no compression
      maxWidth: width,
      maxHeight: height,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Color(0xff444444),
        toolbarTitle: "Redimensionar imagem",
        statusBarColor: Color(0xffffffff),
        backgroundColor: Color(0xff222222),
        toolbarWidgetColor: Colors.white,
        //toolbarWidgetColor: primaryColor,
        activeControlsWidgetColor: Color(0xfffe386b),
        dimmedLayerColor: Color(0xff222222),
        cropFrameColor: Color(0xfffe386b),
        cropGridColor: Color(0xfffe386b),

      ),
      iosUiSettings: IOSUiSettings(
          title: "Redimensionar imagem",
          cancelButtonTitle: "Cancelar",
          doneButtonTitle: "Concluir"
      )
  );
}