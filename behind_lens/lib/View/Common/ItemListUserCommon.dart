import 'package:behind_lens/Model/Entities/Company.dart';
import 'package:behind_lens/Model/Entities/Users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


Widget ItemListUserCommon(BuildContext context, dynamic info, String typeInfo){

  double halfLarg = (MediaQuery.of(context).size.width / 100) * 20;
  return GestureDetector(
    onTap: (){
      Navigator.pushNamed(context, "/profile");
    },
    child: Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Color(0xff444444),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: halfLarg,
              height: halfLarg,
              child:  Container(),//Image.asset(user.photo),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(halfLarg),
                  image: DecorationImage(
                      image: AssetImage(info.photo),
                      fit: BoxFit.contain
                  )
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.name,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      Text(
                        typeInfo == "company" ? info.description : info.idCompany,
                        style: TextStyle(color: Color(0xff888888), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/*
* ListTile(
        title: Text(user.nome),
        subtitle: Text(user.idCompany),
        contentPadding: EdgeInsets.all(0),
        leading: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(user.photo),
              fit: BoxFit.cover
            ),
          ),
        ),
      )
*
* */