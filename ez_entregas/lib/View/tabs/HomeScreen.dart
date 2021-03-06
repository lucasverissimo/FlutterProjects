import 'package:flutter/material.dart';
import 'package:ez_entregas/Components/Carousel_Images.dart';
import 'package:ez_entregas/Components/ListProducts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String> imagesBanner = [
    'assets/images/burguer-example.jpg',
    'assets/images/burguer-example.jpg',
    'assets/images/burguer-example.jpg',
  ];


  List<Map<String, dynamic>> infoBanners = [
    {'nome':'Banner Home 1', 'type':'product', 'path': 'product-id'},
    {'nome':'Banner Home 2', 'type':'product', 'path': 'product-id'},
    {'nome':'Banner Home 3', 'type':'product', 'path': 'product-id'},
  ];


  @override
  Widget build(BuildContext context) {

    double heightBanner = (MediaQuery.of(context).size.height / 100) * 70;

    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          carouselImages(imagesBanner, infoBanners, height: heightBanner, borderRadius: 6),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(),
          ),
          listProducts('idcategoria', context, typeList: 'horizontal'),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(),
          ),
          listProducts('idcategoria', context, typeList: 'vertical'),
        ],
      ),
    );
  }
}
