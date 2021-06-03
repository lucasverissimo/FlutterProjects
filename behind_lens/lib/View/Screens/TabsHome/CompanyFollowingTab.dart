import 'package:behind_lens/Model/Entities/Company.dart';
import 'package:behind_lens/View/Common/ItemListUserCommon.dart';
import 'package:flutter/material.dart';

class CompanyFollowingTab extends StatefulWidget {
  @override
  _CompanyFollowingTabState createState() => _CompanyFollowingTabState();
}

class _CompanyFollowingTabState extends State<CompanyFollowingTab> {

  TextEditingController _controllerSearch = TextEditingController();

  List<Company> _usersList = [
    Company("1", "Company Name", "assets/logo.png", description: "Aqui vai uma pequina descrição da empresa"),
    Company("2", "Company Name", "assets/logo.png", description: "Aqui vai uma pequina descrição da empresa"),
    Company("3", "Company Name", "assets/logo.png", description: "Aqui vai uma pequina descrição da empresa"),
    Company("4", "Company Name", "assets/logo.png", description: "Aqui vai uma pequina descrição da empresa"),
    Company("5", "Company Name", "assets/logo.png", description: "Aqui vai uma pequina descrição da empresa"),
    Company("6", "Company Name", "assets/logo.png", description: "Aqui vai uma pequina descrição da empresa"),
    Company("7", "Company Name", "assets/logo.png", description: "Aqui vai uma pequina descrição da empresa"),
    Company("8", "Company Name", "assets/logo.png", description: "Aqui vai uma pequina descrição da empresa"),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xff444444),
                borderRadius: BorderRadius.circular(5)
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: TextField(
                      controller: _controllerSearch,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                        hintText: "Digite o nome da empresa...",
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true, // ativa ou desativa cor de fundo
                        fillColor: Color(0xff222222), // cor de fundo, so funciona se filled estiver true
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                        //prefixIcon: IconButton(icon: Icon(Icons.camera_alt, color: Color(0xff075e54), ), onPressed: (){},)
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: (){},
                  backgroundColor: Color(0xff222222),
                  child: Icon(
                    Icons.search_rounded,
                    color: Color(0xfffe386b),
                  ),
                  mini: true,
                ) ,
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 30),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _usersList.length,
                itemBuilder: (context, index){
                  return ItemListUserCommon(context, _usersList[index], "company");
                }
            ),
          ),
        ],
      ),
    );
  }
}
