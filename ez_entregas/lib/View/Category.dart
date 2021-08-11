// categoria que exibe produtos especificos.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_entregas/Components/AppBarDefault.dart';
import 'package:ez_entregas/Components/ListProducts.dart';

class Category extends StatefulWidget {
  String idCategory;
  Category(this.idCategory);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  String _title = "Nome Categoria";

  @override
  void initState() {
    super.initState();
    print(widget.idCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault(_title),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            listProducts(widget.idCategory, context),
            Padding(
              padding: EdgeInsets.only(top: 25, bottom: 15),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}
