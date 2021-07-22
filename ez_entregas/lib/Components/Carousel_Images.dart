import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';

Widget carouselImages(List<String> listImages, List<Map<String, dynamic>> infoBanner, {double height = 300, double borderRadius = 10}){

  return CarouselImages(
    scaleFactor: 0.7,
    listImages: listImages,
    height: height,
    borderRadius: borderRadius,
    cachedNetworkImage: true,
    verticalAlignment: Alignment.center,
    onTap: (index) {
      print('Tapped on page $index');
      print(infoBanner[index]);
    },
  );
}