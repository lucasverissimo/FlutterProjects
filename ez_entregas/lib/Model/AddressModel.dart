import 'package:flutter/material.dart';

class AddressModel{
  // dados entrega
  TextEditingController cCep = TextEditingController();
  TextEditingController cNum = TextEditingController();
  TextEditingController cStreet = TextEditingController();
  TextEditingController cNeigh = TextEditingController();
  TextEditingController cCity = TextEditingController();
  TextEditingController cComp = TextEditingController();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "cep":this.cCep.text,
      "num":this.cNum.text,
      "street":this.cStreet.text,
      "neigh":this.cNeigh.text,
      "city":this.cCity.text,
      "comp":this.cComp.text,
    };
    return map;
  }

}