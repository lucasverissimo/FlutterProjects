

import 'dart:io';

class Posts{

  String _id;
  String _description;
  String _image;
  File _imageFile;
  final DateTime datePost = DateTime.now().toUtc();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "id": this.id,
      "description" : this.description,
      "image": this.image,
      "imageFile": this.imageFile,
      "datePost": this.datePost
    };

    return map;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get description => _description;

  File get imageFile => _imageFile;

  set imageFile(File value) {
    _imageFile = value;
  }

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  set description(String value) {
    _description = value;
  }
}